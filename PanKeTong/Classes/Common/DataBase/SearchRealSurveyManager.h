//
//  SearchRealSurveyManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

#define RealSurveyAuditingSearch    @"RealSurveyAuditingSearch"     // 实勘审核搜索列表
#define RealSurveyBdNameSearch      @"RealSurveyBdNameSearch"       // 实勘列表楼盘搜索列表

/// 搜索实勘
@interface SearchRealSurveyManager : BaseManager

/*
 实勘审核筛选
 */
- (void)insertRealSurveySearchResult:(NSString *)searchResultType
                            andValue:(NSString *)resultValue;
- (void)deleteRealSurveySearchResultWithType:(NSString *)searchResultType;

- (NSMutableDictionary *)selectRealSurveySearchResult;


/*
 搜索实勘栋座
 */
- (void)insertRealSurveyEstateBuildingName:(NSString *)EstateBuildingName
                              BuildingName:(NSString *)BuildingName
                               BuildingKey:(NSString *)BuildingKey
                                      time:(NSString *)time;

- (NSMutableArray *)selectRealSurveyEstateBuildingName:(NSString *)EstateBuildingName;

- (void)deleteRealSurveySearchEstateBuildingName;


@end
