//
//  LogOffUtil.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/16.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 用户退出Util
@interface LogOffUtil : NSObject

/**
 *  用户退出登录后清除用户信息
 */
+ (void)clearUserInfoFromLocal;


/**
 *  退出融云聊天系统
 */
+ (void)logoutRongCloudMethod;

@end
