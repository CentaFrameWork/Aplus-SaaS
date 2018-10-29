//
//  DataBaseOperation.m
//  SaleHouse
//
//  Created by 苏军朋 on 15-1-12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DataBaseOperation.h"
#import "CommonMethod.h"
#import "SearchPropDetailEntity.h"

@implementation DataBaseOperation

static DataBaseOperation* dataBaseOperation=nil;

+ (DataBaseOperation *)sharedataBaseOperation
{
    @synchronized (self) {
        if (dataBaseOperation== nil) {
            dataBaseOperation= [[self alloc] init];
            
        }
    }
    
    return dataBaseOperation;
}

//创建数据库
- (void)createDataBaseMethod
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"PaKeTongData.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:dbpath];
    
    if (![_dataBase open]) {
        return;
    }
    
    [_dataBase close];
    
}

//检查表是否存在
- (BOOL) isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [_dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    
    while ([rs next])
    {
        
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
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

#pragma mark - SystemParam
/// 保存系统参数
- (void)insertSystemParamWithJson:(NSString *)sysParamJson
{
    if (![_dataBase open]) {
        
        return;
    }
    if (![self isTableExist:@"SystemParam"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE SystemParam (systemParam TEXT)"];
    }
    
    //如果存在，删除
    [_dataBase executeUpdate:@"delete from SystemParam"];
    
    [_dataBase executeUpdate:@"INSERT INTO SystemParam VALUES (?)",sysParamJson];
    
    [_dataBase close];
}

- (void)deleteSystemParam
{
    if (![_dataBase open] && [self isTableExist:@"SystemParam"]) {
        
        return;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM SystemParam"];
    [_dataBase close];
}

- (SystemParamEntity *)selectSystemParam
{
    if (![_dataBase open] || ![self isTableExist:@"SystemParam"]) {
        return nil;
    }
    
    FMResultSet *sysParamResultSet = [_dataBase executeQuery:@"SELECT * FROM SystemParam"];
    NSString *sysParamStr = [[NSString alloc]init];
    
    while ([sysParamResultSet next]){
        sysParamStr = [NSString stringWithFormat:@"%@",[sysParamResultSet stringForColumn:@"systemParam"]];
    }
    
    [_dataBase close];
    
    SystemParamEntity *sysPram = [MTLJSONAdapter modelOfClass:[SystemParamEntity class]
                                           fromJSONDictionary:[sysParamStr jsonDictionaryFromJsonString]
                                                        error:nil];
    
    return sysPram;
}

#pragma mark - AgencyUserInfo And Permission Operation
/// A+员工信息
- (void)insertAgencyUserInfoWithJson:(NSString *)agencyUserInfo
{
    if (![_dataBase open]) {
        
        return;
    }
    if (![self isTableExist:@"AgencyUserInfo"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE AgencyUserInfo (agencyUserInfo TEXT)"];
    }
    
    //如果存在，删除
    [_dataBase executeUpdate:@"delete from AgencyUserInfo"];
    
    [_dataBase executeUpdate:@"INSERT INTO AgencyUserInfo VALUES (?)",agencyUserInfo];
    
    [_dataBase close];
}

- (void)deleteAgencyUserInfo
{
    if (![_dataBase open] && [self isTableExist:@"AgencyUserInfo"]) {
        
        return;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM AgencyUserInfo"];
    [_dataBase close];
}

- (DepartmentInfoResultEntity *)selectAgencyUserInfo
{
    if (![_dataBase open] || ![self isTableExist:@"AgencyUserInfo"]) {
        return nil;
    }
    
    FMResultSet *userInfoResultSet = [_dataBase executeQuery:@"SELECT * FROM AgencyUserInfo"];
    NSString *userInfoStr = [[NSString alloc]init];
    
    while ([userInfoResultSet next]){
        userInfoStr = [NSString stringWithFormat:@"%@",[userInfoResultSet stringForColumn:@"agencyUserInfo"]];
    }
    
    [_dataBase close];
    
    DepartmentInfoResultEntity *sysPram = [MTLJSONAdapter modelOfClass:[DepartmentInfoResultEntity class]
                                           fromJSONDictionary:[userInfoStr jsonDictionaryFromJsonString]
                                                        error:nil];
    
    return sysPram;
}

#pragma mark - SearchResultList Operation
/// 搜索记录
- (void)insertSearchResult:(NSString *)searchResultType
                 andValue:(NSString *)resultValue
{
    if (![_dataBase open]) {
        return;
    }

    NSString *sqlStr;
    if (![self isTableExist:searchResultType]) {
        sqlStr = [NSString stringWithFormat:@"CREATE TABLE %@ (searchResultType TEXT,searchResultValue TEXT)",searchResultType];
        [_dataBase executeUpdate:sqlStr];
    }

    /**
     *  删除之前保存过的搜索内容
     */
    if ([searchResultType isEqualToString:PropListSearchType]) {
        [_dataBase executeUpdate:@"delete from PropListSearchType where searchResultType = ? and searchResultValue = ?",searchResultType,resultValue];
    }
    if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
        [_dataBase executeUpdate:@"delete from TrustAuditingSearchType where searchResultType = ? and searchResultValue = ?",searchResultType,resultValue];
    }
    if ([searchResultType isEqualToString:PropCalendarSearchList]) {
        [_dataBase executeUpdate:@"delete from PropCalendarSearchList where searchResultType = ? and searchResultValue = ?",searchResultType,resultValue];
    }

    /**
     *  搜索条件保存10条
     */
    FMResultSet *resultSet;
    if ([searchResultType isEqualToString:PropListSearchType]) {
        resultSet=[_dataBase executeQuery:@"SELECT rowid FROM PropListSearchType order by rowid"];
    }
    if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
        resultSet=[_dataBase executeQuery:@"SELECT rowid FROM TrustAuditingSearchType order by rowid"];
    }
    if ([searchResultType isEqualToString:PropCalendarSearchList]) {
        resultSet=[_dataBase executeQuery:@"SELECT rowid FROM PropCalendarSearchList order by rowid"];
    }


    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];

    while ([resultSet next]){

        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];

    }

    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10) {
        if ([searchResultType isEqualToString:PropListSearchType]) {
            [_dataBase executeUpdate:@"delete from PropListSearchType where rowid = ?",[_rowIdArray objectAtIndex:0]];
        }
        if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
            [_dataBase executeUpdate:@"delete from TrustAuditingSearchType where rowid = ?",[_rowIdArray objectAtIndex:0]];
        }
        if ([searchResultType isEqualToString:PropCalendarSearchList]) {
            [_dataBase executeUpdate:@"delete from PropCalendarSearchList where rowid = ?",[_rowIdArray objectAtIndex:0]];
        }

    }

    if ([searchResultType isEqualToString:PropListSearchType]) {
        [_dataBase executeUpdate:@"INSERT INTO PropListSearchType VALUES (?,?)",searchResultType,resultValue];
    }
    if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
        [_dataBase executeUpdate:@"INSERT INTO TrustAuditingSearchType VALUES (?,?)",searchResultType,resultValue];
    }
    if ([searchResultType isEqualToString:PropCalendarSearchList]) {
        [_dataBase executeUpdate:@"INSERT INTO PropCalendarSearchList VALUES (?,?)",searchResultType,resultValue];
    }

    [_dataBase close];
}

- (void)deleteSearchResultWithType:(NSString *)searchResultType
{
    if (![_dataBase open] || ![self isTableExist:searchResultType]) {

        return ;
    }
    if ([searchResultType isEqualToString:PropListSearchType]) {
        [_dataBase executeUpdate:@"DELETE FROM PropListSearchType WHERE searchResultType = ?",searchResultType];
    }
    if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
        [_dataBase executeUpdate:@"DELETE FROM TrustAuditingSearchType WHERE searchResultType = ?",searchResultType];
    }
    if ([searchResultType isEqualToString:PropCalendarSearchList]) {
        [_dataBase executeUpdate:@"DELETE FROM PropCalendarSearchList WHERE searchResultType = ?",searchResultType];
    }

    [_dataBase close];
}

- (NSMutableDictionary *)selectSearchResultType:(NSString *)searchResultType
{
    if (![_dataBase open] || ![self isTableExist:searchResultType]) {
        return nil;
    }

    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc]init];

    NSMutableArray *propEstateSearchResultArray = [[NSMutableArray alloc]init];
    NSMutableArray *trustAudittingResultArray = [NSMutableArray array];
    NSMutableArray *calendarResultArray = [NSMutableArray array];

    //返回全部查询结果
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",searchResultType];
    FMResultSet *resultSet=[_dataBase executeQuery:sqlStr];

    /*
     * 通盘房源的搜索结果
     */
    NSString *searchResultValue;

    while ([resultSet next]){

        searchResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultType"]];
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultValue"]];

        if ([searchResultType isEqualToString:PropListSearchType]) {

            [propEstateSearchResultArray addObject:searchResultValue];
            [searchResultDic setValue:propEstateSearchResultArray forKey:PropListSearchType];
        }
        if ([searchResultType isEqualToString:TrustAuditingSearchType]) {
            [trustAudittingResultArray addObject:searchResultValue];
            [searchResultDic setValue:trustAudittingResultArray forKey:TrustAuditingSearchType];
        }
        if ([searchResultType isEqualToString:PropCalendarSearchList]) {
            [calendarResultArray addObject:searchResultValue];
            [searchResultDic setValue:calendarResultArray forKey:PropCalendarSearchList];
        }
    }

    [_dataBase close];
    return searchResultDic;
}

- (void)deleteAllSearchResultWithType:(NSString *)searchResultType
{
    if (![_dataBase open]) {

        return;
    }
    /*
     *删除全部
     */
    [_dataBase executeUpdate:@"DELETE FROM PropListSearchType"];
    [_dataBase executeUpdate:@"DELETE FROM TrustAuditingSearchType"];
    [_dataBase executeUpdate:@"DELETE FROM PropCalendarSearchList"];

    [_dataBase close];
}


#pragma mark - RealSurveySearchList
/// 实勘审核-筛选 保存搜索记录(楼盘)
- (void)insertRealSurveySearchResult:(NSString *)searchResultType
                           andValue:(NSString *)resultValue
{
    if (![_dataBase open]) {
        
        
        return;
    }
    
    if (![self isTableExist:@"RealSurveySearchResultList"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE RealSurveySearchResultList (searchResultType TEXT,searchResultValue TEXT)"];
    }
    
    /**
     *  删除之前保存过的搜索内容
     */
    [_dataBase executeUpdate:@"delete from RealSurveySearchResultList where searchResultType = ? and searchResultValue = ?",searchResultType,resultValue];
    
    
    /**
     *  搜索条件保存10条
     */
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT rowid FROM RealSurveySearchResultList order by rowid"];
    
    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];
    
    while ([resultSet next]){
        
        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
        
    }
    
    if (_rowIdArray.count != 0 && _rowIdArray.count >= 8) {
        
        [_dataBase executeUpdate:@"delete from RealSurveySearchResultList where rowid = ?",[_rowIdArray objectAtIndex:0]];
    }
    
    [_dataBase executeUpdate:@"INSERT INTO RealSurveySearchResultList VALUES (?,?)",searchResultType,resultValue];
    
    [_dataBase close];
}


- (void)deleteRealSurveySearchResultWithType:(NSString *)searchResultType
{
    if (![_dataBase open] || ![self isTableExist:@"RealSurveySearchResultList"]) {
        
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM RealSurveySearchResultList WHERE searchResultType = ?",searchResultType];
    [_dataBase close];
}

- (NSMutableDictionary *)selectRealSurveySearchResult
{
    if (![_dataBase open] || ![self isTableExist:@"RealSurveySearchResultList"]) {
        
        
        return nil;
    }
    
    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *propEstateSearchResultArray = [[NSMutableArray alloc]init];
    
    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM RealSurveySearchResultList"];
    
    /*
     * 通盘房源的搜索结果
     */
    NSString *searchResultType;
    NSString *searchResultValue;
    
    while ([resultSet next]){
        
        searchResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultType"]];
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchResultValue"]];
        
        if ([searchResultType isEqualToString:RealSurveyAuditingSearch]) {
            
            [propEstateSearchResultArray addObject:searchResultValue];
        }
        
    }
    
    [_dataBase close];
    
    [searchResultDic setValue:propEstateSearchResultArray forKey:RealSurveyAuditingSearch];
    
    return searchResultDic;
}





#pragma mark - SearchRemindPersonOrDeparmentResultList Operation
/// 保存搜索记录
- (void)insertSearchRemindPersonResult:(NSString *)searchRemindType
                             andValue:(NSString *)resultValue
{
    
    if (![_dataBase open]) {
        return;
    }
    
    if (![self isTableExist:@"SearchRemindList"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE SearchRemindList (searchRemindType TEXT,searchRemindValue TEXT)"];
    }
    
    /**
     *  删除之前保存过的搜索内容
     */
    [_dataBase executeUpdate:@"delete from SearchRemindList where searchRemindType = ? and searchRemindValue = ?",searchRemindType,resultValue];
	
    /**
     *  搜索条件保存10条
     */
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT rowid FROM SearchRemindList order by rowid"];
    
    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];
    
    while ([resultSet next]){
        
        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
        
    }
    
    if (_rowIdArray.count != 0 && _rowIdArray.count >= 8) {
        
        [_dataBase executeUpdate:@"delete from SearchRemindList where rowid = ?",[_rowIdArray objectAtIndex:0]];
    }
    
    [_dataBase executeUpdate:@"INSERT INTO SearchRemindList VALUES (?,?)",searchRemindType,resultValue];
    
    [_dataBase close];
}

- (void)deleteSearchRemindPersonResultWithType:(NSString *)searchRemindType
{
    
    if (![_dataBase open] || ![self isTableExist:@"SearchRemindList"]) {
        
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM SearchRemindList WHERE searchRemindType = ?",searchRemindType];
    [_dataBase close];
}

- (NSMutableDictionary *)selectSearchRemindResult:(BOOL)isKeywords
{
    
    if (![_dataBase open] || ![self isTableExist:@"SearchRemindList"]) {
        return nil;
    }
    
    NSMutableDictionary *searchResultDic = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *remindPersonSearchResultArray = [NSMutableArray array];
    NSMutableArray *remindDeparmentSearchResultArray = [NSMutableArray array];
    NSMutableArray *realPersonSearchResultArray = [NSMutableArray array];
    NSMutableArray *realDeparmentSearchResultArray = [NSMutableArray array];
	NSMutableArray *remindKeywordsResultArrary = [NSMutableArray array];
    NSMutableArray *examinePersonArray = [NSMutableArray array];
    NSMutableArray *calendarPersonSearchResultArray = [NSMutableArray array];
    NSMutableArray *calendarDeparmentSearchResultArray = [NSMutableArray array];
    NSMutableArray *callRecordPersonFilterArray = [NSMutableArray array];
    NSMutableArray *callRecordDeptFilterArray = [NSMutableArray array];
    NSMutableArray *trustAuditingPersonSearchResultArray = [NSMutableArray array];
    NSMutableArray *trustAuditingDeparmentSearchResultArray = [NSMutableArray array];
    NSMutableArray *clientFilterPersonSearchResultArray = [NSMutableArray array];
    NSMutableArray *clientFilterDepartmentSearchResultArray = [NSMutableArray array];


    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM SearchRemindList"];
	
    /*
     * 通盘房源的搜索结果
     */
    NSString *searchRemindResultType;
    NSString *searchRemindResultValue;
	
	while ([resultSet next]){
		
		if (isKeywords) {
			searchRemindResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindType"]];
			searchRemindResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindValue"]];
			if ([searchRemindResultType isEqualToString:@"KeywordsRemindType"]) {
				[remindKeywordsResultArrary addObject:searchRemindResultValue];
			}
			
		}else{
			searchRemindResultType = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindType"]];
			searchRemindResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"searchRemindValue"]];
			
			if ([searchRemindResultType isEqualToString:PersonRemindType]) {
				
				[remindPersonSearchResultArray addObject:searchRemindResultValue];
				
			}else if([searchRemindResultType isEqualToString:DeparmentRemindType]){
				
				[remindDeparmentSearchResultArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:RealSurveyPersonType]){
                
                [realPersonSearchResultArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:RealSurveyDeparmentType]){
                
                [realDeparmentSearchResultArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:RealSurveyAuditor]){
                
                [examinePersonArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:CalendarDeparmentType]){

                [calendarDeparmentSearchResultArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:CalendarPersonType]){

                [calendarPersonSearchResultArray addObject:searchRemindResultValue];
            }else if([searchRemindResultType isEqualToString:CallRecordPersonType]){
                
                [callRecordPersonFilterArray addObject:searchRemindResultValue];
            }
            else if([searchRemindResultType isEqualToString:CallRecordDeparmentType]){
                
                [callRecordDeptFilterArray addObject:searchRemindResultValue];
            }else if ([searchRemindResultType isEqualToString:TrustAuditingPersonType]){

                [trustAuditingPersonSearchResultArray addObject:searchRemindResultValue];

            }else if ([searchRemindResultType isEqualToString:TrustAuditingDeparmentType]){
                
                [trustAuditingDeparmentSearchResultArray addObject:searchRemindResultValue];
            }else if ([searchRemindResultType isEqualToString:ClientFilterPersonType]){
                [clientFilterPersonSearchResultArray addObject:searchRemindResultValue];
            }else if ([searchRemindResultType isEqualToString:ClientFilterDepartmentType]){
                [clientFilterDepartmentSearchResultArray addObject:searchRemindResultValue];
            }
		}
	}
	
    [searchResultDic setValue:remindPersonSearchResultArray
                       forKey:PersonRemindType];
    [searchResultDic setValue:remindDeparmentSearchResultArray
                       forKey:DeparmentRemindType];
    [searchResultDic setValue:realPersonSearchResultArray
                       forKey:RealSurveyPersonType];
    [searchResultDic setValue:realDeparmentSearchResultArray
                       forKey:RealSurveyDeparmentType];
    [searchResultDic setValue:calendarPersonSearchResultArray
                       forKey:CalendarPersonType];
    [searchResultDic setValue:calendarDeparmentSearchResultArray
                       forKey:CalendarDeparmentType];
    [searchResultDic setValue:examinePersonArray
                       forKey:RealSurveyAuditor];
	[searchResultDic setValue:remindKeywordsResultArrary
					   forKey:@"KeywordsRemindType"];
    [searchResultDic setValue:callRecordDeptFilterArray
                       forKey:CallRecordDeparmentType];
    [searchResultDic setValue:callRecordPersonFilterArray
                       forKey:CallRecordPersonType];
    [searchResultDic setValue:trustAuditingPersonSearchResultArray
                       forKey:TrustAuditingPersonType];
    [searchResultDic setValue:trustAuditingDeparmentSearchResultArray
                       forKey:TrustAuditingDeparmentType];
    [searchResultDic setValue:clientFilterPersonSearchResultArray forKey:ClientFilterPersonType];
    [searchResultDic setValue:clientFilterDepartmentSearchResultArray forKey:ClientFilterDepartmentType];
	
    [_dataBase close];
    
    return searchResultDic;
}

#pragma mark - SaveFilterCondition Operation

// 房源列表保存搜索条件
- (void)insertFilterConditionName:(NSString *)filterName
                     FilterValue:(NSString *)filterShowText
                    FilterEntity:(NSString *)filterEntity
{
    if (![_dataBase open])
    {
        return;
    }

    if (![self isTableExist:@"FilterConditionList"]) {

        [_dataBase executeUpdate:@"CREATE TABLE FilterConditionList (filterConditionName TEXT,filterConditionShowText TEXT,filterEntity TEXT)"];
    }

    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT rowid FROM FilterConditionList order by rowid"];

    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];

    while ([resultSet next]){

        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];

    }

    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10) {

        [_dataBase executeUpdate:@"delete from FilterConditionList where rowid = ?",[_rowIdArray objectAtIndex:0]];
    }

    [_dataBase executeUpdate:@"INSERT INTO FilterConditionList VALUES (?,?,?)",filterName,filterShowText,filterEntity];
    
    [_dataBase close];

}
- (void)deleteFilterConditionName:(NSString *)filterName
{
    if (![_dataBase open] || ![self isTableExist:@"FilterConditionList"]) {

        return ;
    }

    [_dataBase executeUpdate:@"DELETE FROM FilterConditionList WHERE filterConditionName = ?",filterName];
    [_dataBase close];
}
- (void)deleteAllFilterCondition
{
    if (![_dataBase open] && [self isTableExist:@"FilterConditionList"]) {

        return;
    }
    /*
     *删除全部
     */
    [_dataBase executeUpdate:@"DELETE FROM FilterConditionList"];

    [_dataBase close];
}
- (void)updateFilterConditionName:(NSString *)newName from:(NSString *)name
{

    if (![_dataBase open] || ![self isTableExist:@"FilterConditionList"]) {
        return;
    }

    [_dataBase executeUpdate:@"UPDATE FilterConditionList set filterConditionName = ? where filterConditionName = ? ",newName,name];

    [_dataBase close];
}
- (void)updateFilterConditionIsCurrent:(NSString *)newFilterEntity fromFilterName:(NSString*)name;
{
    if (![_dataBase open] || ![self isTableExist:@"FilterConditionList"]) {
        return;
    }

    [_dataBase executeUpdate:@"UPDATE FilterConditionList set filterEntity = ? where filterConditionName = ? ",newFilterEntity,name];

    [_dataBase close];
}
- (NSMutableArray *)selectAllFilterCondition
{
    if (![_dataBase open] || ![self isTableExist:@"FilterConditionList"]) {


        return nil;
    }


    NSMutableArray *filterConditionListArray = [[NSMutableArray alloc]init];

    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM FilterConditionList"];

    /*
     * 通盘房源的搜索结果
     */

    while ([resultSet next]){

        DataFilterEntity * entity=[DataFilterEntity new];
        entity.nameString = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterConditionName"]];
        entity.showText =[NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterConditionShowText"]];
        entity.entity = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"filterEntity"]];

       [filterConditionListArray addObject:entity];

    }

    [_dataBase close];


    return filterConditionListArray;
}


/**
 *  保存查看过房号的房源keyId
 */
#pragma mark - SaveCheckedRoomNum Operation
/// 保存查看过房号的房源keyId
- (void)insertKeyIdOfCheckedRoomNum:(NSString *)propKeyId
                        andStaffNo:(NSString *)staffNo
                            andDate:(NSString *)date
{
    
    if (![_dataBase open]) {
        
        return;
    }
    
    if (![self isTableExist:@"CheckedRoomNumPropList"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE CheckedRoomNumPropList (staffNo TEXT,propKeyId TEXT,date TEXT)"];
    }
    
    
    [_dataBase executeUpdate:@"INSERT INTO CheckedRoomNumPropList VALUES (?,?,?)",staffNo,propKeyId,date];
    
    [_dataBase close];
    
}

- (NSMutableArray *)selectAllKeyIdOfCheckedRoomNumWithStaffNo:(NSString *)staffNo andDate:(NSString *)date
{
    
    if (![_dataBase open] || ![self isTableExist:@"CheckedRoomNumPropList"]) {
        
        
        return nil;
    }
    
    
    NSMutableArray *checkedRoomNumKeyIds = [[NSMutableArray alloc]init];
    
    //返回当前用户的全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM CheckedRoomNumPropList where staffNo = ? and date = ?",staffNo,date];
    
    /*
     *全部的查看过房号的keyId
     */
    NSString *searchResultValue;
    
    while ([resultSet next]){
        
        searchResultValue = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"propKeyId"]];

        [checkedRoomNumKeyIds addObject:searchResultValue];
        
    }
    
    [_dataBase close];
    
    
    return checkedRoomNumKeyIds;
}


#pragma mark - CallRealPhone Operation
// 拨打过真实号码的房源keyid
- (void)insertCallRealPhoneWithStaffNo:(NSString *)staffNo
                          andPropKeyId:(NSString *)propKeyId
                               andDate:(NSString *)date
{
    if (![_dataBase open]) {
        return;
    }
    if (![self isTableExist:@"CallRealPhone"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE CallRealPhone (staffNo TEXT,propKeyId TEXT,date TEXT)"];
    }
    
    [_dataBase executeUpdate:@"INSERT INTO CallRealPhone VALUES (?,?,?)",staffNo,propKeyId,date];
    
    [_dataBase close];
}

- (NSInteger)selectCountForStaffNo:(NSString *)staffNo
                           andDate:(NSString *)date
{
    if (![_dataBase open] || ![self isTableExist:@"CallRealPhone"]) {
        return 0;
    }
    
    FMResultSet *resultSet = [_dataBase executeQuery:
                                      @"SELECT * FROM CallRealPhone WHERE staffNo = ? and date = ?",
                                      staffNo,
                                      date];
    
    NSInteger count = 0;
    
    while ([resultSet next]){
        count ++;
    }
    
    [_dataBase close];
    
    return count;
}

- (void)deleteRealPhoneForStaffNo:(NSString *)staffNo
                          andDate:(NSString *)date
{
    if (![_dataBase open] || ![self isTableExist:@"CallRealPhone"]) {
        return;
    }
    [_dataBase executeUpdate:@"DELETE FROM CallRealPhone WHERE staffNo = ? and date != ?",
     staffNo,
     date];
    
    [_dataBase close];
}

- (BOOL)isExistWithStaffNo:(NSString *)staffNo
              andPropKeyId:(NSString *)propKeyId
                   andDate:(NSString *)date
{
    if (![_dataBase open] || ![self isTableExist:@"CallRealPhone"]) {
        return NO;
    }
    
    FMResultSet *resultSet = [_dataBase executeQuery:
                              @"SELECT * FROM CallRealPhone WHERE staffNo = ? and propKeyId = ? and date = ?",
                              staffNo,
                              propKeyId,
                              date];
    
    NSInteger count = 0;
    
    while ([resultSet next]){
        count ++;
    }
    
    [_dataBase close];
    
    if(count > 0){
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - VoiceRecordFiles Operation
// //保存录音文件名，用来显示的时候用
- (void)insertVoiceRecordFileName:(NSString *)fileName
                   andRecordTime:(NSString *)recordTime
                       andPropId:(NSString *)propId
                  andVoiceLength:(NSString *)voiceLength
{
    if (![_dataBase open]) {
        return;
    }
    if (![self isTableExist:@"VoiceRecordFiles"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE VoiceRecordFiles (fileName TEXT,recordTime TEXT,propId TEXT,voiceLength TEXT)"];
    }
    
    [_dataBase executeUpdate:@"INSERT INTO VoiceRecordFiles VALUES (?,?,?,?)",fileName,recordTime,propId,voiceLength];
    
    [_dataBase close];
    
}

- (NSMutableArray *)selectVoiceRecordFilesWithPropId:(NSString *)propId
{
    if (![_dataBase open] || ![self isTableExist:@"VoiceRecordFiles"]) {
        
        return nil;
    }
    
    NSMutableArray *voiceRecordFilesArray = [[NSMutableArray alloc]init];
    
    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM VoiceRecordFiles where propId = ?",propId];
    
    /*
     * 所有保存的录音文件
     */
    NSString *voiceRecordFileName;
    NSString *voiceRecordLength;
    NSString *voiceRecordTime;
    
    while ([resultSet next]){
        
        voiceRecordFileName = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"fileName"]];
        voiceRecordLength = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"voiceLength"]];
        voiceRecordTime = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"recordTime"]];
        
        NSDictionary *voiceRecordFileDic = [[NSDictionary alloc]initWithObjectsAndKeys:voiceRecordFileName,@"fileName",voiceRecordLength,@"voiceLength",voiceRecordTime,@"recordTime",nil];
        
        [voiceRecordFilesArray addObject:voiceRecordFileDic];
        
    }
    
    [_dataBase close];
    
    return voiceRecordFilesArray;
}

- (BOOL)updateVoiceRecordFilesWithFileName:(NSString *)fileName toPropId:(NSString *)propId{
	if (![_dataBase open] || ![self isTableExist:@"VoiceRecordFiles"]) {
		
		return NO;
	}
	
	/*
	 * 绑定录音文件到指定房源ID
	 */
	BOOL isSuccess = [_dataBase executeUpdate:@"UPDATE VoiceRecordFiles set propId = ? WHERE fileName = ?",propId,fileName];
	[_dataBase close];
	
	return isSuccess;
}


- (void)deleteVoiceRecordWithFileName:(NSString *)fileName
{
    
    if (![_dataBase open] || ![self isTableExist:@"VoiceRecordFiles"]) {
        
        return;
    }
    
    /*
     * 删除保存的录音文件
     */
    [_dataBase executeUpdate:@"DELETE FROM VoiceRecordFiles WHERE fileName = ?",fileName];
    
    [_dataBase close];
}


#pragma mark - Insert_User_TargetId_TargetName_ForRongCloud
- (void)insertUserTargetId:(NSString *)targetId
            andTargetName:(NSString *)targetName
              andUserIcon:(NSString *)userIcon
{
    
    if (![_dataBase open]) {
        
        return;
    }
    
    if (![self isTableExist:@"RCUserMessage"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE RCUserMessage (userId TEXT,userName TEXT,userIcon TEXT)"];
    }
    
    targetId = [targetId lowercaseString];
    
    /*
     *  删除之前的userId
     *
     */
    
    [_dataBase executeUpdate:@"DELETE FROM RCUserMessage WHERE userId = ?",targetId];
    
    
    //插入当前用户
    
    [_dataBase executeUpdate:@"INSERT INTO RCUserMessage VALUES (?,?,?)",targetId,targetName,userIcon];
    
    
}

- (NSMutableDictionary *)queryUserMessageWithUserId:(NSString *)userId
{
    if (![_dataBase open] || ![self isTableExist:@"RCUserMessage"]) {
        
        return nil;
    }
    
    userId = [userId lowercaseString];
    
    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM RCUserMessage WHERE userId = ?",userId];
    
    NSString *currentUserId;
    NSMutableDictionary *currentUserDic = [[NSMutableDictionary alloc]init];
    
    while ([resultSet next]){
        
        currentUserId = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"userId"]];
        
        if ([userId isEqualToString:currentUserId]) {
            
            NSString * currentUserName = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"userName"]];
            NSString * currentUserIcon = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"userIcon"]];
            
            [currentUserDic setObject:currentUserId
                               forKey:@"userId"];
            [currentUserDic setObject:currentUserName
                               forKey:@"userName"];
            [currentUserDic setObject:currentUserIcon
                               forKey:@"userIcon"];
        }
    }
    
    [_dataBase close];
    
    return currentUserDic;
    
}

- (void)deleteUserCacheMessageWithUserId:(NSString *)userId
{
    if (![_dataBase open] || ![self isTableExist:@"RCUserMessage"]) {
        
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM RCUserMessage WHERE userId = ?",userId];
    [_dataBase close];
}



#pragma mark - ChiefOrPublicAccount Operation
/**
 *  渠道公客池 归属人，公客池的搜索
 */
- (void)insertChiefOrPublicAccount:(RemindPersonDetailEntity *)remindPersonDetailEntity
{
    if (![_dataBase open]) {
        return;
    }
    
    if (![self isTableExist:@"ChiefOrPublicAccount"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE ChiefOrPublicAccount (objectJson TEXT)"];
    }
    
    NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:remindPersonDetailEntity];
    NSString *objectJson = [jsonDic JSONString];
    
    /**
     *  删除之前保存过相同的搜索内容
     */
    [_dataBase executeUpdate:@"delete from ChiefOrPublicAccount where objectJson = ? ",objectJson];
    
    
    /**
     *  搜索条件保存10条
     */
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT rowid FROM ChiefOrPublicAccount order by rowid"];
    
    NSMutableArray *_rowIdArray = [[NSMutableArray alloc]init];
    
    while ([resultSet next]){
        
        [_rowIdArray addObject:[NSString stringWithFormat:@"%@",
                                [resultSet stringForColumn:@"rowid"]]];
        
    }
    
    if (_rowIdArray.count != 0 && _rowIdArray.count >= 10) {
        
        [_dataBase executeUpdate:@"delete from ChiefOrPublicAccount where rowid = ?",[_rowIdArray objectAtIndex:0]];
    }
    
    [_dataBase executeUpdate:@"INSERT INTO ChiefOrPublicAccount VALUES (?)",objectJson];
    
    [_dataBase close];
}

- (void)deleteAllChiefOrPublicAccount
{
    if (![_dataBase open] || ![self isTableExist:@"ChiefOrPublicAccount"]) {
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM ChiefOrPublicAccount"];
    [_dataBase close];
}

- (NSMutableArray *)selectChiefOrPublicAccount
{
    if (![_dataBase open] || ![self isTableExist:@"ChiefOrPublicAccount"]) {
        
        
        return nil;
    }
    
    
    NSMutableArray *remindChiefOrPublicAccountArray = [[NSMutableArray alloc]init];
    
    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM ChiefOrPublicAccount"];
    
    
    while ([resultSet next]){
        
        NSString *json = [resultSet stringForColumn:@"objectJson"];
        RemindPersonDetailEntity *remindResult = [MTLJSONAdapter modelOfClass:[RemindPersonDetailEntity class]
                                                      fromJSONDictionary:[json jsonDictionaryFromJsonString]
                                                            error:nil];
        
        [remindChiefOrPublicAccountArray addObject:remindResult];
    }
    
    [_dataBase close];
    
    return remindChiefOrPublicAccountArray;
}

#pragma mark - 保存选择条件
- (BOOL)insertSelectedConditionViewControllerName:(NSString *)viewControllerName
								   conditionName:(NSString *)conditionName
										   value:(NSString *)value
											 key:(NSString *)key{
	if (![_dataBase open]) {
		return NO;
	}
	
	BOOL flag = [_dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_SelectedCondition (id integer PRIMARY KEY,viewControllerName text NOT NULL,conditionName text NOT NULL,value TEXT NOT NULL,keyId TEXT NOT NULL)"];
	if (!flag) {
		NSLog(@"创建数据库失败");
		return NO;
	}
	
	flag = [_dataBase executeUpdate:@"INSERT INTO t_SelectedCondition (viewControllerName,conditionName,value,keyId) VALUES (?,?,?,?)" withArgumentsInArray:@[viewControllerName,conditionName,value,key]];
	[_dataBase close];
	
	return flag;
	
}

- (NSDictionary *)selectValueAndKeyInConditionWithViewControllerName:(NSString *)viewControllerName
													  conditionName:(NSString *)conditionName{
	if (![_dataBase open]) {
		return nil;
	}
	
	FMResultSet *set = [_dataBase executeQuery:@"SELECT value,keyId FROM t_SelectedCondition WHERE viewControllerName = ? AND conditionName = ?",viewControllerName,conditionName];
	
	NSString *value = [NSString new];
	NSString *key = [NSString new];
	
	while (set.next) {
		value = [set stringForColumn:@"value"];
		key = [set stringForColumn:@"keyId"];
	}
	
	return @{value:key};
}

- (NSString *)selectValueInConditionWithViewControllerName:(NSString *)viewControllerName
											conditionName:(NSString *)conditionName{
	if (![_dataBase open]) {
		return nil;
	}
	
	FMResultSet *set = [_dataBase executeQuery:@"SELECT value FROM t_SelectedCondition WHERE viewControllerName = ? AND conditionName = ?",viewControllerName,conditionName];
	
	NSString *value = [NSString new];
	
	while (set.next) {
		value = [set stringForColumn:@"value"];
	}
	
	return value;
}


- (BOOL)updateSelectedViewController:(NSString *)viewControllerName
					  ConditionName:(NSString *)conditionName
							  value:(NSString *)value
								key:(NSString *)key{
	if (![_dataBase open]) {
		return NO;
	}
	
	BOOL flag;
	if (key.length > 0) {
		flag = [_dataBase executeUpdate:@"UPDATE t_SelectedCondition set value = ?, keyId = ? where conditionName = ? and viewControllerName = ?" withArgumentsInArray:@[value,key,conditionName,viewControllerName]];
	}else{
		flag = [_dataBase executeUpdate:@"UPDATE t_SelectedCondition set value = ? where conditionName = ? and viewControllerName = ? ",value,conditionName,viewControllerName];
	}
	
	[_dataBase close];
	
	return flag;
}


#pragma mark - HouseIdCache
// 记录查看过房号的房源keyid
- (void)insertHouseID:(NSString *)houseID
{
    if (![_dataBase open]) {
        
        return;
    }
    if (![self isTableExist:@"HouseIdCache"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE HouseIdCache (houseID TEXT)"];
    }
    
    
    [_dataBase executeUpdate:@"INSERT INTO HouseIdCache VALUES (?)",houseID];
    
    [_dataBase close];
}


- (void)deleteFirstHouseId:(NSString *)houseId
{
    if (![_dataBase open] && [self isTableExist:@"HouseIdCache"]) {
        
        return;
    }
    
    [_dataBase executeUpdate:@"delete from HouseIdCache where houseID = ?",houseId];
    [_dataBase close];
}


- (NSMutableArray *)selectHouseIdCache
{
    if (![_dataBase open] || ![self isTableExist:@"HouseIdCache"]) {
        
        
        return nil;
    }
    
    
    NSMutableArray *HouseIdArray = [[NSMutableArray alloc]init];
    
    //返回全部查询结果
    FMResultSet *resultSet=[_dataBase executeQuery:@"SELECT * FROM HouseIdCache"];
    
    
    while ([resultSet next]){
        
        NSString *json = [resultSet stringForColumn:@"houseID"];
        
        if (json) {
            [HouseIdArray addObject:json];
        }
        
    }
    
    [_dataBase close];
    
    return HouseIdArray;
}

- (void)deletHouseIdCache
{
    if (![_dataBase open] || ![self isTableExist:@"HouseIdCache"]) {
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM HouseIdCache"];
    [_dataBase close];
    
}


#pragma mark - 保存实勘列表栋座单元搜索历史
// 保存实勘列表栋座单元搜索历史
- (void)insertRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
                             BuildingName:(NSString *)BuildingName
                              BuildingKey:(NSString *)BuildingKey
                                     time:(NSString *)time
{
    
    if (![_dataBase open]) {
        
        return;
    }
    
    if (![self isTableExist:@"RealSurveyBdNameSearch"]) {
        
        [_dataBase executeUpdate:@"CREATE TABLE RealSurveyBdNameSearch (itemText TEXT,itemValue TEXT,extendAttr TEXT,time TEXT)"];
    }
    
    /*
     * 删除之前存储过的经纪人
     *
     */
    
    [_dataBase executeUpdate:@"delete from RealSurveyBdNameSearch where itemText = ? and itemValue = ? and  extendAttr = ?",BuildingName,BuildingKey,EstateBuildingName];
    
    
    [_dataBase executeUpdate:@"INSERT INTO RealSurveyBdNameSearch VALUES (?,?,?,?)",BuildingName,BuildingKey,EstateBuildingName,time];
    
    
    
    
    NSMutableArray *array = [dataBaseOperation selectRealSurveyEstateBuildingName:EstateBuildingName];
    
    if (array.count > 10) {
        
        SearchPropDetailEntity *searchEntity = [array firstObject];
        [_dataBase executeUpdate:@"delete from RealSurveyBdNameSearch where itemValue = ? ",searchEntity.itemValue];

    }
    
    
    
    [_dataBase close];
    
    
}

- (NSMutableArray *)selectRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
{
    if (![_dataBase open]) {
        return nil;
    }
    
    FMResultSet *set = [_dataBase executeQuery:@"SELECT * FROM RealSurveyBdNameSearch WHERE extendAttr = ? ",EstateBuildingName];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set next]) {
    
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
    if (![_dataBase open] || ![self isTableExist:@"RealSurveyBdNameSearch"]) {
        
        return ;
    }
    
    [_dataBase executeUpdate:@"DELETE FROM RealSurveyBdNameSearch"];
    [_dataBase close];
}




@end
