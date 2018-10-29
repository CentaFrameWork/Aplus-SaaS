//
//  RCIMUserDataSource.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import "GetStaffMsgApi.h"
#import "RequestManager.h"



/**
 *  此类实现了provider，用来提供聊天用户的姓名和头像信息，同时也是为了有本地通知
 *
 */
@interface RCIMUserDataSource : NSObject<RCIMUserInfoDataSource,ResponseDelegate>

+ (RCIMUserDataSource *)shareUserDataSource;




@end
