//
//  SearchPropertyManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SearchPropertyManager.h"

@implementation SearchPropertyManager

- (void)insertSearchResultType:(NSString *)searchResultType
                      andValue:(NSString *)resultValue
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;

    if (![self isExistTable:PropSearchResultList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (searchResultType TEXT,searchResultValue TEXT)",PropSearchResultList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    // 删除之前保存过的相同搜索内容
    sqlStr = [NSString stringWithFormat:@"delete from %@ where searchResultType = ? and searchResultValue = ?",PropSearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType,resultValue];

    // 搜索条件保存10条
    sqlStr = [NSString stringWithFormat:@"SELECT rowid FROM %@ where searchResultType = ?  order by rowid",PropSearchResultList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];
    NSMutableArray *_rowIdArray = [[NSMutableArray alloc] init];

    while ([resultSet next]){

        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];

    }

    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10)
    {
        sqlStr = [NSString stringWithFormat:@"delete from %@ where rowid = ? and searchResultType = ?",PropSearchResultList];
        [_dbManager.dataBase executeUpdate:sqlStr,[_rowIdArray objectAtIndex:0],searchResultType];
    }

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?)",PropSearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType,resultValue];

    [_dbManager.dataBase close];

}

- (NSMutableDictionary *)selectSearchResultType:(NSString *)searchResultType
{
    if (![_dbManager.dataBase open] || ![self isExistTable:PropSearchResultList])
    {
        return nil;
    }

    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc]init];

    // 返回全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where searchResultType = ?",PropSearchResultList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,searchResultType];

    // 通盘房源的搜索结果
    NSString *searchResultValue;
    NSMutableArray *mArr = [NSMutableArray array];
    while ([resultSet next])
    {
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultValue"]];
        [mArr addObject:searchResultValue];
    }

    [searchResultDic setValue:mArr forKey:searchResultType];

    [_dbManager.dataBase close];
    return searchResultDic;

}

- (void)deleteSearchResultWithType:(NSString *)searchResultType
{
    if (![_dbManager.dataBase open])
    {
        return;
    }
    // 删除某个类型的搜索
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ where searchResultType = ?",PropSearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType];

    [_dbManager.dataBase close];

}

/// 切换用户时，删除所有的房源搜索记录
- (void)deleteAllSearchResult
{
    if (![_dbManager.dataBase open])
    {
        return;
    }
    // 删除全部关于房源的搜索记录
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",PropSearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr];

    [_dbManager.dataBase close];
}



//=================================

//- (void)insertSearchResultWithTableName:(NSString *)tableName
//                               andValue:(NSString *)resultValue
//{
//    if (![_dbManager.dataBase open])
//    {
//        return;
//    }
//
//    NSString *sqlStr;
//    if (![self isExistTable:tableName])
//    {
//        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (searchResultValue TEXT)",tableName];
//        [_dbManager.dataBase executeUpdate:sqlStr];
//    }
//
//    // 删除之前保存过的搜索内容
//    [_dbManager.dataBase executeUpdate:@"delete from %@ where searchResultValue = ?",tableName,resultValue];
////    if ([tableName isEqualToString:PropSearchResultList])
////    {
////        [_dbManager.dataBase executeUpdate:@"delete from %@ where searchResultValue = ?",PropSearchResultList,resultValue];
////    }
////    if ([tableName isEqualToString:TrustSearchResultList])
////    {
////        [_dbManager.dataBase executeUpdate:@"delete from %@ where searchResultType = ? and searchResultValue = ?",TrustSearchResultList,tableName,resultValue];
////    }
////    if ([tableName isEqualToString:CalendarSearchResultList])
////    {
////        [_dbManager.dataBase executeUpdate:@"delete from %@ where searchResultType = ? and searchResultValue = ?",CalendarSearchResultList,tableName,resultValue];
////    }
//
//    // 搜索条件保存10条
//    FMResultSet *resultSet;
//    resultSet=[_dbManager.dataBase executeQuery:@"SELECT rowid FROM %@ order by rowid",tableName];
//
//    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];
//    while ([resultSet next])
//    {
//        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
//                                [resultSet stringForColumn:@"rowid"]]];
//    }
//
//    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10)
//    {
//        [_dbManager.dataBase executeUpdate:@"delete from %@ where rowid = ?",tableName,[_rowIdArray objectAtIndex:0]];
//    }
//
//    [_dbManager.dataBase executeUpdate:@"INSERT INTO %@ VALUES (?)",tableName,resultValue];
//
//    [_dbManager.dataBase close];
//}
//
//- (NSMutableDictionary *)selectSearchResultWithTableName:(NSString *)tableName
//{
//    if (![_dbManager.dataBase open] || ![self isExistTable:tableName])
//    {
//        return nil;
//    }
//
//    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc]init];
//
//    NSMutableArray *propEstateSearchResultArray = [[NSMutableArray alloc]init];
////    NSMutableArray *trustAudittingResultArray = [NSMutableArray array];
////    NSMutableArray *calendarResultArray = [NSMutableArray array];
//
//    //返回全部查询结果
//    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
//    FMResultSet *resultSet=[_dbManager.dataBase executeQuery:sqlStr];
//
//    NSString *searchResultValue;
//    while ([resultSet next])
//    {
//        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultValue"]];
////        if ([tableName isEqualToString:PropListSearchType])
////        {
////            [propEstateSearchResultArray addObject:searchResultValue];
////            [searchResultDic setValue:propEstateSearchResultArray forKey:PropListSearchType];
////        }
////        if ([tableName isEqualToString:TrustAuditingSearchType])
////        {
////            [trustAudittingResultArray addObject:searchResultValue];
////            [searchResultDic setValue:trustAudittingResultArray forKey:TrustAuditingSearchType];
////        }
////        if ([tableName isEqualToString:PropCalendarSearchList])
////        {
////            [calendarResultArray addObject:searchResultValue];
////            [searchResultDic setValue:calendarResultArray forKey:PropCalendarSearchList];
////        }
//        [propEstateSearchResultArray addObject:searchResultValue];
//        [searchResultDic setValue:propEstateSearchResultArray forKey:tableName];
//    }
//
//    [_dbManager.dataBase close];
//    return searchResultDic;
//}
//
///// 删除某个表的搜索记录
//- (void)deleteSearchResultWithTableName:(NSString *)tableName
//{
//    if (![_dbManager.dataBase open] || ![self isExistTable:tableName])
//    {
//        return ;
//    }
//    [_dbManager.dataBase executeUpdate:@"DELETE FROM %@",tableName];
//
//    [_dbManager.dataBase close];
//}
//
///// 切换用户时，删除所有的房源搜索记录
//- (void)deleteAllSearchResult
//{
//    if (![_dbManager.dataBase open])
//    {
//        return;
//    }
//    // 删除全部关于房源的搜索记录
//    [_dbManager.dataBase executeUpdate:@"DELETE FROM %@",PropSearchResultList];
//    [_dbManager.dataBase executeUpdate:@"DELETE FROM %@",TrustSearchResultList];
//    [_dbManager.dataBase executeUpdate:@"DELETE FROM %@",CalendarSearchResultList];
//
//    [_dbManager.dataBase close];
//}

@end
