//
//  AgencyInfoManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "AgencyInfoManager.h"

@implementation AgencyInfoManager

/// A+员工信息
- (void)insertAgencyUserInfoWithJson:(NSString *)agencyUserInfo
{
    if (![_dbManager.dataBase open])
    {
        return;
    }
    NSString *sqlStr;
    if (![self isExistTable:AgencyUserInfo])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (agencyUserInfo TEXT)",AgencyUserInfo];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }
    //如果存在，删除
    sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",AgencyUserInfo];
    [_dbManager.dataBase executeUpdate:sqlStr];

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?)",AgencyUserInfo];
    [_dbManager.dataBase executeUpdate:sqlStr,agencyUserInfo];

    [_dbManager.dataBase close];
}

- (void)deleteAgencyUserInfo
{
    if (![_dbManager.dataBase open] && [self isExistTable:AgencyUserInfo])
    {

        return;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",AgencyUserInfo];
    [_dbManager.dataBase executeUpdate:sqlStr];
    [_dbManager.dataBase close];
}

- (DepartmentInfoResultEntity *)selectAgencyUserInfo
{
    if (![_dbManager.dataBase open] || ![self isExistTable:AgencyUserInfo])
    {
        return nil;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",AgencyUserInfo];
    FMResultSet *userInfoResultSet = [_dbManager.dataBase executeQuery:sqlStr];
    NSString *userInfoStr = [[NSString alloc]init];

    while ([userInfoResultSet next])
    {
        userInfoStr = [NSString stringWithFormat:@"%@",[userInfoResultSet stringForColumn:@"agencyUserInfo"]];
    }

    [_dbManager.dataBase close];

    DepartmentInfoResultEntity *sysPram = [DataConvert convertDic:[userInfoStr jsonDictionaryFromJsonString]
                                                         toEntity:[DepartmentInfoResultEntity class]];
    return sysPram;
}


@end
