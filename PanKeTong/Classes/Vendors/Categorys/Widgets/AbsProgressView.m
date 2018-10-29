//
//  AbsProgressView.m
//  CustomProgress
//
//  Created by 燕文强 on 17/3/14.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "AbsProgressView.h"

@implementation AbsProgressView

// 强制在主线程中修改进度
-(void)changeProgressRunOnMainThread:(int)progress
{
    // 通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeProgress:progress];
    });
}
// 修改进度
-(void)changeProgress:(int)progress
{
}

@end
