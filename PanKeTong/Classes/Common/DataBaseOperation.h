//
//  DataBaseOperation.h
//  SaleHouse
//
//  Created by 苏军朋 on 15-1-12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "SystemParamEntity.h"
#import "DataFilterEntity.h"
#import "DepartmentInfoResultEntity.h"
#import "RemindPersonDetailEntity.h"


@interface DataBaseOperation : NSObject
{
    FMDatabase *_dataBase;
}

+ (DataBaseOperation *)sharedataBaseOperation;

- (void)createDataBaseMethod;

#pragma mark - SystemParam Operation
- (void)insertSystemParamWithJson:(NSString *)sysParamJson;
- (void)deleteSystemParam;
- (SystemParamEntity *)selectSystemParam;

#pragma mark - AgencyUserInfo And Permission Operation
- (void)insertAgencyUserInfoWithJson:(NSString *)agencyUserInfo;
- (void)deleteAgencyUserInfo;
- (DepartmentInfoResultEntity *)selectAgencyUserInfo;

#pragma mark - SearchResultList Operation
/**
 *  通盘房源列表的搜索
 */
- (void)insertSearchResult:(NSString *)searchResultType
                  andValue:(NSString *)resultValue;
- (void)deleteSearchResultWithType:(NSString *)earchResultType;
- (NSMutableDictionary *)selectSearchResultType:(NSString *)searchResultType;
- (void)deleteAllSearchResult;

/**
 *  搜索提醒人或部门
 */
#pragma mark - SearchRemindPersonOrDeparmentResultList Operation

- (void)insertSearchRemindPersonResult:(NSString *)searchRemindType
                             andValue:(NSString *)resultValue;
- (void)deleteSearchRemindPersonResultWithType:(NSString *)searchRemindType;
- (NSMutableDictionary *)selectSearchRemindResult:(BOOL)isKeywords;

/**
 *  保存筛选条件
 */
#pragma mark - SaveFilterCondition Operation
- (void)insertFilterConditionName:(NSString *)filterName
                     FilterValue:(NSString *)filterShowTextw
                    FilterEntity:(NSString *)filterEntity;
- (void)deleteFilterConditionName:(NSString *)filterName;
- (void)deleteAllFilterCondition;
- (void)updateFilterConditionName:(NSString *)newName from:(NSString *)name;
- (void)updateFilterConditionIsCurrent:(NSString *)newFilterEntity fromFilterName:(NSString*)name;
- (NSMutableArray *)selectAllFilterCondition;

/**
 *  保存查看过房号的房源keyId
 */
#pragma mark - SaveCheckedRoomNum Operation

- (void)insertKeyIdOfCheckedRoomNum:(NSString *)propKeyId
                         andStaffNo:(NSString *)staffNo
                            andDate:(NSString *)date;
- (NSMutableArray *)selectAllKeyIdOfCheckedRoomNumWithStaffNo:(NSString *)staffNo andDate:(NSString *)date;

/**
 *  拨打过真实号码的房源keyid
 */
#pragma mark - CallRealPhone Operation

- (void)insertCallRealPhoneWithStaffNo:(NSString *)staffNo
                          andPropKeyId:(NSString *)propKeyId
                               andDate:(NSString *)date;

- (NSInteger)selectCountForStaffNo:(NSString *)staffNo
                           andDate:(NSString *)date;

- (void)deleteRealPhoneForStaffNo:(NSString *)staffNo
                          andDate:(NSString *)date;

- (BOOL)isExistWithStaffNo:(NSString *)staffNo
              andPropKeyId:(NSString *)propKeyId
                   andDate:(NSString *)date;

/**
 *  保存录音文件名称和录音时长
 */
#pragma mark - VoiceRecordFiles Operation

- (void)insertVoiceRecordFileName:(NSString *)fileName
                   andRecordTime:(NSString *)recordTime
                       andPropId:(NSString *)propId
                  andVoiceLength:(NSString *)voiceLength;

- (NSMutableArray *)selectVoiceRecordFilesWithPropId:(NSString *)propId;

- (BOOL)updateVoiceRecordFilesWithFileName:(NSString *)fileName toPropId:(NSString *)propId;

- (void)deleteVoiceRecordWithFileName:(NSString *)fileName;

/**
 *  RCUserMessage Operation
 */
#pragma mark - RCUserMessage Operation

- (void)insertUserTargetId:(NSString *)targetId
            andTargetName:(NSString *)targetName
              andUserIcon:(NSString *)userIcon;
- (NSMutableDictionary *)queryUserMessageWithUserId:(NSString *)userId;
- (void)deleteUserCacheMessageWithUserId:(NSString *)userId;

/**
 *  保存聊天经纪人或者用户的头像和名称信息
 */
#pragma mark - RCIMUserInfo Operation
- (void)insertRCIMUserInfoWithUserId:(NSString *)userId
                    andEntityDetail:(NSString *)entityDetail;

/**
 *  渠道公客池 归属人，公客池的搜索
 */
#pragma mark - ChiefOrPublicAccount Operation
- (void)insertChiefOrPublicAccount:(RemindPersonDetailEntity *)remindPersonDetailEntity;
- (void)deleteAllChiefOrPublicAccount;
- (NSMutableArray *)selectChiefOrPublicAccount;


#pragma mark - 保存选择条件
- (BOOL)insertSelectedConditionViewControllerName:(NSString *)viewControllerName
								   conditionName:(NSString *)conditionName
										   value:(NSString *)value
											 key:(NSString *)key;

- (NSDictionary *)selectValueAndKeyInConditionWithViewControllerName:(NSString *)viewControllerName
													  conditionName:(NSString *)conditionName;

- (NSString *)selectValueInConditionWithViewControllerName:(NSString *)viewControllerName
											conditionName:(NSString *)conditionName;

- (BOOL)updateSelectedViewController:(NSString *)viewControllerName
					  ConditionName:(NSString *)conditionName
							  value:(NSString *)value
								key:(NSString *)key;


#pragma mark - HouseIdCache
/*
 *   最近查看房源ID
 */
- (void)insertHouseID:(NSString *)houseID;
- (void)deleteFirstHouseId:(NSString *)houseId;
- (NSMutableArray *)selectHouseIdCache;
- (void)deletHouseIdCache;

#pragma mark - RealSurveySearchList
- (void)insertRealSurveySearchResult:(NSString *)searchResultType
                           andValue:(NSString *)resultValue;
- (void)deleteRealSurveySearchResultWithType:(NSString *)searchResultType;

- (NSMutableDictionary *)selectRealSurveySearchResult;


#pragma mark - 保存实勘列表栋座单元搜索历史

- (void)insertRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
                             BuildingName:(NSString *)BuildingName
                              BuildingKey:(NSString *)BuildingKey
                                     time:(NSString *)time;

- (NSMutableArray *)selectRealSurveyEstateBuildingName:(NSString *)EstateBuildingName;
- (void)deleteRealSurveySearchEstateBuildingName;
@end
