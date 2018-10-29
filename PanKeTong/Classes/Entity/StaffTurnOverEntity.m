//
//  StaffTurnOverEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/12.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "StaffTurnOverEntity.h"

@implementation StaffTurnOverEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{
             @"keyId":@"KeyId",
             @"employeeKeyId":@"EmployeeKeyId",
             @"employeeName":@"EmployeeName",
             @"employeeDeptKeyId":@"EmployeeDeptKeyId",
             @"employeeDeptName":@"EmployeeDeptName",
             @"createTime":@"CreateTime",
             @"requestSourceType":@"RequestSourceType"
             };

}


@end
