//
//  TakeSeeApi.m
//  PanKeTong
//
//  Created by 张旺 on 16/12/7.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakeSeeApi.h"
#import "TakingSeeEntity.h"

@implementation TakeSeeApi

- (NSDictionary *)getBody
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @{
                 @"DepartmentName":[_departmentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 @"EmployeeName":[_employeeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 @"ScopeType":@(_scopeType),
                 @"DateTimeStart":_dateTimeStart,
                 @"DateTimeEnd":_dateTimeEnd,
                 @"SeePropertyType":_seePropertyType,
                 @"InquiryFollowSearchType":_inquiryFollowSearchType,
                 @"PageIndex":_pageIndex,
                 @"PageSize":_pageSize,
                 @"SortField":_sortField,
                 @"Ascending":_ascending
                 };
    }
    return @{
             @"DepartmentName":_departmentName,
             @"EmployeeName":_employeeName,
             @"ScopeType":@(_scopeType),
             @"DateTimeStart":_dateTimeStart,
             @"DateTimeEnd":_dateTimeEnd,
             @"SeePropertyType":_seePropertyType,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending
             };
}

- (NSString *)getPath {
    
        return @"customer/takesees";
    
}

- (Class)getRespClass {
    return [TakingSeeEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}
@end
