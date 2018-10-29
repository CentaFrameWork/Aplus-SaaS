//
//  RealListViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RealListViewController.h"
#import "UIView+Extension.h"
#import "TjRealListTableViewCell.h"
#import "RealListApi.h"
#import "RealSurveyStatusEnum.h"
#import "SelectRealVC.h"
#import "APUploadVideo.h"
#import "APUploadFile.h"
#import "VideoUploadViewController.h"
#import "UploadVideoTokenApi.h"
#import "UploadVideoTokenEntity.h"
#import "CheckRealSurveyEntity.h"


@interface RealListViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,APUploadVideoDelegate>
{
    RealListApi *_realListApi;

    APUploadVideo *_uploadVideo;          // 视频上传
    NSInteger _selectVideoIndex;          // 选择视频的下标
    NSMutableArray *_tableViewDataSource;
    NSMutableArray *_imageSource;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation RealListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self initNavTitle];
    [self initData];
    
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)headerRefreshMethod
{
    [_tableViewDataSource removeAllObjects];
    [self requestData];
}



- (void)initData
{
    _tableViewDataSource = [[NSMutableArray alloc]init];
    _realListApi = [RealListApi new];
    
    _uploadVideo = [APUploadVideo sharedUploadVideo];
    _uploadVideo.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self showLoadingView:nil];
    
    [self requestData];
}

- (void)requestData
{
    
    _realListApi.keyId = self.keyId;
    [_manager sendRequest:_realListApi];
    
    [self showLoadingView:nil];
    _imageSource = [NSMutableArray array];
}

- (void)initNavTitle
{
    [self setNavTitle:@"实勘列表"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return    [self setTableViewCell:indexPath];
//    return [_realListPresenter getTableViewCell:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RealSurveyEntity *realSurveyEntity = [_tableViewDataSource objectAtIndex:indexPath.row];
    
    NSString *realSurveyCount = [NSString stringWithFormat:@"%@",realSurveyEntity.photoCount];
    
    if (realSurveyCount > 0) {
        
     
            PhotoDownLoadImageViewController *photoDownImageVC = [[PhotoDownLoadImageViewController alloc]initWithNibName:@"PhotoDownLoadImageViewController" bundle:nil];
            photoDownImageVC.propKeyId = realSurveyEntity.keyId;
            photoDownImageVC.isItem = YES;
            [self.navigationController pushViewController:photoDownImageVC
                                                         animated:YES];
        
    }
}

// 是否可左滑添加视频
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{   
    
    
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"补传视频";
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 上传视频
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]; // Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
            if (availableMedia)
            {
                picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]]; // 设置媒体类型为public.movie
                picker.videoQuality = UIImagePickerControllerQualityTypeHigh;    // 不进行压缩
             }
            picker.delegate = self;
            _selectVideoIndex = indexPath.row;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        APUploadFile *uploadFile = [[APUploadFile alloc] init];
        uploadFile.estateName = _estateName;
        uploadFile.estateId = _keyId;
        uploadFile.startTime = [CommonMethod formatDateStrFromDate:[NSDate date]];
        
        NSArray *strArr =[[videoURL path] componentsSeparatedByString:@"/"];
        
        uploadFile.videoName = [strArr lastObject];//[NSString stringWithFormat:@"%@%@",@"VID_",uploadFile.startTime];
        uploadFile.videoTotalSize = [[NSData dataWithContentsOfURL:videoURL] length];
        uploadFile.uploadState = UploadStatusWaiting;
        
        uploadFile.uploadFileKey = [self getUniqueStrByUUID];//[NSString stringWithFormat:@"%ld",[CommonMethod getCurrentTimeInterval]];;
        uploadFile.uploadedSize = @"0.0M";
        uploadFile.fileUrl = videoURL;
        uploadFile.videoImage = [self imageWithVideo:videoURL];
        RealSurveyEntity *realSurveyEntity = (RealSurveyEntity *)_tableViewDataSource[_selectVideoIndex];
        uploadFile.realListIndex =  _selectVideoIndex;
        uploadFile.realKeyId =  realSurveyEntity.keyId;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (uploadFile.videoTotalSize/1024.0/1024.0 > 500.0)
        {
            [CustomAlertMessage showAlertMessage:@"您选取上传的视频超过500M，无法上传\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            return;
        }
        
        // 请求上传token
        [_manager sendRequest:[UploadVideoTokenApi new] sucBlock:^(id result) {
            
            UploadVideoTokenEntity *tokenEntity = [DataConvert convertDic:result toEntity:[UploadVideoTokenEntity class]];
            if ([self sharedAppDelegate].currentNetworkStatus != ReachableViaWiFi)
            {
                [self AlertWithTitle:@"当前网络为4G，是否继续上传?" message:nil andOthers:@[@"继续",@"取消"] animated:YES action:^(NSInteger index) {
                    
                    if (index == 0)
                    {
                        CheckRealSurveyEntity *propAllPhotos = [DataConvert convertDic:result toEntity:[CheckRealSurveyEntity class]];
                        
                        uploadFile.realImageArr = propAllPhotos.photos;
                        _uploadVideo.token = tokenEntity.token;
                        [_uploadVideo uploadWithUploadFile:uploadFile];
                        [CustomAlertMessage showAlertMessage:@"请在传输列表中查看视频上传进度\n\n" andButtomHeight:APP_SCREEN_HEIGHT/6];
                        [_mainTableView reloadData];
                    }
                }];
            }else
            {
                CheckRealSurveyEntity *propAllPhotos = [DataConvert convertDic:result toEntity:[CheckRealSurveyEntity class]];
                
                _uploadVideo.token = tokenEntity.token;
                uploadFile.realImageArr = propAllPhotos.photos;
                [_uploadVideo uploadWithUploadFile:uploadFile];
                [CustomAlertMessage showAlertMessage:@"请在传输列表中查看视频上传进度\n\n" andButtomHeight:APP_SCREEN_HEIGHT/6];
                [_mainTableView reloadData];
            }
            
        } failBlock:^(NSError *error) {
            
            showMsg(@"请求出错");
        }];
    }
    else
    {
//        NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSURL *videoURL = [NSURL fileURLWithPath:@"/Users/zhangwang/Downloads/T2-0603_1.mp4"];
        APUploadFile *uploadFile = [[APUploadFile alloc] init];
        uploadFile.estateName = _estateName;
        uploadFile.estateId = _keyId;
        uploadFile.startTime = [CommonMethod formatDateStrFromDate:[NSDate date]];
        uploadFile.videoName = [NSString stringWithFormat:@"%@%@",@"VID_",uploadFile.startTime];
        uploadFile.videoTotalSize = [[NSData dataWithContentsOfURL:videoURL] length];
        
        if (uploadFile.videoTotalSize > 131 * 1024 * 1024)
        {
            [CustomAlertMessage showAlertMessage:@"您选取上传的视频超过500M，无法上传\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            return;
        }
        
        [_mainTableView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        uploadFile.uploadState = UploadStatusWaiting;
        uploadFile.uploadedSize = @"0.0M";
        uploadFile.uploadFileKey = [self getUniqueStrByUUID];//[NSString stringWithFormat:@"%ld",[CommonMethod getCurrentTimeInterval]];
        uploadFile.fileUrl = videoURL;
        //UIImage * i = [self imageWithVideo:videoURL];
        RealSurveyEntity *realSurveyEntity = (RealSurveyEntity *)_tableViewDataSource[_selectVideoIndex];
        uploadFile.realListIndex =  _selectVideoIndex;
        uploadFile.realKeyId =  realSurveyEntity.keyId;
        
        [_manager sendRequest:[UploadVideoTokenApi new] sucBlock:^(id result) {
            
            UploadVideoTokenEntity *tokenEntity = [DataConvert convertDic:result toEntity:[UploadVideoTokenEntity class]];
            
            if ([self sharedAppDelegate].currentNetworkStatus != ReachableViaWiFi)
            {
                [self AlertWithTitle:@"当前网络为4G，是否继续上传?" message:nil andOthers:@[@"继续",@"取消"] animated:YES action:^(NSInteger index) {
                    
                    if (index == 0)
                    {
                        _uploadVideo.token = tokenEntity.token;
                        [[APUploadVideo sharedUploadVideo] uploadWithUploadFile:uploadFile];
                        [CustomAlertMessage showAlertMessage:@"请在传输列表中查看视频上传进度\n\n" andButtomHeight:APP_SCREEN_HEIGHT/6];
                    }
                }];
            }else
            {
                _uploadVideo.token = tokenEntity.token;
                [_uploadVideo uploadWithUploadFile:uploadFile];
                [CustomAlertMessage showAlertMessage:@"请在传输列表中查看视频上传进度\n\n" andButtomHeight:APP_SCREEN_HEIGHT/6];
                
                VideoUploadViewController * ceshi = [[VideoUploadViewController alloc] init];
                [self.navigationController pushViewController:ceshi animated:YES];
            }
        } failBlock:^(NSError *error) {
            
            showMsg(@"请求出错");
        }];
    }
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString ;
}

/// 视频上传完成
- (void)uploadFinish
{
    [self requestData];
}

/// 获取视频缩略图
- (UIImage *)imageWithVideo:(NSURL *)videoURL
{
    // 根据视频的URL创建AVURLAseet
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    // 根据AVURLAsset创建AVAssetImageGenerator对象
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    // 定义获取0帧处的视频截图
    CMTime time = CMTimeMake(27, 10);
    NSError *error = nil;
    CMTime actualTime;
    // 获取time处的视频截图
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    // 将CGImageRef转换为UIImage
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

#pragma mark - RealListViewProtocol
- (UITableViewCell *)setTableViewCell:(NSIndexPath *)indexPath
{
    static NSString *TjCellIdentifier = @"TjRealListTableViewCell";
//    static NSString *SzCellIdentifier = @"RealListTableViewCell";
    
    // 是否可以查看实勘状态
//    if ([_realListPresenter haveViewRealStatus])
//    {
//        RealListTableViewCell *realListTableViewCell = [_mainTableView dequeueReusableCellWithIdentifier:SzCellIdentifier];
//        if (!realListTableViewCell)
//        {
//            [_mainTableView registerNib:[UINib nibWithNibName:@"RealListTableViewCell"
//                                                  bundle:nil]
//            forCellReuseIdentifier:SzCellIdentifier];
//
//            realListTableViewCell = [_mainTableView dequeueReusableCellWithIdentifier:SzCellIdentifier];
//        }
//
//        if (_tableViewDataSource.count > 0)
//        {
//            NSInteger rowIndex = indexPath.row;
//            RealSurveyEntity *realSurveyEntity = (RealSurveyEntity *)_tableViewDataSource[rowIndex];
//            realListTableViewCell.realSurveyEntity = realSurveyEntity;
//        }
//
//        return realListTableViewCell;
//    }
//    else
//    {
        TjRealListTableViewCell *tjRealListTableViewCell = [_mainTableView dequeueReusableCellWithIdentifier:TjCellIdentifier];
        
        if (!tjRealListTableViewCell)
        {
            [_mainTableView registerNib:[UINib nibWithNibName:@"TjRealListTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:TjCellIdentifier];
            
            tjRealListTableViewCell = [_mainTableView dequeueReusableCellWithIdentifier:TjCellIdentifier];
        }
        
        // 广州上传视频
      
            tjRealListTableViewCell.numberLabelRightConstant.constant = 20.0;
            tjRealListTableViewCell.uploadStatus.hidden = YES;
        
        
        if (_tableViewDataSource.count > 0)
        {
            NSInteger rowIndex = indexPath.row;
            RealSurveyEntity *realSurveyEntity = (RealSurveyEntity *)_tableViewDataSource[rowIndex];
            tjRealListTableViewCell.realSurveyEntity = realSurveyEntity;
        }
        
        return tjRealListTableViewCell;
//    }
}

-(void)dealloc
{
    _uploadVideo.delegate = nil;
    [_mainTableView setEditing:NO];
}

#pragma mark - ResponseDelegate

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if([modelClass isEqual:[RealSurveyListEntity class]])
    {
        RealSurveyListEntity *propOnlyTrustListEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_tableViewDataSource removeAllObjects];
        [_tableViewDataSource addObjectsFromArray:propOnlyTrustListEntity.realSurveys];
        
        if(_tableViewDataSource.count <= 0)
        {
        }
        
        [self endRefreshWithTableView:_mainTableView];
        [_mainTableView reloadData];
    }

}

@end
