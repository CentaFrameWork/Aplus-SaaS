//
//  VideoUploadViewController.m
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//

#import "VideoUploadViewController.h"
#import "UploadListCell.h"
#import "UploadModel.h"
#import "APUploadVideo.h"
#import "APUploadFile.h"
#import "UploadStatusDefine.h"
#import "Utility.h"
#import "AllRoundDetailViewController.h"

#define TableViewBaseTag            1000

@interface VideoUploadViewController ()<UITableViewDelegate, UITableViewDataSource,APUploadVideoDelegate>
@property (nonatomic, strong) VideoUploadMainView *mainView;
@property (nonatomic, strong) NSMutableArray *uploadListArray;
@property (nonatomic, strong) APUploadVideo *uploadVideo;
@end

@implementation VideoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    [self initData];
    [self initView];

    // Do any additional setup after loading the view.
}

- (void)setNaviTitle{
    [self setNavTitle:@"传输列表"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

/// 初始化数据
- (void)initData{
    _uploadVideo = [APUploadVideo sharedUploadVideo];
    _uploadVideo.delegate = self;
    self.uploadListArray = [[_uploadVideo getUploadTaskArr] mutableCopy];
}

/// 当前上传的进度
- (void)uploadingProgress:(float)percent fileIndex:(NSInteger)index
{
    UploadListCell *cell = [_uploadListTab viewWithTag:TableViewBaseTag + index];
    
    if (self.uploadListArray.count > 0 && index < self.uploadListArray.count)
    {
        [cell setUploadModel:self.uploadListArray[index]];
    }
}

/// 每两秒计算上传速度
- (void)uploadSpeedfileIndex:(NSInteger)index
{
    UploadListCell *cell = [_uploadListTab viewWithTag:TableViewBaseTag + index];
    if (self.uploadListArray.count > 0 && index < self.uploadListArray.count)
    {
        [cell setUploadModel:self.uploadListArray[index]];
    }
}

/// 上传完成
- (void)uploadFinish
{
    self.uploadListArray = [[_uploadVideo getUploadTaskArr] mutableCopy];
    [self.mainView setCount:self.uploadListArray.count];
    [_uploadListTab reloadData];
}

    /// 初始化视图
- (void)initView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainView = [[VideoUploadMainView alloc] init];
    self.mainView.frame = self.view.bounds;
    [self.mainView setCount:self.uploadListArray.count];
    [self.view addSubview:self.mainView];

    self.uploadListTab = self.mainView.uploadListTab;
    self.uploadListTab.delegate = self;
    self.uploadListTab.dataSource = self;
}

#pragma mark -----------------------   Tab  -------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.uploadListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"uploadVideo";
    UploadListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UploadListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:iden];
    }
    cell.tag = TableViewBaseTag + indexPath.row;
    [cell setUploadModel:self.uploadListArray[indexPath.row]];
    WS(weakSelf)
    cell.changeSequence = ^(UploadStatus status){
        StrongSelf(strongSelf)
        [strongSelf  changeUploadSepuence:indexPath andStatus:status];
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APUploadFile *uploadFile= self.uploadListArray[indexPath.row];
    AllRoundDetailViewController *allRoundDetailVC = [[AllRoundDetailViewController alloc] initWithNibName:@"AllRoundDetailViewController"
                                                                                                    bundle:nil];
    allRoundDetailVC.propKeyId = uploadFile.estateId;
    [self.navigationController pushViewController:allRoundDetailVC animated:YES];
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [self AlertWithTitle:@"是否停止上传并删除该视频？" message:nil andOthers:@[@"确定",@"取消"] animated:YES action:^(NSInteger index)
    {
        if (index == 0)
        {
            // 取消上传
            APUploadFile *file =  [_uploadVideo getUploadTaskArr][indexPath.row];
            if (file.uploadState == UploadStatusUploading)
            {
                [_uploadVideo pauseUploadWithUploadFile:file];
            }
            
            [self.uploadListArray removeObjectAtIndex:indexPath.row];
            [_uploadVideo.uploadTaskArr removeObjectAtIndex:indexPath.row];
            [_uploadVideo otherTaskContinueUploadFile];
            [self.mainView setCount:self.uploadListArray.count];
            [_uploadListTab setEditing:NO];
            [_uploadListTab reloadData];
        }
    }];
}

- (void)changeUploadSepuence:(NSIndexPath *)indexPath andStatus:(UploadStatus)status
{
    if (indexPath.row < self.uploadListArray.count)
    {
        APUploadFile *file =  [_uploadVideo getUploadTaskArr][indexPath.row];
        if (status == UploadStatusWaiting)
        {
            // 等待中
            file.uploadState = UploadStatusWaiting;
            
            // 没有任务让它继续上传
            if (!_uploadVideo.isHaveUploadTask)
            {
                // 网络提示
                if ([self sharedAppDelegate].currentNetworkStatus == ReachableViaWiFi)
                {
                    file.uploadState = UploadStatusUploading;
                    [_uploadVideo continueUploadWithUploadFile:file];
                }else
                {
                    file.uploadState = UploadStatusPause;
                    [self AlertWithTitle:@"当前网络为4G，是否继续上传?" message:nil andOthers:@[@"继续",@"取消"] animated:YES action:^(NSInteger index) {
                        
                        if (index == 0)
                        {
                            file.uploadState = UploadStatusUploading;
                            [_uploadVideo continueUploadWithUploadFile:file];
                        }
                    }];
                }
            }
        }
        else
        {
            // 暂停
            if (_uploadVideo.isHaveUploadTask)
            {
                file.uploadState = UploadStatusPause;
                
                if(_uploadVideo.currentUploadIndex == indexPath.row)
                {
                    [_uploadVideo pauseUploadWithUploadFile:file];
                }
                
            }else
            {
                //  点击等待中没有上传任务则开始上传
                file.uploadState = UploadStatusWaiting;
                [_uploadVideo otherTaskContinueUploadFile];
            }
        }
        
        [_uploadListTab reloadData];
    }
}

- (void)dealloc
{
    _uploadVideo.delegate = nil;
}

@end
