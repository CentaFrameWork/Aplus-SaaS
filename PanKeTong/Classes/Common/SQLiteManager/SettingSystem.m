//
//  SettingSystem.m
//  powerlife
//
//  Created by 陈行 on 16/11/11.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "SettingSystem.h"
#import "SQLiteManager.h"

@implementation SettingSystem

+ (instancetype)settingSystemForDatabase{
    
    SettingSystem * setting = [SQLiteManager queryOneWithTableName:DATABASE_SETTING_TABLE_NAME andClass:[self class]];
    
    return setting;
}

- (BOOL)saveSettingSystemToDatabase{
    
    BOOL res = [SQLiteManager deleteWithTableName:DATABASE_SETTING_TABLE_NAME andClass:nil andParams:nil];
    
    NSLog(@"-------->数据库版本数据删除%@", res ? @"成功" : @"失败");
    
    return [SQLiteManager insertToTableName:DATABASE_SETTING_TABLE_NAME andObject:self];
}

@end
