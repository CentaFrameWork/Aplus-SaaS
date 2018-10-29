//
//  SysParamManager.m
//  APlus
//
//  Created by 李慧娟 on 17/7/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SysParamManager.h"

@implementation SysParamManager

/// 插入系统参数
- (void)insertSystemParamWithJson:(NSString *)sysParamJson
{
    if (![_dbManager.dataBase open])
    {
        return;
    }
    NSString *sqlStr;

    if (![self isExistTable:SystemParam])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (systemParam TEXT)",SystemParam];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }
    
    //如果存在，删除
    sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",SystemParam];
    [_dbManager.dataBase executeUpdate:sqlStr];

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?)",SystemParam];
    [_dbManager.dataBase executeUpdate:sqlStr,sysParamJson];

    [_dbManager.dataBase close];
}

- (void)deleteSystemParam
{
    if (![_dbManager.dataBase open] && [self isExistTable:SystemParam])
    {
        return;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",SystemParam];
    [_dbManager.dataBase executeUpdate:sqlStr];
    [_dbManager.dataBase close];
}

- (SystemParamEntity *)selectSystemParam
{
    if (![_dbManager.dataBase open] || ![self isExistTable:SystemParam])
    {
        return nil;
    }

    NSString *sqlStr;

    sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",SystemParam];
    FMResultSet *sysParamResultSet = [_dbManager.dataBase executeQuery:sqlStr];
    NSString *sysParamStr = [[NSString alloc]init];

    while ([sysParamResultSet next])
    {
        sysParamStr = [NSString stringWithFormat:@"%@",[sysParamResultSet stringForColumn:@"systemParam"]];
    }

    [_dbManager.dataBase close];

    SystemParamEntity *sysPram = [DataConvert convertDic:[sysParamStr jsonDictionaryFromJsonString]
                                                toEntity:[SystemParamEntity class]];
    return sysPram;
}

@end
