//
//  NewUtils.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/30.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NewUtils.h"
#import "AppDelegate.h"

@implementation NewUtils

// 弹窗选择器
+ (SelectorView *)popoverSelectorTitle:(NSString *)title listArray:(NSArray *)array theOption:(void (^)(NSInteger))theOption {
    SelectorView *view = [[SelectorView alloc] init];
    if (title == nil || title.length == 0) {
        view.titStr = @"请选择";
    }else {
        view.titStr = title;
    }
    view.dataArray = array;
    view.theOption = ^(NSInteger optionValue) {
        theOption(optionValue);
    };
    return view;
}


@end

// 添加菊花
static MBProgressHUD *_mbHUD;
void showLoading(NSString *message) {
    
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
    
    _mbHUD.labelText = message ? message : @"";
    [_mbHUD show:YES];
}
// 删除菊花
void hiddenLoading(void) {
    if (_mbHUD)
    {
        [_mbHUD hide:YES];
    }
}

//判断是否为整形：
BOOL isPureInt(NSString *string) {
    
    if (string.length == 0) {
        return YES;
    }
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
BOOL isPureFloat(NSString *string) {
    
    if (string.length == 0) {
        return YES;
    }
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否是纯数字
BOOL isItANumber(NSString *string) {
    if (isPureInt(string) || isPureFloat(string)) {
        return YES;
    }
    return NO;
}

// 小数
BOOL isItDecimal(NSString *string, NSString *text, int length) {
    if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"]|| [string isEqualToString:@"2"]|| [string isEqualToString:@"3"]|| [string isEqualToString:@"4"]|| [string isEqualToString:@"5"]|| [string isEqualToString:@"6"]|| [string isEqualToString:@"7"]|| [string isEqualToString:@"8"]|| [string isEqualToString:@"9"]|| [string isEqualToString:@"."]|| string.length == 0) {
        if (text.length >= length-1 && [string isEqualToString:@"."]) {
            return NO;
        }
        if (text.length == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        if ([string isEqualToString:@"."] && !([text rangeOfString:string].location == NSNotFound)) {
            return NO;
        }
        if (text.length >= length) {
            if (string.length == 0) {
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

// 整数
BOOL isItInteger(NSString *string, NSString *text, int length) {
    if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"]|| [string isEqualToString:@"2"]|| [string isEqualToString:@"3"]|| [string isEqualToString:@"4"]|| [string isEqualToString:@"5"]|| [string isEqualToString:@"6"]|| [string isEqualToString:@"7"]|| [string isEqualToString:@"8"]|| [string isEqualToString:@"9"]|| string.length == 0) {
        if (text.length >= length) {
            if (string.length == 0) {
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

