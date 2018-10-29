//
//  AddAlertApi.m
//  PanKeTong
//
//  Created by 张旺 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AddAlertApi.h"

@implementation AddAlertApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId == nil?@"":_keyId,
             @"AlertEventStatus":(_alertEventStatus == nil)?@"":_alertEventStatus,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeName":_employeeName,
             @"EmployeeNo":_employeeNo,
             @"DeptKeyId":_deptKeyId,
             @"DeptName":_deptName,
             @"AlertEventTimes":_alertEventTimes,
             @"Remark":_remark,
             @"CreateUserKeyId":_createUserKeyId,
             };
}



- (NSString *)getPath
{
    return @"WebApiPermisstion/organization-alert-event";
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
