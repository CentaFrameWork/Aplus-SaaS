//
//  AddGoOutApi.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AddGoOutApi.h"

@implementation AddGoOutApi

- (NSDictionary *)getBody
{
    return @{
             
             @"KeyId":_keyId,
             @"GoOutCustProps":_goOutCustProps,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeName":_employeeName,
             @"EmployeeDeptKeyid":_employeeDeptKeyid,
             @"EmployeeDeptName":_employeeDeptName,
             @"GoOutTime":_goOutTime,
             @"GoOutAddress":_goOutAddress,
             @"FinishTime":_finishTime,
             @"FinishAddress":_finishAddress,
             @"GoOutStatus":_goOutStatus,
             @"Remark":_remark,
             };
}



- (NSString *)getPath
{
    if (self.commitGoOutType == addGoOut) {
        if ([CommonMethod isRequestNewApiAddress]) {
            return @"customer/gooutmessage-add";
        }
        return @"WebApiCustomer/add_gooutmessage";
    }else{
        if ([CommonMethod isRequestNewApiAddress]) {
            return @"customer/gooutmessage-edit";
        }
        return @"WebApiCustomer/edit_gooutmessage";
    }
    
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end

@implementation GoOutCustProps

- (NSDictionary *)getBody
{
    return @{
             
             @"KeyId":_keyId,
             @"GoOutMsgKeyId":_goOutMsgKeyId,
             @"PropertyKeyId":_propertyKeyId,
             @"PropertyName":_propertyName,
             @"CustomerKeyId":_customerKeyId,
             @"CustomerName":_customerName,
             @"Remark":_remark,
             @"CreateTime":_createTime,
             @"IsDelete":_isDelete,
             };
}

@end
