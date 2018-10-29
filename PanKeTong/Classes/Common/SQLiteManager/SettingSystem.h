//
//  SettingSystem.h
//  powerlife
//
//  Created by 陈行 on 16/11/11.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_SETTING_TABLE_NAME @"setting"

/**
 *  针对于Version_info库表设计的对象
 */
@interface SettingSystem : NSObject

/**
 *  数据库版本号记录
 */
@property (nonatomic, copy) NSString * database_version;
/**
 *  广告页版本号
 */
@property (nonatomic, copy) NSString * advertisingVersion;
/**
 *  引导页版本号
 */
@property (nonatomic, copy) NSString * launchVersion;

+ (instancetype)settingSystemForDatabase;

- (BOOL)saveSettingSystemToDatabase;

@end
