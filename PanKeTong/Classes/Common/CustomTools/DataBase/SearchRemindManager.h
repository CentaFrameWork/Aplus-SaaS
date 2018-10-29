//
//  SearchRemindManager.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseManager.h"

#define KeyWordsRemindType              @"KeyWordsRemindType"                       // 关键字搜索
#define RealSurveyAuditor               @"RealSurveyExaminePerson"                  // 实勘筛选 : 审核人

#define PersonRemindType                @"PersonRemindType"                         // 提醒人类型：员工
#define DeparmentRemindType             @"DeparmentRemindType"                      // 提醒人类型：部门
#define RealSurveyPersonType            @"RealSurveyPersonType"                     // 实勘筛选：员工
#define RealSurveyDeparmentType         @"RealSurveyDeparmentType"                  // 实勘筛选：部门
#define CallRecordPersonType            @"CallRecordPersonType"                     // 通话记录筛选：员工
#define CallRecordDeparmentType         @"CallRecordDeparmentType"                  // 通话记录筛选：部门
#define CalendarPersonType              @"CalendarPersonType"                       // 日历筛选：员工
#define CalendarDeparmentType           @"CalendarDeparmentType"                    // 日历筛选：部门
#define TrustAuditingPersonType         @"TrustAuditingPersonType"                  // 委托审核筛选：员工
#define TrustAuditingDeparmentType      @"TrustAuditingDeparmentType"               // 委托审核筛选：部门

/// 搜索提醒人/提醒部门历史记录
@interface SearchRemindManager : BaseManager

/// 增加数据
- (void)insertSearchRemindResult:(NSString *)searchRemindType
                        andValue:(NSString *)resultValue;

/// 删除
- (void)deleteSearchRemindResultWithType:(NSString *)searchRemindType;

/// 查询
- (NSMutableDictionary *)selectSearchRemindResult:(BOOL)isKeywords; // isKeywords-选择的是否为关键字

@end
