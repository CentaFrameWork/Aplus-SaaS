//
//  JMVerifyButton.h
//  PanKeTong
//
//  Created by Admin on 2018/6/25.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMVerifyButton : UIButton
@property (nonatomic,copy) void(^phonetimeOut)(void);
@property (assign, nonatomic) NSTimeInterval durationToValidity;

- (void)startUpTimer;
- (void)invalidateTimer;

@end
