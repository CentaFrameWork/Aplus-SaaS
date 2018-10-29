//
//  RemindPersonDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RemindPersonDetailEntity.h"

@implementation RemindPersonDetailEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"departmentKeyId":@"DepartmentKeyId",
             @"departmentName":@"DepartmentName",
             @"resultName":@"ResultName",
             @"resultKeyId":@"ResultKeyId",
             @"userOrDepart":@"UserOrDepart"
             };
}

@end
