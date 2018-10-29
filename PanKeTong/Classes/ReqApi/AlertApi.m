//
//  AlertApi.m
//  PanKeTong
//
//  Created by 张旺 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AlertApi.h"
#import "AlertEventEntity.h"

@implementation AlertApi

- (NSDictionary *)getBody
{
    return @{
             @"TimeFrom":_timeFrom,
             @"TimeTo":_timeTo,
             @"EmployeeKeyId":_employeeKeyId,
             @"DeptKeyId":_deptKeyId,
             @"Remark":_remark,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             };
}


- (NSString *)getPath
{
    return @"WebApiPermisstion/organization-alertevent-alldata";
}


- (Class)getRespClass
{
    return [AlertEventEntity class];
}

@end
