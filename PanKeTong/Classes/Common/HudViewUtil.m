//
//  HudViewUtil.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "HudViewUtil.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@implementation HudViewUtil
{
    MBProgressHUD *_mbHUD;
}


- (void)initHUDView
{
    [_mbHUD removeFromSuperview];
    _mbHUD = nil;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    _mbHUD = [[MBProgressHUD alloc] initWithView:mainWindow];
    _mbHUD.mode = MBProgressHUDModeCustomView;

    // 圈
    UIImageView *hudBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -6, 45, 45)];
    [hudBgImageView setImage:[UIImage imageNamed:@"spinner_outer"]];

    CABasicAnimation *animation = [CABasicAnimation  animationWithKeyPath:@"transform.rotation"];
    animation.duration = MAXFLOAT * 0.4;
    animation.additive = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
    animation.repeatCount = MAXFLOAT;
    [hudBgImageView.layer addAnimation:animation forKey:nil];

    // 中原
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -3, 35, 35)];
    [iconView setImage:[UIImage imageNamed:@"zy_icon"]];
    [iconView addSubview:hudBgImageView];
    _mbHUD.removeFromSuperViewOnHide = YES;
    _mbHUD.customView = iconView;
    [mainWindow addSubview:_mbHUD];
    
    
    
}

- (void)showLoadingView:(NSString *)message
{
    [self initHUDView];

    _mbHUD.labelText = message ? message : @"";
    [_mbHUD show:YES];
}

- (void)hiddenLoadingView
{
    if (_mbHUD)
    {
        [_mbHUD hide:YES];
    }
}


@end




