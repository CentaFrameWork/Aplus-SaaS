//
//  CallRecordViewController.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CallRecordViewController.h"
#import "CallRecordTableViewCell.h"
#import "UILabel+Extension.h"
#import "PropertyCallRecordApi.h"
#import "PropertyCallRecordEntity.h"
#import "PropertyCallRecordResultEntity.h"

#import "CallRecordFilterVC.h"

#define DeviceProximityStateNotify  @"UIDeviceProximityStateDidChangeNotification"  //监听设备听筒or扬声器

#define  RecordingExists       @"existence" // 录音存在
#define  NoRecord              @"none"      // 录音不存在
#define  PlayRecording         @"playRecording" // 播放录音
#define  PlayPause             @"playPause" // 暂停录音


static NSString *CellIdentifier = @"callRecordCell";

@interface CallRecordViewController ()<UITableViewDelegate,UITableViewDataSource,CallRecordCellDelegate,CallRecordFilterDelegete,AVAudioPlayerDelegate>
{
    PropertyCallRecordApi *_callRecordApi;
    UITableView *_tableView;
    NSMutableArray *_dataSourceArray;
    BOOL _isOpen;
    NSIndexPath *_indePath;
    NSMutableArray *_cellHeightArray;
    NSMutableData *receiveData;
    NSInteger _playIndex;
    NSInteger _pauseIndex;
    NSInteger _curOpreateIndex;
    CGFloat allLength;

    BOOL _isReceiveURL;
    
    AVAudioPlayer *_audioPlayer; // 录音播放器
    AVAudioSession *_audioSession;      //录音、播放音频设置

    RemindPersonDetailEntity *_deptRemindPersonDetailEntity;
    RemindPersonDetailEntity *_employeeRemindPersonDetailEntity;
    NSString *_startTime;
    NSString *_endTime;
}

@end

@implementation CallRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

#pragma mark - Init

- (void)initView
{
    [self setNavTitle:@"通话记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"筛选"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(goFilterVC)]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 74);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
//    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshMethod)];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshMethod)];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
}

- (void)initData
{
    _isOpen = NO;
    _cellHeightArray = [NSMutableArray array];
    _dataSourceArray = [NSMutableArray array];
    _playIndex = -1;
    _pauseIndex = -1;
    _curOpreateIndex = -1;
    
    [self headerRefreshMethod];
    [self showLoadingView:nil];
}

#pragma mark - RequestData

- (void)headerRefreshMethod
{
    _callRecordApi = [PropertyCallRecordApi new];
    _callRecordApi.propertyKeyId = _propertyKeyId;
    _callRecordApi.scope = [self getCallRecordPermission];
    _callRecordApi.pageIndex = @"1";
    _callRecordApi.startTime = _startTime;
    _callRecordApi.endTime = _endTime;
    _callRecordApi.deptKeyId = _deptRemindPersonDetailEntity.departmentKeyId ? _deptRemindPersonDetailEntity.departmentKeyId :@"";
    _callRecordApi.userKeyId = _employeeRemindPersonDetailEntity.resultKeyId ? _employeeRemindPersonDetailEntity.resultKeyId :@"";
    
    [_manager sendRequest:_callRecordApi];
}

- (void)footerRefreshMethod
{
    [self showLoadingView:nil];
    
    NSInteger pageIndex = [_callRecordApi.pageIndex integerValue] + 1;
    
    _callRecordApi = [PropertyCallRecordApi new];
    _callRecordApi.propertyKeyId = _propertyKeyId;
    _callRecordApi.scope = [self getCallRecordPermission];
    _callRecordApi.pageIndex = [NSString stringWithFormat:@"%ld",pageIndex];
    _callRecordApi.startTime = _startTime;
    _callRecordApi.endTime = _endTime;
    _callRecordApi.deptKeyId = _deptRemindPersonDetailEntity.departmentKeyId ? _deptRemindPersonDetailEntity.departmentKeyId :@"";
    _callRecordApi.userKeyId = _employeeRemindPersonDetailEntity.resultKeyId ? _employeeRemindPersonDetailEntity.resultKeyId :@"";

    [_manager sendRequest:_callRecordApi];
}

#pragma mark - ClickEvent

// go筛选页面
- (void)goFilterVC
{
    CallRecordFilterVC *filterVC = [CallRecordFilterVC new];
    filterVC.delegate = self;
    filterVC.remindPersonDetailEntity1 = _deptRemindPersonDetailEntity;
    filterVC.remindPersonDetailEntity2 = _employeeRemindPersonDetailEntity;
    filterVC.startTimeShow = _startTime;
    filterVC.endTimeShow = _endTime;
    
    [self.navigationController pushViewController:filterVC animated:YES];
}

/// 播放录音
- (void)createPlayerWithVoiceFileUrl:(NSString *)fileUrl
{
    [self showLoadingView:nil];
    //异步播放，边缓冲边播放,异步连接
    NSString *urlString = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url = %@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    //异步请求数据
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    //给状态栏加菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (NSString *)getCallRecordPermission
{
    NSString *permissionStr = @"";
    
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_CALLLOG_MODIFY_ALL]) {
        permissionStr = PROPERTY_CALLLOG_MODIFY_ALL;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_CALLLOG_MODIFY_MYDEPARTMENT]){
        permissionStr = PROPERTY_CALLLOG_MODIFY_MYDEPARTMENT;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_CALLLOG_MODIFY_MYSELF]){
        permissionStr = PROPERTY_CALLLOG_MODIFY_MYSELF;
    }
    
    return permissionStr;
}


#pragma mak - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response=== %@",[response suggestedFilename]);
    NSLog(@"要下载文件大小为 %lld",response.expectedContentLength);
    
    [self showLoadingView:nil];
    receiveData = [[NSMutableData alloc] init];
    allLength = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    _isReceiveURL = YES;
    [receiveData  appendData:data];
    
    if (_audioPlayer.playing) {
        
        [_audioPlayer stop];
    }
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:receiveData error:nil];
    _audioPlayer.delegate = self;
//    _audioPlayer.volume = 0.5;          //播放音量
    _audioPlayer.numberOfLoops = 0;     //设置播放不循环
    
    //设置APP活跃状态
    [self set_audioSessionActiveWithState:YES
                          andIsPlayVoice:YES];
    
    //监听听筒or扬声器
    [self handleNotification:YES];
    
    
    if ([receiveData length] > 20000) {
        
        if (_audioPlayer == nil) {
            
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:receiveData error:nil];
            [_audioPlayer prepareToPlay];
            
        }else if (_audioPlayer.isPlaying == NO){
            
            [_audioPlayer play];
            
        }
    }
    else
    {
        _isReceiveURL = NO;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"加载完毕...");
    [self hiddenLoadingView];
    
    // 缓冲完成后关闭菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 未得到data
    if (!_isReceiveURL)
    {
        showMsg(@"文件损坏或不存在");
        _playIndex = -1;
        _pauseIndex = -1;
        _curOpreateIndex = -1;
        [_tableView reloadData];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

//==================================================================

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _playIndex = -1;
    [_tableView reloadData];
    
    [_audioPlayer stop];
    
    // 设置app为不活跃状态
    [self set_audioSessionActiveWithState:NO
                          andIsPlayVoice:YES];
    
    // 取消监听听筒or扬声器
    [self handleNotification:NO];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

#pragma mark - 监听听筒or扬声器
- (void)handleNotification:(BOOL)state
{
    // 建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
    
    if(state)
    {
        // 添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:DeviceProximityStateNotify
                                                   object:nil];
    }
    else
    {
        // 移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:DeviceProximityStateNotify
                                                      object:nil];
    }
}

// 处理监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    // 如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                            error:nil];
    }
    else
    {
        [_audioSession setCategory:AVAudioSessionCategoryPlayback
                            error:nil];
    }
}



/**
 *  AV_audioSession是否active，设置app的active为yes，然后才能播放
 *
 *  @param isActive     是否活跃
 *  @param isPlayVoice  是否是播放声音，如果是播放声音，设置默认扬声器播放
 */
- (void)set_audioSessionActiveWithState:(BOOL)isActive andIsPlayVoice:(BOOL)isPlayVoice
{
    NSError *error;
    // 得到AV_audioSession单例对象
    _audioSession = [AVAudioSession sharedInstance];
    
    // 设置类别,表示该应用同时支持播放和录音
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (isPlayVoice)
    {
        // 默认情况下扬声器播放
        [_audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    }
    
    //设置“移动A+”正在播放、录音
    [_audioSession setActive:isActive error:&error];
    
}

- (void)dealloc
{
    //在页面销毁时 设置app为不活跃状态
    [self set_audioSessionActiveWithState:NO andIsPlayVoice:YES];
    //取消监听听筒or扬声器
    [self handleNotification:NO];
    
}

#pragma mark - CallRecordFilterDelegete
- (void)commitDataWithDepartment:(RemindPersonDetailEntity *)departEntity withEmployee:(RemindPersonDetailEntity *)employeeEntity withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime
{
    _deptRemindPersonDetailEntity = departEntity;
    _employeeRemindPersonDetailEntity = employeeEntity;
    _startTime = startTime;
    _endTime = endTime;
    
    [_dataSourceArray removeAllObjects];
    
    [self headerRefreshMethod];
}

/// 点击播放(暂停)按钮
- (void)clickPlayButtonIndexPath:(NSIndexPath *)indexPath andStuts:(NSString *)stuts
{
    if ([stuts isEqualToString:NoRecord])
    {
        // 无录音 不做处理
        return;
    }
    
    PropertyCallRecordResultEntity *entity = _dataSourceArray[indexPath.row];
    
    if(entity.tape && ![entity.tape isEqualToString:@""])
    {
        _pauseIndex = -1;
        if(_curOpreateIndex == indexPath.row)
        {
            if (_audioPlayer.playing)
            {
                [_audioPlayer stop];
                _playIndex = -1;
                _pauseIndex = indexPath.row;
                [_audioPlayer pause];
                [_tableView reloadData];
                
                //取消监听听筒or扬声器
                [self handleNotification:NO];
            }
            else
            {
                _playIndex = indexPath.row;
                [_tableView reloadData];
                [_audioPlayer play];
                
                //添加监听听筒or扬声器
                [self handleNotification:YES];
            }
        }
        else
        {
            if (_audioPlayer.playing)
            {
                [_audioPlayer stop];
            }
            _curOpreateIndex = indexPath.row;
            _playIndex = indexPath.row;
            [_tableView reloadData];
            _isReceiveURL = NO;
            [self createPlayerWithVoiceFileUrl:entity.tape];
        }
    }
    else
    {
        showMsg(@"暂无录音！");
    }
}

#pragma mark - CallRecordCellDelegate

// 点击"点击展开"/"点击收起"后返回
- (void)changeCellHeight:(NSIndexPath *)indexRow andHasFollowUp:(BOOL)hasFollowUp
{
    _isOpen = hasFollowUp;
    _indePath = indexRow;
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellHeight = 0;
    
//    if (_tableView.isFooterRefreshing)
     if (_tableView.mj_footer.isRefreshing)
    {
        if (_cellHeightArray.count - 1 >= indexPath.row )
        {
            NSString *cellHeight = _cellHeightArray[indexPath.row];
            return [cellHeight floatValue];
        }
    }
    
//    if (_tableView.isHeaderRefreshing)
    if (_tableView.mj_header.isRefreshing)
    {
        _indePath = nil;
    }
    
    if (_cellHeightArray.count == _dataSourceArray.count && _indePath.row != indexPath.row)
    {
        NSString *cellHeight = _cellHeightArray[indexPath.row];
        return [cellHeight floatValue];
    }
    
    float callRecordButtonHight = 0;
    float addTextHeight = 0;

    
    PropertyCallRecordResultEntity *entity = _dataSourceArray[indexPath.row];
    // 跟进记录宽度
    float labelWidth = APP_SCREEN_WIDTH - 30 - 10 - 10 - 20;
    float textHeight = [entity.relevantFollow heightWithLabelFont:[UIFont systemFontOfSize:14] withLabelWidth:labelWidth];
    
    if (_isOpen && [_indePath isEqual:indexPath])
    {
        addTextHeight = textHeight - 17;
    }

    if (textHeight >= 50)
    {
        //点击展开按钮  显示
        callRecordButtonHight = 20;
    }
    
    cellHeight = 105 + callRecordButtonHight + addTextHeight;
    _cellHeightArray[indexPath.row] = [NSString stringWithFormat:@"%ld",(long)cellHeight];
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallRecordTableViewCell *callRecordCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!callRecordCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CallRecordTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        callRecordCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    [callRecordCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    callRecordCell.delegate = self;
    
    PropertyCallRecordResultEntity *entity = _dataSourceArray[indexPath.row];
    callRecordCell.contactsLabel.text = entity.owner;
    callRecordCell.timeLabel.text = [CommonMethod getDetailedFormatDateStrFromTime:entity.callTime];
    callRecordCell.operatorLabel.text = entity.operatorStr;
    callRecordCell.operatorDepartmentLabel.text = entity.operationDepart;
    callRecordCell.relatedFollowUp.text = [NSString stringWithFormat:@"相关跟进：%@",entity.relevantFollow ? entity.relevantFollow :@""];
    callRecordCell.indexRow = indexPath;
    
    if (!_indePath)
    {
        callRecordCell.followUpHeight.constant = 40;
        [callRecordCell.listenImage setImage:[UIImage imageNamed:@"listenSoundRecording"]];
        [callRecordCell.openButton setTitle:@"点击展开" forState:UIControlStateNormal];
        callRecordCell.imageLayoutHeight.constant = 18;
        callRecordCell.buttonLayoutHeight.constant = 18;
    }
    
    if(entity.tape && ![entity.tape isEqualToString:@""])
    {
        if(_playIndex == indexPath.row)
        {
            [callRecordCell.listenImage setImage:[UIImage imageNamed:@"playPause"]];
            
        }
        else if(_pauseIndex == indexPath.row)
        {
            [callRecordCell.listenImage setImage:[UIImage imageNamed:@"playRecording"]];
        }
        else
        {
            [callRecordCell.listenImage setImage:[UIImage imageNamed:@"listenSoundRecording"]];
        }
    }else{
        [callRecordCell.listenImage setImage:[UIImage imageNamed:@"noRecording"]];
    }

    // 跟进记录宽度
    float labelWidth = APP_SCREEN_WIDTH - 30 - 10 - 10 - 20 - 5;
    float textHeight = [callRecordCell.relatedFollowUp.text heightWithLabelFont:[UIFont systemFontOfSize:14] withLabelWidth:labelWidth];
    
    if (textHeight > 51){
        //点击展开按钮  显示
        callRecordCell.openButton.hidden = NO;
        
        if(_isOpen && [_indePath isEqual:indexPath]){
            //点击展开
            callRecordCell.followUpHeight.constant = textHeight + 5;
            callRecordCell.imageLayoutHeight.constant =  textHeight / 2;
            callRecordCell.buttonLayoutHeight.constant =  textHeight / 2;
            [callRecordCell.openButton setTitle:@"点击收起" forState:UIControlStateNormal];
        }
        
        if(!_isOpen && [_indePath isEqual:indexPath]){
            //点击收起
            callRecordCell.followUpHeight.constant = 40;
            callRecordCell.imageLayoutHeight.constant = 18;
            callRecordCell.buttonLayoutHeight.constant = 18;
            [callRecordCell.openButton setTitle:@"点击展开" forState:UIControlStateNormal];
        }
        
        // 原来就已展开
        if (_cellHeightArray.count == _dataSourceArray.count && _indePath.row != indexPath.row)
        {
            NSString *cellHeight = _cellHeightArray[indexPath.row];
            if ([cellHeight floatValue] > 126) {
                callRecordCell.followUpHeight.constant = textHeight + 5;
                callRecordCell.imageLayoutHeight.constant =  textHeight / 2;
                callRecordCell.buttonLayoutHeight.constant =  textHeight / 2;
                [callRecordCell.openButton setTitle:@"点击收起" forState:UIControlStateNormal];
            }else{
                callRecordCell.followUpHeight.constant = 40;
                callRecordCell.imageLayoutHeight.constant = 18;
                callRecordCell.buttonLayoutHeight.constant = 18;
                [callRecordCell.openButton setTitle:@"点击展开" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        // 点击展开按钮  隐藏
        callRecordCell.openButton.hidden = YES;
        callRecordCell.followUpHeight.constant = 40;
        callRecordCell.imageLayoutHeight.constant = 18;
        callRecordCell.buttonLayoutHeight.constant = 18;
    }
    
    return callRecordCell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >=  7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        
        if (MODEL_VERSION >=  8.0)
        {
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    [self endRefreshWithTableView:_tableView];
    
    if ([modelClass isEqual:[PropertyCallRecordEntity class]])
    {
        PropertyCallRecordEntity *callRecordEntity = [DataConvert convertDic:data toEntity:modelClass];
        
//        if (_tableView.isHeaderRefreshing)
        if (_tableView.mj_header.isRefreshing)
        {
            
            [_dataSourceArray removeAllObjects];
             [_cellHeightArray removeAllObjects];
            _playIndex = -1;
            _pauseIndex = -1;
            _curOpreateIndex = -1;
        }
        
        if (callRecordEntity.result.count < 10 || !callRecordEntity.result)
        {
//            _tableView.footerHidden = YES;
             _tableView.mj_footer.hidden = YES;
        }
        else
        {
//            _tableView.footerHidden = NO;
             _tableView.mj_footer.hidden = NO;
        }
        
        [_dataSourceArray addObjectsFromArray:callRecordEntity.result];
        [_tableView reloadData];
    }
}

@end
