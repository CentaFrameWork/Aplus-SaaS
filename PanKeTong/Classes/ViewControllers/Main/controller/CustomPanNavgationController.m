//
//  CustomPanNavgationController.m
//  SaleHouse
//
//  Created by 苏军朋 on 14-12-17.
//  Copyright (c) 2014年 苏军朋. All rights reserved.
//

#import "CustomPanNavgationController.h"
//#import "AppConfiguration.h"

@interface CustomPanNavgationController ()

@end

@implementation CustomPanNavgationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    CustomPanNavgationController *cusNVC = [super initWithRootViewController:rootViewController];
    if (MODEL_VERSION >= 7.0)
    {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    cusNVC.delegate = self;
    
    return cusNVC;
}

/// 解决rootViewController滑动返回手势也会触发的问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1)
    {
        self.currentShowVC = Nil;
    }
    else
    {
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当前controller是否是根controller
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
    {
        return (self.currentShowVC == self.topViewController);
    }
    
    return YES;
}

@end
