//
//  AudioPlayView.h
//  进度条拖拽
//
//  Created by 中原管家 on 2017/5/17.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"

@interface AudioPlayView : UIView

@property (nonatomic, copy) NSString *audioUrl;

@property (strong, nonatomic) UIButton *palyButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *startLabel;
@property (strong, nonatomic) UILabel *endTimeLabel;

@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (assign, nonatomic) BOOL isPause;
@property (strong, nonatomic) NSTimer *timer;


- (void)audioPlayOrPause;
@end
