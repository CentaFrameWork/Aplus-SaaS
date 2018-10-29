//
//  SearchRealSurveyManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SearchRealSurveyManager.h"
#import "SearchPropEntity.h"

@implementation SearchRealSurveyManager

/*
 实勘审核筛选
 */
- (void)insertRealSurveySearchResult:(NSString *)searchResultType
                            andValue:(NSString *)resultValue
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;
    if (![self isExistTable:RealSurveySearchResultList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (searchResultType TEXT,searchResultValue TEXT)",RealSurveySearchResultList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    // 删除之前保存过的搜索内容
    sqlStr = [NSString stringWithFormat:@"delete from %@ where searchResultType = ? and searchResultValue = ?",RealSurveySearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType,resultValue];

    // 搜索条件保存10条
    sqlStr = [NSString stringWithFormat:@"SELECT rowid FROM %@ order by rowid",RealSurveySearchResultList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];

    NSMutableArray *rowIdArray = [[NSMutableArray alloc] init];
    while ([resultSet next])
    {
        [rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
    }

    if (rowIdArray.count != 0 && rowIdArray.count >= 10)
    {
        sqlStr = [NSString stringWithFormat:@"delete from %@ where rowid = ?",RealSurveySearchResultList];
        [_dbManager.dataBase executeUpdate:sqlStr,[rowIdArray objectAtIndex:0]];
    }
    rowIdArray = nil;

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?)",RealSurveySearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType,resultValue];

    [_dbManager.dataBase close];
}

- (void)deleteRealSurveySearchResultWithType:(NSString *)searchResultType
{
    if (![_dbManager.dataBase open] || ![self isExistTable:RealSurveySearchResultList])
    {
        return ;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE searchResultType = ?",RealSurveySearchResultList];
    [_dbManager.dataBase executeUpdate:sqlStr,searchResultType];
    [_dbManager.dataBase close];
}

- (NSMutableDictionary *)selectRealSurveySearchResult
{
    if (![_dbManager.dataBase open] || ![self isExistTable:RealSurveySearchResultList])
    {
        return nil;
    }

    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc] init];

    NSMutableArray *propEstateSearchResultArray = [[NSMutableArray alloc] init];

    //返回全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ where searchResultType = ?",RealSurveySearchResultList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr,RealSurveyAuditingSearch];

    // 通盘房源的搜索结果
    NSString *searchResultType;
    NSString *searchResultValue;
    while ([resultSet next])
    {
        searchResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultType"]];
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultValue"]];

        [propEstateSearchResultArray addObject:searchResultValue];
    }

    [_dbManager.dataBase close];

    [searchResultDic setValue:propEstateSearchResultArray forKey:RealSurveyAuditingSearch];

    return searchResultDic;
}


/*
 搜索实勘栋座
 */
- (void)insertRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
                              BuildingName:(NSString *)BuildingName
                               BuildingKey:(NSString *)BuildingKey
                                      time:(NSString *)time
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;
    if (![self isExistTable:RealSurveyBdNameSearchList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (itemText TEXT,itemValue TEXT,extendAttr TEXT,time TEXT)",RealSurveyBdNameSearchList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    // 删除之前存储过的经纪人
    sqlStr = [NSString stringWithFormat:@"delete from %@ where itemText = ? and itemValue = ? and  extendAttr = ?",RealSurveyBdNameSearchList];
    [_dbManager.dataBase executeUpdate:sqlStr,BuildingName,BuildingKey,EstateBuildingName];

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?)",RealSurveyBdNameSearchList];
    [_dbManager.dataBase executeUpdate:sqlStr,BuildingName,BuildingKey,EstateBuildingName,time];

    NSMutableArray *array = [self selectRealSurveyEstateBuildingName:EstateBuildingName];
    if (array.count > 10)
    {
        SearchPropDetailEntity *searchEntity = [array firstObject];
        sqlStr = [NSString stringWithFormat:@"delete from %@ where itemValue = ?",RealSurveyBdNameSearchList];
        [_dbManager.dataBase executeUpdate:sqlStr,searchEntity.itemValue];
    }

    [_dbManager.dataBase close];
}

- (NSMutableArray *)selectRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
{
    if (![_dbManager.dataBase open] || ![self isExistTable:RealSurveyBdNameSearch])
    {
        return nil;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE extendAttr = ?",RealSurveyBdNameSearchList];
    FMResultSet *set = [_dbManager.dataBase executeQuery:sqlStr,EstateBuildingName];
    NSMutableArray *array = [NSMutableArray array];

    while ([set next])
    {
        SearchPropDetailEntity *searchEntity = [SearchPropDetailEntity new];
        searchEntity.itemValue = [set stringForColumn:@"itemValue"];
        searchEntity.itemText = [set stringForColumn:@"itemText"];
        searchEntity.time = [set stringForColumn:@"time"];
        searchEntity.extendAttr = [set stringForColumn:@"extendAttr"];
        [array addObject:searchEntity];
    }

    return array;
}

- (void)deleteRealSurveySearchEstateBuildingName
{
    if (![_dbManager.dataBase open] || ![self isExistTable:RealSurveyBdNameSearch])
    {
        return ;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",RealSurveyBdNameSearch];
    [_dbManager.dataBase executeUpdate:sqlStr];
    [_dbManager.dataBase close];
}


@end
