//
//  AudioPlayView.m
//  进度条拖拽
//
//  Created by 中原管家 on 2017/5/17.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import "AudioPlayView.h"
#import "CheckTrustVC.h"

@implementation AudioPlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView
{
    _isPause = NO;
    
    if (!_audioPlayer)
    {
        _audioPlayer = [[STKAudioPlayer alloc]init];
    }
    
    if (!_slider)
    {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, APP_SCREEN_WIDTH - 110 - 50 - 10, 20)];
        _slider.minimumValue = 0.00;
        _slider.maximumValue = 1.00;
        _slider.minimumTrackTintColor = [UIColor redColor]; //滑轮左边颜色如果设置了左边的图片就不会显示
//        _slider.maximumTrackTintColor = [UIColor lightGrayColor]; //滑轮右边颜色如果设置了右边的图片就不会显示
//        _slider.thumbTintColor = [UIColor redColor]; //设置了滑轮的颜色设置了滑轮的图片就不会显示
        UIImage *thumbImage = [UIImage imageNamed:@"Oval 4"];
        [ _slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [ _slider setThumbImage:thumbImage forState:UIControlStateNormal];
        
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [self addSubview:_slider];
    }
    
    if (!_palyButton)
    {
        _palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_palyButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_palyButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
        [_palyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _palyButton.frame = CGRectMake(_slider.right + 3, _slider.y, 50,_slider.height);
     
        [_palyButton addTarget:self action:@selector(audioPlayOrPause) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_palyButton];
    }

    if (!_startLabel) {
        _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(_slider.x  + 5, _slider.bottom + 5, 50, 10)];
        _startLabel.text = @"0'00";
        _startLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_startLabel];
    }
    
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_slider.right - 20, _startLabel.y , 50, 10)];
        _endTimeLabel.text = @"0'00";
        _endTimeLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_endTimeLabel];
    }
}


- (void)sliderValueChanged
{
    NSInteger proMin = (NSInteger)_slider.value / 60;//当前秒
    NSInteger proSec = (NSInteger)_slider.value % 60;//当前分钟
    _startLabel.text = [NSString stringWithFormat:@"%ld'%02ld",proMin,proSec];
    
    if (_audioPlayer) {
        [_audioPlayer seekToTime:_slider.value];
    }
    
}


/// 播放or暂停
- (void)audioPlayOrPause
{
    CheckTrustVC *vc = (CheckTrustVC *)self.viewController;
    if (_palyButton.selected)
    {
        _palyButton.selected = NO;
        vc.isPlaying = NO;
        [_audioPlayer pause];
        _isPause = YES;
        [_timer invalidate];
        _timer = nil;
    }
    else
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(audioProgress) userInfo:nil repeats:YES];
        _palyButton.selected = YES;
        vc.isPlaying = YES;

        if (_isPause) {
            [_audioPlayer resume];
        }else{
            if (![_audioUrl contains:@"wav"]) {
                _palyButton.selected = NO;
                vc.isPlaying = NO;
                showMsg(@"录音格式错误！");
                return;
            }
            [_audioPlayer playURL:[NSURL URLWithString:_audioUrl]];
        }
    }


    
}

// timerSelector
- (void)audioProgress
{
    self.slider.value = _audioPlayer.progress;
    self.slider.maximumValue = _audioPlayer.duration;
    
       // 当前时长进度progress
    NSInteger proMin = (NSInteger)_audioPlayer.progress / 60;//当前秒
    NSInteger proSec = (NSInteger)_audioPlayer.progress % 60;//当前分钟
    _startLabel.text = [NSString stringWithFormat:@"%ld'%02ld",proMin,proSec];
    
    // duration 总时长
    NSInteger durMin = (NSInteger)_audioPlayer.duration / 60;//总秒
    NSInteger durSec = (NSInteger)_audioPlayer.duration % 60;//总分钟
    _endTimeLabel.text = [NSString stringWithFormat:@"%ld'%02ld",durMin,durSec];
    
    if (_audioPlayer.progress == _audioPlayer.duration) {
        _isPause = YES;
        [_timer invalidate];
        _timer = nil;
        _startLabel.text = @"0'00";
        _palyButton.selected = NO;
        _isPause = NO;
        CheckTrustVC *vc = (CheckTrustVC *)self.viewController;
        vc.isPlaying = _isPause;
    }
}


@end
