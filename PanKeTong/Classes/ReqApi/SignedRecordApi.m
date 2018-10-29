//
//  SignedRecordApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SignedRecordApi.h"
#import "SignedRecordEntity.h"

@implementation SignedRecordApi



- (NSDictionary *)getBody
{
    return @{
             @"GoOutMsgKeyId":_goOutMsgKeyId,
             @"Scope":_scope,
             @"TimeFrom":_timeFrom,
             @"TimeTo":_timeTo,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeDeptKeyId":_employeeDeptKeyId,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"permission/checks-in-list";
    }
    return @"WebApiPermisstion/Organization-check-alldata";
}


- (Class)getRespClass
{
    return [SignedRecordEntity class];
}


@end
