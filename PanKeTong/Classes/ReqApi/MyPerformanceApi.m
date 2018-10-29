//
//  MyPerformanceApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/7.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MyPerformanceApi.h"

@implementation MyPerformanceApi

- (NSDictionary *)getBody
{
    return @{
             @"EmployeeNo":_employeeNo,
//             @"EmpTopCount":_empTopCount,
             };
}

- (NSString *)getPath
{
    return @"customer/employee-performance";
}

- (Class)getRespClass
{
    return [MyPerformanceEntity class];
}


@end
