//
//  AppDelegate+APPConfig.h
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/31.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AppDelegate.h"
#import <iflyMSC/iflyMSC.h>

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import <Bugly/Bugly.h>
#import "Growing.h"
#import "JPUSHService.h"

/// APP配置相关
@interface AppDelegate (APPConfig)<BMKLocationAuthDelegate,BMKGeneralDelegate>

// 用户首次安装配置
- (void)firstInstallSetting;

/// 第三方配置
- (void)thirdPartySetting:(NSDictionary *)launchOptions;

/// 监听网络状态
- (void)observeNetworkState;

/// 处理收到的推送
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

/// 处理即将进入程序
- (void)appWillEnterForeground:(UIApplication *)application;

@end
