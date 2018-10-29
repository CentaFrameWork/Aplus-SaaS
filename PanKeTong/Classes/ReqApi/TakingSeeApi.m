//
//  TakingSeeApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakingSeeApi.h"
#import "TakingSeeEntity.h"

@implementation TakingSeeApi

- (NSDictionary *)getBody
{
    return @{
             @"DepartmentName":[_departmentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"EmployeeName":[_employeeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             @"ScopeType":@(_scopeType),
             @"DateTimeStart":_dateTimeStart,
             @"DateTimeEnd":_dateTimeEnd,
             @"SeePropertyType":_seePropertyType,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,
             @"InquiryFollowSearchType":_inquiryFollowSearchType
             };
}


- (NSString *)getPath {
    
    
    return @"customer/takingsees";
    
}


- (Class)getRespClass {
    return [TakingSeeEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
