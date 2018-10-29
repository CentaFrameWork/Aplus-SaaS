//
//  SignedApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SignedApi.h"

@implementation SignedApi

- (NSDictionary *)getBody
{
    return @{
             @"GoOutMsgKeyId":_goOutMsgKeyId,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeName":_employeeName,
             @"EmployeeDeptKeyId":_employeeDeptKeyId,
             @"EmployeeDeptName":_employeeDeptName,
             @"CheckInTime":_checkInTime,
             @"CheckInAddress":_checkInAddress,
             @"Longitude":_longitude,
             @"Latitude":_latitude,
             @"Height":_height,
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"permission/check-in";
    }
    return @"WebApiPermisstion/Organization-check-in";
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}


@end
