//
//  SubGoOutListEntity.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubGoOutListEntity.h"

@implementation SubGoOutListEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"keyId":@"KeyId",
             @"employeeKeyId":@"EmployeeKeyId",
             @"employeeName":@"EmployeeName",
             @"employeeDeptKeyid":@"EmployeeDeptKeyid",
             @"employeeDeptName":@"EmployeeDeptName",
             @"goOutTime":@"GoOutTime",
             @"goOutAddress":@"GoOutAddress",
             @"finishTime":@"FinishTime",
             @"finishAddress":@"FinishAddress",
             @"goOutStatus":@"GoOutStatus",
             @"remark":@"Remark",
             };
    
}

@end
