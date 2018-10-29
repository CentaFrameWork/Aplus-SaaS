//
//  GoOutListApi.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GoOutListApi.h"
#import "GoOutListEntity.h"

@implementation GoOutListApi

- (NSDictionary *)getBody
{
    return @{
             @"ScopeType":@(_scopeType),
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeName":_employeeName,
             @"EmployeeDeptKeyid":_employeeDeptKeyid,
             @"EmployeeDeptName":_employeeDeptName,
             @"StartTime":_startTime,
             @"EndTime":_endTime,
             @"GoOutStatus":_goOutStatus,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             };
}

- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"customer/gooutmessages";
    }
    return @"WebApiCustomer/get_gooutmessage_list";
}

- (Class)getRespClass
{
    return [GoOutListEntity class];
}

@end
