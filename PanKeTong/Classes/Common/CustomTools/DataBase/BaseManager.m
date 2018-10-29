//
//  BaseOperation.m
//  APlus
//
//  Created by 李慧娟 on 17/7/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

static DataBaseManager *dbmanager = nil;

@implementation DataBaseManager

/**
 * 单例创建数据库管理对象
 */
+ (DataBaseManager *)shareDataBaseManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbmanager = [[DataBaseManager alloc] init];
    });
    return dbmanager;
}

/**
 * 加载数据库
 */
- (void)createDataBaseMethod
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"APlus.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:dbpath];
    if (![_dataBase open])
    {
        return;
    }

    [_dataBase close];
}
@end

@implementation BaseManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dbManager = [DataBaseManager shareDataBaseManager];
    }
    
    return self;
}

/**
 * 检查表是否已存在
 */
- (BOOL)isExistTable:(NSString *)tableName
{
    FMResultSet *rs = [_dbManager.dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];

    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        if (count == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

@end
