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
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    ZYTabBarController *tab = [[ZYTabBarController alloc] init];
    self.window.rootViewController = tab;

    return YES;
}


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
