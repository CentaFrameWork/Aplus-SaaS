//
//  TopPerformanceEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"


@interface SubPerformanceEntity : SubBaseEntity

@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeNo;
@property (nonatomic, copy) NSString *deptName;
@property (nonatomic, copy) NSString *performance;

@end


@interface TopPerformanceEntity : AgencyBaseEntity

@property (nonatomic, strong) NSArray *result;

@end
