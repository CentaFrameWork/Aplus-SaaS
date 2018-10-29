//
//  ChannelDetailViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/16.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelDetailViewController.h"
#import "STKAudioPlayer.h"

#define DeviceProximityStateNotify  @"UIDeviceProximityStateDidChangeNotification"  //监听设备听筒or扬声器

@interface ChannelDetailViewController ()
{
//    AVAudioPlayer *audioPlayer;        //播放录音
    STKAudioPlayer *_audioPlayer;
    BOOL _isPlaying;                     // 是否在播放

    AVAudioSession *audioSession;      //录音、播放音频设置
    NSInteger playIndex;
    NSInteger pauseIndex;
    NSInteger curOpreateIndex;
    CGFloat allLength;
    NSMutableData *receiveData;
    NSMutableArray *_tableViewDataSource;
    BOOL _isReceiveURL;
    
    ChannelDetailApi *_channelDetailApi;
}

@end

@implementation ChannelDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initData ];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sharedAppDelegate].notifyDelegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self sharedAppDelegate].notifyDelegate = nil;
}

#pragma mark - init

- (void)initView
{
    [self setNavTitle:@"来电详情"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
                                rightButtonItem:nil];

//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];

    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhonePress)];
    singleTap.numberOfTapsRequired = 1; //点击次数
    singleTap.numberOfTouchesRequired = 1; //点击手指数
    [_topView addGestureRecognizer:singleTap];
}

- (void)initData
{
    self.phoneLabel.text = _phoneNum;
    
    playIndex = -1;
    pauseIndex = -1;
    curOpreateIndex = -1;
    _tableViewDataSource = [[NSMutableArray alloc]init];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    //不可上拉更多
//    _mainTableView.footerHidden = NO;
    _mainTableView.mj_footer.hidden = NO;
}

#pragma mark - ClickEvents

- (void)callPhonePress
{
    NSLog(@"拨打电话");
    if(_phoneNum && ![_phoneNum isEqualToString:@""]){
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

/// 使用本地url创建player
- (void)createPlayerWithVoiceFileUrl:(NSString *)fileUrl
{
    [self showLoadingView:nil];
    // 异步播放，边缓冲边播放,异步连接
    NSString *urlString = [fileUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    // 异步请求数据
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    // 给状态栏加菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - RequestData

- (void)headerRefreshMethod
{
    [_tableViewDataSource removeAllObjects];
    [_mainTableView reloadData];
    
    [self requestData];
}

- (void)requestData
{
    [self showLoadingView:nil];

    _channelDetailApi = [[ChannelDetailApi alloc] init];
    _channelDetailApi.keyId = _keyId;
    [_manager sendRequest:_channelDetailApi];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewDataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"channelDetailTableViewCell";
    
    ChannelDetailTableViewCell *channelDetailTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!channelDetailTableViewCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ChannelDetailTableViewCell"
                                              bundle:nil]
                              forCellReuseIdentifier:CellIdentifier];
        
        channelDetailTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    ChannelDetailModel *channelDeltail = _tableViewDataSource[row];
    
    NSString *time = [CommonMethod dateConcretelyTime:[CommonMethod tryTimeNumberWith:channelDeltail.startTime] andYearNum:[[channelDeltail.startTime substringToIndex:4] integerValue]];

    channelDetailTableViewCell.timeLabel.text = time;
    channelDetailTableViewCell.channelSource.text = channelDeltail.channelInquirySource;
    channelDetailTableViewCell.propInfoLabel.text = channelDeltail.otherNetComment;
    channelDetailTableViewCell.timeSpanLabel.text = channelDeltail.callerTimespan;
    
    if (channelDeltail.recordingUrl && ![channelDeltail.recordingUrl isEqualToString:@""])
    {
        if (playIndex == row)
        {
            [channelDetailTableViewCell.voiceImg setImage:[UIImage imageNamed:@"stop"]];
        }
        else if(pauseIndex == indexPath.row)
        {
            [channelDetailTableViewCell.voiceImg setImage:[UIImage imageNamed:@"play"]];
        }
        else
        {
            [channelDetailTableViewCell.voiceImg setImage:[UIImage imageNamed:@"headset"]];
        }
    }
    else
    {
        [channelDetailTableViewCell.voiceImg setImage:[UIImage imageNamed:@"headset"]];
    }

    return channelDetailTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    ChannelDetailModel *channelDetail = _tableViewDataSource[row];
    NSString *recordingUrl = channelDetail.recordingUrl;
    
    if(recordingUrl && ![recordingUrl isEqualToString:@""])
    {
        pauseIndex = -1;
        
        if (!_audioPlayer)
        {
            _audioPlayer = [[STKAudioPlayer alloc]init];
        }
        
        NSLog(@"curOpreateIndex = %ld row = %ld",curOpreateIndex,row);
        
        if(curOpreateIndex == row)
        {
            if (_isPlaying)
            {
                playIndex = -1;
                pauseIndex = row;
                [_audioPlayer pause];
                _isPlaying = NO;
                [_mainTableView reloadData];
                
                //取消监听听筒or扬声器
//                [self handleNotification:NO];
            }
            else
            {
                playIndex = row;
                [_mainTableView reloadData];
                [_audioPlayer resume];
                _isPlaying = YES;
                
//                [audioPlayer play];
                
                //添加监听听筒or扬声器
//                [self handleNotification:YES];
            }
        }
        else
        {
            if (_isPlaying)
            {
                [_audioPlayer stop];
            }
            
            curOpreateIndex = row;
            playIndex = row;
            [_mainTableView reloadData];
            _isReceiveURL = NO;
            [_audioPlayer playURL:[NSURL URLWithString:recordingUrl]];
            _isPlaying = YES;
        }
    }
    else
    {
        showMsg(@"暂无录音！");
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

#pragma mark - 监听听筒or扬声器

- (void)handleNotification:(BOOL)state
{
    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
    
    if(state)//添加监听
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:DeviceProximityStateNotify
                                                   object:nil];
    }
    else//移除监听
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:DeviceProximityStateNotify
                                                      object:nil];
    }
}

/// 处理监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    // 如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord  error:nil];
    }
    else
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

/**
 *  AVAudioSession是否active，设置app的active为yes，然后才能播放
 *
 *  @param isActive     是否活跃
 *  @param isPlayVoice  是否是播放声音，如果是播放声音，设置默认扬声器播放
 */
- (void)setAudioSessionActiveWithState:(BOOL)isActive andIsPlayVoice:(BOOL)isPlayVoice
{
    NSError *error;
    
    // 得到AVAudioSession单例对象
    audioSession = [AVAudioSession sharedInstance];
    
    // 设置类别,表示该应用同时支持播放和录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (isPlayVoice)
    {
        // 默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    }
    
    //设置“移动A+”正在播放、录音
    [audioSession setActive:isActive error:&error];
}

- (void)dealloc
{
    _audioPlayer = nil;
    //在页面销毁时 设置app为不活跃状态
    [self setAudioSessionActiveWithState:NO andIsPlayVoice:YES];
    //取消监听听筒or扬声器
    [self handleNotification:NO];
}

#pragma mark - <AppLifeCycleDelegate>

- (void)appDidEnterBackground:(UIApplication *)application
{
    NSLog(@"录音要暂停了哦...");
    [_audioPlayer pause];
    if(playIndex != -1)
    {
        pauseIndex = playIndex;
        playIndex = -1;
        [_mainTableView reloadData];
    }
}

- (void)appWillEnterForeground:(UIApplication *)application
{
    NSLog(@"录音继续哦...");
}

#pragma mark - <ResponseDelegte>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self endRefreshWithTableView:_mainTableView];

    if([modelClass isEqual:[ChannelDetailEntity class]])
    {
        ChannelDetailEntity *channelDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_tableViewDataSource addObjectsFromArray:channelDetailEntity.result];
    }

    [_mainTableView reloadData];
    [self hiddenLoadingView];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
}

@end
