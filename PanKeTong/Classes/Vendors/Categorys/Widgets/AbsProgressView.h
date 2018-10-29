//
//  AbsProgressView.h
//  CustomProgress
//
//  Created by 燕文强 on 17/3/14.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressDelegate<NSObject>
@optional
- (void)finished;
@end

@interface AbsProgressView : UIView

// 背景色
@property (nonatomic,copy) UIColor *bgColor;
// 完整的进度
@property (readonly,assign,nonatomic) float fullProgress;
// 当前进度
@property (nonatomic,assign) int progress;
// 在画布中padding
@property (nonatomic,assign) float padding;
@property (nonatomic,assign) id<ProgressDelegate> delegate;

// 强制在主线程中修改进度
-(void)changeProgressRunOnMainThread:(int)progress;
// 修改进度
-(void)changeProgress:(int)progress;

@end
