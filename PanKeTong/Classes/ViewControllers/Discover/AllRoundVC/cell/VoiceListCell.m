//
//  VoiceListCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "VoiceListCell.h"

@interface VoiceListCell ()

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)int totalTime;
@property (nonatomic,assign)int currentTime;
@property (nonatomic,strong)UIView *currentView;

@end

@implementation VoiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //单击播放录音
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(clickPlayRecord:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    
    //长按删除录音
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                              action:@selector(longPress:)];
    
    
    [self.voiceRecordPlayItem addGestureRecognizer:tapGes];
    [self.voiceRecordPlayItem addGestureRecognizer:longPressGes];
    
    
    _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
    _currentView.backgroundColor = YCThemeColorGreen;
    
    [self.voiceLegth addSubview:_currentView];
    
}

- (void)setDict:(NSDictionary *)dict {
    
    
    _totalTime = [dict[@"voiceLength"] intValue];
    self.recordTimeLabel.text = [@"记录时间: " stringByAppendingString:dict[@"recordTime"]];
    self.vocie_Time.text = [NSString stringWithFormat:@"00:00/%02d:%02d",_totalTime/60,_totalTime%60];
    
    
    
    _currentTime = 0;
    [_timer invalidate];
    _timer = nil;
    self.currentView.width = 0;
}

- (void)clickPlayRecord:(UITapGestureRecognizer*)tap {
      
    
    if ([self.delegate respondsToSelector:@selector(clickPlayRecordImageView:)]) {
        
        [self.delegate clickPlayRecordImageView:(UIImageView*)tap.view];
    }
    
    
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCurrentTime) userInfo:nil repeats:YES];;
    [_timer fire];
    
}

- (void)getCurrentTime{
    
    if (_currentTime < _totalTime) {
        
        _currentTime++;
        self.vocie_Time.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",_currentTime/60,_currentTime%60,_totalTime/60,_totalTime%60];
        
        
        self.currentView.width = self.voiceLegth.width * (_currentTime * 1.0/_totalTime);
        
    }else{
        
        _currentTime = 0;
        [_timer invalidate];
        _timer = nil;
        self.currentView.width = 0;
        self.vocie_Time.text = [NSString stringWithFormat:@"00:00/%02d:%02d",_totalTime/60,_totalTime%60];
        
        self.voiceRecordPlayItem.image = [UIImage imageNamed:@"voice_Play"];
    }
   
    

}




@end
