//
//  PropertyNumManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PropertyNumManager.h"

@implementation PropertyNumManager

- (void)insertKeyIdOfCheckedRoomNum:(NSString *)propKeyId
                         andStaffNo:(NSString *)staffNo
                            andDate:(NSString *)date
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;
    if (![self isExistTable:CheckedRoomNumPropList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (staffNo TEXT,propKeyId TEXT,date TEXT)",CheckedRoomNumPropList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?)",CheckedRoomNumPropList];
    [_dbManager.dataBase executeUpdate:sqlStr,staffNo,propKeyId,date];

    [_dbManager.dataBase close];

}

- (NSMutableArray *)selectAllKeyIdOfCheckedRoomNumWithStaffNo:(NSString *)staffNo
                                                      andDate:(NSString *)date
{
    if (![_dbManager.dataBase open] || ![self isExistTable:CheckedRoomNumPropList])
    {
        return nil;
    }

    NSMutableArray *checkedRoomNumKeyIds = [[NSMutableArray alloc] init];

    //返回当前用户的全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ where staffNo = ? and date = ?",CheckedRoomNumPropList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,staffNo,date];

    // 全部的查看过房号的keyId
    NSString *searchResultValue;

    while ([resultSet next])
    {
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"propKeyId"]];

        [checkedRoomNumKeyIds addObject:searchResultValue];
    }

    [_dbManager.dataBase close];

    return checkedRoomNumKeyIds;

}


@end
