//
//  SearchRemindManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SearchRemindManager.h"

@implementation SearchRemindManager

/// 增加数据
- (void)insertSearchRemindResult:(NSString *)searchRemindType
                        andValue:(NSString *)resultValue
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;

    if (![self isExistTable:SearchRemindList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (searchRemindType TEXT,searchRemindValue TEXT)",SearchRemindList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    // 删除之前保存过的搜索内容
    sqlStr = [NSString stringWithFormat:@"delete from %@ where searchRemindType = ? and searchRemindValue = ?",SearchRemindList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchRemindType,resultValue];

    // 搜索条件保存10条
    sqlStr = [NSString stringWithFormat:@"SELECT rowid FROM %@ order by rowid",SearchRemindList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];

    NSMutableArray *_rowIdArray = [[NSMutableArray alloc] init];
    while ([resultSet next])
    {
        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
    }

    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10)
    {
        sqlStr = [NSString stringWithFormat:@"delete from %@ where rowid = ?",SearchRemindList];
        [_dbManager.dataBase executeUpdate:sqlStr,[_rowIdArray objectAtIndex:0]];
    }
    _rowIdArray = nil;

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?)",SearchRemindList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchRemindType,resultValue];

    [_dbManager.dataBase close];
}

/// 删除
- (void)deleteSearchRemindResultWithType:(NSString *)searchRemindType
{
    if (![_dbManager.dataBase open] || ![self isExistTable:SearchRemindList])
    {
        return ;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE searchRemindType = ?",SearchRemindList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchRemindType];

    [_dbManager.dataBase close];
}

/// 查询
- (NSMutableDictionary *)selectSearchRemindResult:(BOOL)isKeywords
{
    if (![_dbManager.dataBase open] || ![self isExistTable:SearchRemindList])
    {
        return nil;
    }

    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc] init];

    NSMutableArray *searchmArr = [NSMutableArray array];

    //返回全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",SearchRemindList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];

    /*
     * 通盘房源的搜索结果
     */
    NSString *searchRemindResultType;
    NSString *searchRemindResultValue;

    while ([resultSet next])
    {
        searchRemindResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindType"]];
        searchRemindResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindValue"]];

        [searchmArr addObject:searchRemindResultValue];
    }

    [searchResultDic setValue:searchmArr forKey:searchRemindResultType];



//    // 关键字搜索
//    NSMutableArray *remindKeywordsResultArrary = [NSMutableArray array];
//
//    // 实勘审核人
//    NSMutableArray *realSurveyAuditorArray = [NSMutableArray array];
//
//    // 提醒人模块
//    NSMutableArray *remindPersonSearchResultArray = [NSMutableArray array];
//    NSMutableArray *remindDeparmentSearchResultArray = [NSMutableArray array];
//
//    // 实勘审核模块
//    NSMutableArray *realPersonSearchResultArray = [NSMutableArray array];
//    NSMutableArray *realDeparmentSearchResultArray = [NSMutableArray array];
//
//    // 日历行程模块
//    NSMutableArray *calendarPersonSearchResultArray = [NSMutableArray array];
//    NSMutableArray *calendarDeparmentSearchResultArray = [NSMutableArray array];
//
//    //通话记录模块(重庆)
//    NSMutableArray *callRecordPersonFilterArray = [NSMutableArray array];
//    NSMutableArray *callRecordDeptFilterArray = [NSMutableArray array];
//
//    // 实勘审核模块
//    NSMutableArray *trustAuditingPersonSearchResultArray = [NSMutableArray array];
//    NSMutableArray *trustAuditingDeparmentSearchResultArray = [NSMutableArray array];
//
//
//    //返回全部查询结果
//    FMResultSet *resultSet=[_dbManager.dataBase executeQuery:@"SELECT * FROM %@",SearchRemindList];
//
//    /*
//     * 通盘房源的搜索结果
//     */
//    NSString *searchRemindResultType;
//    NSString *searchRemindResultValue;
//
//    while ([resultSet next])
//    {
//        searchRemindResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindType"]];
//        searchRemindResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindValue"]];
//        if (isKeywords)
//        {
//            // 选择的关键字
//            if ([searchRemindResultType isEqualToString:KeyWordsRemindType])
//            {
//                [remindKeywordsResultArrary addObject:searchRemindResultValue];
//            }
//        }
//        else
//        {
//            if ([searchRemindResultType isEqualToString:PersonRemindType])
//            {
//                [remindPersonSearchResultArray addObject:searchRemindResultValue];
//
//            }
//            else if ([searchRemindResultType isEqualToString:DeparmentRemindType])
//            {
//
//                [remindDeparmentSearchResultArray addObject:searchRemindResultValue];
//            }
//
//            if ([searchRemindResultType isEqualToString:RealSurveyPersonType])
//            {
//                [realPersonSearchResultArray addObject:searchRemindResultValue];
//            }
//            else if ([searchRemindResultType isEqualToString:RealSurveyDeparmentType])
//            {
//                [realDeparmentSearchResultArray addObject:searchRemindResultValue];
//            }
//
//            if([searchRemindResultType isEqualToString:RealSurveyAuditor])
//            {
//                [realSurveyAuditorArray addObject:searchRemindResultValue];
//            }
//
//            if ([searchRemindResultType isEqualToString:CalendarDeparmentType])
//            {
//                [calendarDeparmentSearchResultArray addObject:searchRemindResultValue];
//            }
//            else if ([searchRemindResultType isEqualToString:CalendarPersonType])
//            {
//                [calendarPersonSearchResultArray addObject:searchRemindResultValue];
//            }
//
//            if ([searchRemindResultType isEqualToString:CallRecordPersonType])
//            {
//                [callRecordPersonFilterArray addObject:searchRemindResultValue];
//            }
//            else if ([searchRemindResultType isEqualToString:CallRecordDeparmentType])
//            {
//                [callRecordDeptFilterArray addObject:searchRemindResultValue];
//            }
//
//            if ([searchRemindResultType isEqualToString:TrustAuditingPersonType])
//            {
//                [trustAuditingPersonSearchResultArray addObject:searchRemindResultValue];
//            }
//            else if ([searchRemindResultType isEqualToString:TrustAuditingDeparmentType])
//            {
//                [trustAuditingDeparmentSearchResultArray addObject:searchRemindResultValue];
//            }
//        }
//    }
//
//    [searchResultDic setValue:remindPersonSearchResultArray
//                       forKey:PersonRemindType];
//    [searchResultDic setValue:remindDeparmentSearchResultArray
//                       forKey:DeparmentRemindType];
//
//    [searchResultDic setValue:realPersonSearchResultArray
//                       forKey:RealSurveyPersonType];
//    [searchResultDic setValue:realDeparmentSearchResultArray
//                       forKey:RealSurveyDeparmentType];
//
//    [searchResultDic setValue:calendarPersonSearchResultArray
//                       forKey:CalendarPersonType];
//    [searchResultDic setValue:calendarDeparmentSearchResultArray
//                       forKey:CalendarDeparmentType];
//
//    [searchResultDic setValue:realSurveyAuditorArray
//                       forKey:RealSurveyAuditor];
//    [searchResultDic setValue:remindKeywordsResultArrary
//                       forKey:KeyWordsRemindType];
//
//    [searchResultDic setValue:callRecordDeptFilterArray
//                       forKey:CallRecordDeparmentType];
//    [searchResultDic setValue:callRecordPersonFilterArray
//                       forKey:CallRecordPersonType];
//
//    [searchResultDic setValue:trustAuditingPersonSearchResultArray
//                       forKey:TrustAuditingPersonType];
//    [searchResultDic setValue:trustAuditingDeparmentSearchResultArray
//                       forKey:TrustAuditingDeparmentType];

    [_dbManager.dataBase close];

    return searchResultDic;

}


@end
