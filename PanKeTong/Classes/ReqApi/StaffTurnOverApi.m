//
//  StaffTurnOverApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/12.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "StaffTurnOverApi.h"
#import "StaffTurnEntity.h"

@implementation StaffTurnOverApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeName":_employeeName,
             @"EmployeeDeptKeyId":_employeeDeptKeyId,
             @"EmployeeDeptName":_employeeDeptName,
             @"OperationType":_operationType
             };
}

- (NSString *)getPath
{
    if ([CommonMethod isRequestFinalApiAddress])
    {
        return @"permission/Operation-EmployeesDeptBackup";
    }
    
    return @"WebApiPermisstion/Operation-EmployeesDeptBackup";
}

- (Class)getRespClass
{
    if ([self.operationType isEqualToString:@"0"]) {
        //删除
        return [StaffTurnEntity class];
    }

    //查询
    return [AgencyBaseEntity class];
}


@end
