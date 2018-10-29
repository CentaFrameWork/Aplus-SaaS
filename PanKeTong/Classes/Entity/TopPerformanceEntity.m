//
//  TopPerformanceEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "TopPerformanceEntity.h"

@implementation SubPerformanceEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"employeeName":@"EmployeeName",
             @"employeeNo":@"EmployeeNo",
             @"deptName":@"DeptName",
             @"performance":@"Performance"
             };

}

@end


@implementation TopPerformanceEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result"
                                          }];
}

+ (NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubPerformanceEntity class]];
}

@end
