//
//  TopPerformanceApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "TopPerformanceApi.h"

@implementation TopPerformanceApi

- (NSDictionary *)getBody
{
    return @{
             @"EmployeeNo":_employeeNo,
             @"EmpTopCount":_empTopCount,
             };
}

- (NSString *)getPath
{
    return @"customer/employeearea-top-performance";
}

- (Class)getRespClass
{
    return [TopPerformanceEntity class];
}


@end
