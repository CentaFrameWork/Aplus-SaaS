//
//  My MyPerformanceEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/7.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface  PerformanceItemEntity : SubBaseEntity

@property (nonatomic, copy) NSString *employeeName;     // 员工姓名
@property (nonatomic, strong) NSNumber *billCount;        // 单数
@property (nonatomic, strong) NSNumber *achievementDiff;  // 与上一名的差距
@property (nonatomic, strong) NSNumber *achievementPlace; // 排名
@property (nonatomic, strong) NSNumber *performance;      // 业绩

@end

/// 当前登录业务员个人业绩
@interface MyPerformanceEntity : AgencyBaseEntity

@property (nonatomic, strong) PerformanceItemEntity *result;

@end
