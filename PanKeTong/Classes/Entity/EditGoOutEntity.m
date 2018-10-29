//
//  EditGoOutEntity.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/16.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EditGoOutEntity.h"

@implementation EditGoOutEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"keyId":@"KeyId",
             @"goOutCustPropArray":@"GoOutCustProps",
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

+(NSValueTransformer *)goOutCustPropArrayJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GoOutCustPropArray class]];
}

@end


@implementation GoOutCustPropArray

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"keyId":@"KeyId",
             @"goOutMsgKeyId":@"GoOutMsgKeyId",
             @"propertyKeyId":@"PropertyKeyId",
             @"propertyName":@"PropertyName",
             @"customerKeyId":@"CustomerKeyId",
             @"customerName":@"CustomerName",
             @"remark":@"Remark",
             @"createTime":@"CreateTime",
             @"isDelete":@"IsDelete",
             };
    
}

@end