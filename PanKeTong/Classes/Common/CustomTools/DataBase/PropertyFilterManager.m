//
//  PropertyFilterManager.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PropertyFilterManager.h"

@implementation PropertyFilterManager

- (void)insertFilterConditionName:(NSString *)filterName
                      FilterValue:(NSString *)filterShowText
                     FilterEntity:(NSString *)filterEntity
{
    if (![_dbManager.dataBase open])
    {
        return;
    }

    NSString *sqlStr;
    if (![self isExistTable:FilterConditionList])
    {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (filterConditionName TEXT,filterConditionShowText TEXT,filterEntity TEXT)",FilterConditionList];
        [_dbManager.dataBase executeUpdate:sqlStr];
    }

    sqlStr = [NSString stringWithFormat:@"SELECT rowid FROM %@ order by rowid",FilterConditionList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];

    NSMutableArray *_rowIdArray = [[NSMutableArray alloc] init];

    while ([resultSet next])
    {
        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
    }

    /// 最多保存10条
    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10)
    {
        sqlStr = [NSString stringWithFormat:@"delete from %@ where rowid = ?",FilterConditionList];
        [_dbManager.dataBase executeUpdate:sqlStr,[_rowIdArray objectAtIndex:0]];
    }

    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?)",FilterConditionList];
    [_dbManager.dataBase executeUpdate:sqlStr,filterName,filterShowText,filterEntity];

    [_dbManager.dataBase close];
}

- (void)deleteFilterConditionName:(NSString *)filterName
{
    if (![_dbManager.dataBase open] || ![self isExistTable:FilterConditionList])
    {
        return ;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE filterConditionName = ?",@"DELETE FROM FilterConditionList WHERE filterConditionName = ?"];
    [_dbManager.dataBase executeUpdate:sqlStr,filterName];

    [_dbManager.dataBase close];

}

- (void)deleteAllFilterCondition
{
    if (![_dbManager.dataBase open] && [self isExistTable:FilterConditionList])
    {
        return;
    }
    // 删除全部筛选条件
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",FilterConditionList];
    [_dbManager.dataBase executeUpdate:sqlStr];

    [_dbManager.dataBase close];

}

- (void)updateFilterConditionName:(NSString *)newName
                             from:(NSString *)oldName
{
    if (![_dbManager.dataBase open] || ![self isExistTable:FilterConditionList])
    {
        return;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ set filterConditionName = ? where filterConditionName = ?",FilterConditionList];
    [_dbManager.dataBase executeUpdate:sqlStr,newName,oldName];

    [_dbManager.dataBase close];

}

- (void)updateFilterConditionIsCurrent:(NSString *)newFilterEntity
                        fromFilterName:(NSString*)name
{
    if (![_dbManager.dataBase open] || ![self isExistTable:FilterConditionList])
    {
        return;
    }

    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ set filterEntity = ? where filterConditionName = ?",FilterConditionList];
    [_dbManager.dataBase executeUpdate:sqlStr,newFilterEntity,name];

    [_dbManager.dataBase close];

}

- (NSMutableArray *)selectAllFilterCondition
{
    if (![_dbManager.dataBase open] || ![self isExistTable:FilterConditionList])
    {
        return nil;
    }

    NSString *sqlStr;
    NSMutableArray *filterConditionListArray = [[NSMutableArray alloc] init];

    //返回全部查询结果
    sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",FilterConditionList];
    FMResultSet *resultSet = [_dbManager.dataBase executeQuery:sqlStr];

    // 通盘房源的搜索结果
    while ([resultSet next])
    {
        DataFilterEntity *entity = [DataFilterEntity new];
        entity.nameString = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterConditionName"]];
        entity.showText =[NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterConditionShowText"]];
        entity.entity = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterEntity"]];

        [filterConditionListArray addObject:entity];
    }

    [_dbManager.dataBase close];

    return filterConditionListArray;
}

@end

//
//@implementation DataFilterEntity
//
//@end
