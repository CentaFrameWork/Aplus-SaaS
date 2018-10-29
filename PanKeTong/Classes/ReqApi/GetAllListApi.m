//
//  GetAllListApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GetAllListApi.h"
#import "AllListEntity.h"

@implementation GetAllListApi

- (NSDictionary *)getBody
{
    return @{
             @"ScopeType":@(_scopeType),
             @"OutScopeType":@(_outScopeType),
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeDeptKeyId":_employeeDeptKeyId,
             @"StartTime":_startTime,
             @"EndTime":_endTime,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending
             };
}

- (NSString *)getPath {
    
    
    return @"customer/takemessages";
    
}

- (Class)getRespClass
{

    return [AllListEntity class];

}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
