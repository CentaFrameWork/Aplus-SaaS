//
//  SubAlertEventEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubAlertEventEntity.h"

@implementation SubAlertEventEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"keyId":@"KeyId",
             @"employeeKeyId":@"EmployeeKeyId",
             @"employeeName":@"EmployeeName",
             @"employeeNo":@"EmployeeNo",
             @"deptKeyId":@"DeptKeyId",
             @"deptName":@"DeptName",
             @"remark":@"Remark",
             @"alertEventTimes":@"AlertEventTimes",
             @"createTime":@"CreateTime"
             };

}


@end
