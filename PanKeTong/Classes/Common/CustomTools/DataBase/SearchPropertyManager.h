//
//  SearchPropertyManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

// 搜索房源历史纪录
#define PropListSearchType              @"PropListSearchType"                       // 房源列表搜索类型
#define TrustAuditingSearchType         @"TrustAuditingSearchType"                  // 委托审核搜索类型
#define PropCalendarSearchList          @"PropCalendarSearchList"                   // 日历行程搜索类型

/// 搜索房源历史记录（房源列表搜索、委托审核房源搜索、日历行程房源搜索）
@interface SearchPropertyManager : BaseManager

- (void)insertSearchResultType:(NSString *)searchResultType
                      andValue:(NSString *)resultValue;

- (void)deleteSearchResultWithType:(NSString *)searchResultType;

- (NSMutableDictionary *)selectSearchResultType:(NSString *)searchResultType;

/// 切换用户时，删除所有的房源搜索记录
- (void)deleteAllSearchResult;

@end
