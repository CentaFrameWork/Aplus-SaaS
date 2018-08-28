//
//  AppDelegate.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/20.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setScrollViewInsetQus];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    
    ZYTabBarController *tab = [[ZYTabBarController alloc] init];
    
    self.window.rootViewController = tab;

    return YES;
}

#pragma mark - private
- (void)setScrollViewInsetQus{
    
    if (@available(iOS 11, *)) {
        
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}


#pragma mark - 系统协议
- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {



}


- (void)applicationWillTerminate:(UIApplication *)application {


}



@end
