//
//  VoiceRecordViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "VoiceRecordViewController.h"
#import "VoiceListCell.h"
#import <AVFoundation/AVFoundation.h>
#import "DataBaseOperation.h"




#define WAVE_UPDATE_FREQUENCY   0.05    //更新语音分贝
#define MaxRecordTime           120     //录音最大秒数


#define YCDeleteVoice           1001


#define DeviceProximityStateNotify  @"UIDeviceProximityStateDidChangeNotification"  //监听设备听筒or扬声器

@interface VoiceRecordViewController ()<UITableViewDataSource,UITableViewDelegate,
AVAudioRecorderDelegate,AVAudioPlayerDelegate,VoiceListCellDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *_recordVoiceBtn;
    
    AVAudioRecorder *_audioRecorder;    //录音实例
    AVAudioPlayer *_audioPlayer;        //播放录音
    AVAudioSession *_audioSession;      //录音、播放音频设置
    
    
    NSTimer *_timer;        //设置录音音量监听计时器
    BOOL _isRecording;      //是否正在录音中
    
    __weak IBOutlet UIImageView *_voiceRecordSignImgView;   //录音提示框
    __weak IBOutlet UIView *_voiceRecordSignBgView;         //录音提示框大背景view
    
    DataBaseOperation *_dataBaseOperation;  //数据库操作对象
    
    NSMutableArray *_voiceRecordFiles;      //录音数据源
    
    NSString *_currentVoiceFileName;        //当前录音的文件名
    NSString *_currentVoiceFileTime;        //当前录音文件的时间
    
    NSInteger _recordTimeLength;            //录音长度
    
    BOOL _isCancelRecord;                   //是否取消录音
    
    NSInteger _deleteItemIndex;             //要删除录音的index
    
    UIImageView *_animationImageView;       //播放录音时的图片动画
    BOOL _istouched;//是否已点击开始录音
}

@property (nonatomic,strong) UIImageView *lastImageView;

@end

@implementation VoiceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"录音"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    [self initData];
    [self getVoiceRecordFiles];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self handleNotification:NO];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)initData {
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"VoiceListCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"voiceListCell"];
    _mainTableView.delegate = self;
    _voiceRecordFiles = [[NSMutableArray alloc]init];
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
	
}

#pragma mark - ************UITableView*********
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _voiceRecordFiles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceListCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.voiceRecordPlayItem.tag = indexPath.row;
    cell.dict = [_voiceRecordFiles objectAtIndex:indexPath.row];;
    
   
    return cell;
    
}




/**
 *  获取此房源的所有录音文件
 */
-(void)getVoiceRecordFiles
{
    
    [_voiceRecordFiles removeAllObjects];
    
    [_voiceRecordFiles addObjectsFromArray:[_dataBaseOperation selectVoiceRecordFilesWithPropId:_propId]];
    
    [_mainTableView reloadData];
    
    if (_voiceRecordFiles.count > 0) {
        
        //滑动至列表底部
        [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_voiceRecordFiles.count-1
                                                                  inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

#pragma mark - 添加录音

/**
 *  创建录音实例
 */
-(void)createVoiceRecordMethod
{
    if (_istouched == YES) {
        return;
    }

    _istouched = YES;
    //配置Recorder，
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                     forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100]
                     forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1]
                     forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16]
                     forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh]
                     forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES) lastObject];
    
    NSString *voiceFileNameStr = [CommonMethod getSysDateStrWithFormat:CompleteNoFormat];
    NSString *voiceFileTimeStr = [CommonMethod getSysDateStrWithFormat:YearToMinFormat];
    
    _currentVoiceFileName = [NSString stringWithFormat:@"%@.caf",voiceFileNameStr];
    _currentVoiceFileTime = [NSString stringWithFormat:@"%@",voiceFileTimeStr];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                         strUrl,
                                         _currentVoiceFileName]];
    
    NSError *error ;
    
    //初始化
    if (_audioPlayer != nil) {
        _audioRecorder = nil;
    }
    _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url
                                                settings:recordSetting
                                                   error:&error];
    //开启音量检测
    _audioRecorder.meteringEnabled = YES;
    _audioRecorder.delegate = self;
    
}

/**
 *  手指按下开始录音
 */
- (IBAction)pressRecordMethod:(id)sender
{
    
    //如果正在播放录音，自动停止播放
    if (_audioPlayer.isPlaying) {
        
        [_audioPlayer stop];
    }
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (!granted)
        {
            //没有权限
            
            showMsg(SettingMicrophone);
        }
        else
        {
            //有权限
            
            _isRecording = YES;
            
            __weak typeof (self) weakSelf = self;
            
            //  后台执行：
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                //设置APP为活跃状态
                [weakSelf setAudioSessionActiveWithState:YES
                                          andIsPlayVoice:NO];
                
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf starRecordMethod];
                    
                });
                
            });
        }
    }];
    
    
    
}

/**
 *  设置APP活跃状态成功后开始录音
 */
-(void)starRecordMethod
{
    //创建voiceRecorder
    [self createVoiceRecordMethod];
    
    if ([_audioRecorder prepareToRecord] &&
        _isRecording) {
        
        [_audioRecorder recordForDuration:MaxRecordTime];
        
        _voiceRecordSignBgView.hidden = NO;
        
        _recordTimeLength = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY
                                                  target:self
                                                selector:@selector(updateMetersMethod)
                                                userInfo:nil
                                                 repeats:YES];
    }else{
        
        _voiceRecordSignBgView.hidden = YES;
    }
}

/**
 *  AVAudioSession是否active，设置app的active为yes，然后才能播放
 *
 *  @param isActive     是否活跃
 *  @param isPlayVoice  是否是播放声音，如果是播放声音，设置默认扬声器播放
 */
-(void)setAudioSessionActiveWithState:(BOOL)isActive andIsPlayVoice:(BOOL)isPlayVoice
{
    
    NSError *error;
    
    //得到AVAudioSession单例对象
    _audioSession = [AVAudioSession sharedInstance];
    
    //设置类别,表示该应用同时支持播放和录音
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                         error:&error];
    
    if (isPlayVoice) {
        
        //默认情况下扬声器播放
    [_audioSession setCategory:AVAudioSessionCategoryPlayback
                         error:&error];
    }
    
    //设置“移动A+”正在播放、录音
    [_audioSession setActive:isActive
                       error:&error];
    
}

/**
 *  结束录音
 */
-(void)commonEndRecordMethod
{
    
    _isRecording = NO;
    
    if (_audioRecorder.isRecording) {
        
        [_audioRecorder stop];
        
        [self setAudioSessionActiveWithState:NO
                              andIsPlayVoice:NO];
        
        _voiceRecordSignBgView.hidden = YES;
        
        [self resetTimer];
        
    }
}

/**
 *  松开手指结束录音按钮
 */
-(IBAction)endVoiceRecordMethod:(id)sender
{
    
    [self commonEndRecordMethod];
    
    //正常结束录音
    _isCancelRecord = NO;
    
}

/**
 *  手指移除按钮，取消录音
 */
- (IBAction)cancelVoiceRecordMethod:(id)sender
{
    
    _isRecording = NO;
    
    /**
     *  取消之前必须先stop，不然会删除失败
     */
    if (_audioRecorder.isRecording) {
        
        [_audioRecorder stop];
        [_audioRecorder deleteRecording];
        
        _voiceRecordSignBgView.hidden = YES;
        
        [self resetTimer];
        
        //取消录音
        _isCancelRecord = YES;
    }

//    _istouched = NO;
}

#pragma mark - Timer Update
- (void)updateMetersMethod {
    
    /*  发送updateMeters消息来刷新平均和峰值功率。
     *  此计数是以对数刻度计量的，-160表示完全安静，
     *  0表示最大输入值
     */
    
    if (_audioRecorder) {
        
        [_audioRecorder updateMeters];
    }
    
    _recordTimeLength += 1;
    
    float peakPower = [_audioRecorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    

    if (0 < peakPowerForChannel && peakPowerForChannel <= 0.1) {
        
        [_voiceRecordSignImgView setImage:[UIImage imageNamed:@"voiceRecord_icon_1"]];
        
    }else if (0.1 < peakPowerForChannel && peakPowerForChannel <= 0.3){
        
        [_voiceRecordSignImgView setImage:[UIImage imageNamed:@"voiceRecord_icon_2"]];
        
    }else if (0.3 < peakPowerForChannel && peakPowerForChannel <= 0.5){
        
        [_voiceRecordSignImgView setImage:[UIImage imageNamed:@"voiceRecord_icon_3"]];
        
    }else if (0.5 < peakPowerForChannel && peakPowerForChannel <= 0.7){
        
        [_voiceRecordSignImgView setImage:[UIImage imageNamed:@"voiceRecord_icon_4"]];
        
    }else{
        
        [_voiceRecordSignImgView setImage:[UIImage imageNamed:@"voiceRecord_icon_4"]];
    }
}

/**
 *  停止计时器
 */
-(void)resetTimer
{
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - *******delegate*********

- (void)clickPlayRecordImageView:(UIImageView *)imageV {
    
    
    // 刷新列表
    [_mainTableView reloadData];
    [_mainTableView layoutIfNeeded];
    _lastImageView.image = [UIImage imageNamed:@"voice_Play"];
    
    _lastImageView = imageV;
    _lastImageView.image = [UIImage imageNamed:@"voice_Normer"];
    
    
    
    NSDictionary *voiceFileDic = [_voiceRecordFiles objectAtIndex:imageV.tag];
    
    NSURL *docVoiceUrl = [self getFilePath:voiceFileDic[@"fileName"]];
    
    
    NSError *error;
    [_audioPlayer stop];
    
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:docVoiceUrl
                                                         error:&error ];
    _audioPlayer.delegate = self;
    _audioPlayer.volume = 0.5;          //播放音量
    _audioPlayer.numberOfLoops = 0;     //设置播放不循环
    
//    //设置APP活跃状态
//    [self setAudioSessionActiveWithState:YES
//                          andIsPlayVoice:YES];
//
//
//
//
//    //监听听筒or扬声器
//    [self handleNotification:YES];
    
    if ([_audioPlayer prepareToPlay]) {
        
        [_audioPlayer play];
    }
    
      
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag {
    
    //停止录音
    [self commonEndRecordMethod];
    
    
    
    /**
     *  如果不是取消录音，则保存录音文件名到数据库
     */
    if (!_isCancelRecord) {
        
        
        if (_recordTimeLength > 10) {
            
            AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[self getFilePath:_currentVoiceFileName] options:nil];
            
            CGFloat seconds =CMTimeGetSeconds(audioAsset.duration);
            
            //保存录音文件名，用来显示的时候用
            [_dataBaseOperation insertVoiceRecordFileName:_currentVoiceFileName
                                            andRecordTime:_currentVoiceFileTime
                                                andPropId:_propId
                                           andVoiceLength:[NSString stringWithFormat:@"%@",@(ceilf(seconds))]];
            
            //刷新数据、列表
            [self getVoiceRecordFiles];
        }
        
        _isCancelRecord = NO;
        _istouched = NO;
    }
    
    if (_recordVoiceBtn.state == UIControlStateHighlighted) {
        
        _recordVoiceBtn.highlighted = NO;
        
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_audioPlayer stop];
    
    //删除录音
    
    NSDictionary *voiceFileDic = [_voiceRecordFiles objectAtIndex:_deleteItemIndex];
    NSString *voiceFileName = [voiceFileDic objectForKey:@"fileName"];
    
    //删除数据库中的文件名
    [_dataBaseOperation deleteVoiceRecordWithFileName:voiceFileName];
    
    //删除document下的录音文件
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES) lastObject];
    voiceFileName = [NSString stringWithFormat:@"%@/%@",docStr,voiceFileName];
    [CommonMethod deleteImageFromDocWithName:voiceFileName];
    
    //刷新数据
    [self getVoiceRecordFiles];
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == YCDeleteVoice) {
        
       
        
    }
    
}


//#pragma mark - ActionSheetViewDelegate
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex
//         andButtonTitle:(NSString *)buttonTitle
//{
//
//    if (buttonIndex == 0) {
//
//        //删除录音
//
//        NSDictionary *voiceFileDic = [_voiceRecordFiles objectAtIndex:_deleteItemIndex];
//        NSString *voiceFileName = [voiceFileDic objectForKey:@"fileName"];
//
//        //删除数据库中的文件名
//        [_dataBaseOperation deleteVoiceRecordWithFileName:voiceFileName];
//
//        //删除document下的录音文件
//        NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                NSUserDomainMask,
//                                                                YES) lastObject];
//        voiceFileName = [NSString stringWithFormat:@"%@/%@",docStr,voiceFileName];
//        [CommonMethod deleteImageFromDocWithName:voiceFileName];
//
//        //刷新数据
//        [self getVoiceRecordFiles];
//    }
//}

//#pragma mark - UITableViewDelegate/UITableViewDataSource
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return _voiceRecordFiles.count;
//}




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

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES){
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:nil];
    }
    else
    {
        [_audioSession setCategory:AVAudioSessionCategoryPlayback
                             error:nil];
    }
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_animationImageView stopAnimating];
    
    [_audioPlayer stop];
    
    //设置app为不活跃状态
    [self setAudioSessionActiveWithState:NO
                          andIsPlayVoice:YES];
    
    //取消监听听筒or扬声器
    [self handleNotification:NO];
}

#pragma mark - dealloc
-(void)dealloc
{
    if (_audioRecorder.isRecording) {
        
        [_audioRecorder stop];
    }
    
    if (_audioPlayer.isPlaying) {
        
        [_audioPlayer stop];
    }
    
    _audioRecorder = nil;
    _audioPlayer = nil;
    _audioSession = nil;
    
}


- (NSURL*)getFilePath:(NSString*)fileUrl {
    
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES) lastObject];
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                 docStr,
                                                 fileUrl]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
