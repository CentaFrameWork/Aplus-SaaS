
//
//  JMVerifyButton.m
//  PanKeTong
//
//  Created by Admin on 2018/6/25.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMVerifyButton.h"
@interface JMVerifyButton ()

@property (nonatomic, strong, readwrite) NSTimer *timer;


@end
@implementation JMVerifyButton


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.enabled = YES;
    }
    
    return self;
}


- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    self.backgroundColor = YCButtonColorOrange;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (enabled) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        
    }else if ([self.titleLabel.text isEqualToString:@"获取验证码"]){
        
    
        [self setTitle:@"正在发送..." forState:UIControlStateNormal];
        
        
    }
}

- (void)startUpTimer{
    
    
    if (self.isEnabled) {
        self.enabled = NO;
    }
      self.backgroundColor = YCOtherColorBorder;
     [self setTitleColor:YCTextColorAuxiliary forState:UIControlStateNormal];
    [self setTitle:[NSString stringWithFormat:@"%.0fs后重新获取", _durationToValidity] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}


- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%.0fs后重新获取", _durationToValidity];
        [self setTitle:[NSString stringWithFormat:@"%.0fs后重新获取", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
        
        if (self.phonetimeOut) {
            
            self.phonetimeOut();
        }
    }
}

- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
}

@end
