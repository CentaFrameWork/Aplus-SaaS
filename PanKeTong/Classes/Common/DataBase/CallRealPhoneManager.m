//
//  CallRealPhoneManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "CallRealPhoneManager.h"

@implementation CallRealPhoneManager

- (void)insertCallRealPhoneWithStaffNo:(NSString *)staffNo
                          andPropKeyId:(NSString *)propKeyId
                               andDate:(NSString *)date
{
    if (![_dbManager.dataBase open])
    {
        return;
    }
    NSString *sqlStr;
    if (![self isExistTable:CallRealPhone])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (staffNo TEXT,propKeyId TEXT,date TEXT)",CallRealPhone];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?)",CallRealPhone];
    [_dbManager.dataBase executeUpdate:sqlStr,staffNo,propKeyId,date];

    [_dbManager.dataBase close];

}

- (NSInteger)selectCountForStaffNo:(NSString *)staffNo
                           andDate:(NSString *)date
{
    if (![_dbManager.dataBase open] || ![self isExistTable:CallRealPhone])
    {
        return 0;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE staffNo = ? and date = ?",CallRealPhone];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,staffNo,date];

    NSInteger count = 0;

    while ([resultSet next])
    {
        count ++;
    }

    [_dbManager.dataBase close];

    return count;

}

- (void)deleteRealPhoneForStaffNo:(NSString *)staffNo
                          andDate:(NSString *)date
{
    if (![_dbManager.dataBase open] || ![self isExistTable:CallRealPhone])
    {
        return;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE staffNo = ? and date != ?",CallRealPhone];
    [_dbManager.dataBase executeUpdate:sqlStr,staffNo,date];

    [_dbManager.dataBase close];
}

- (BOOL)isExistWithStaffNo:(NSString *)staffNo
              andPropKeyId:(NSString *)propKeyId
                   andDate:(NSString *)date
{
    if (![_dbManager.dataBase open] || ![self isExistTable:CallRealPhone])
    {
        return NO;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE staffNo = ? and propKeyId = ? and date = ?",CallRealPhone];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,staffNo,propKeyId,date];

    NSInteger count = 0;
    while ([resultSet next])
    {
        count ++;
    }

    [_dbManager.dataBase close];

    return (count > 0) ? YES : NO;
}

@end
