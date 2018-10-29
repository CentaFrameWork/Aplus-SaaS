//
//  PropertyCallRecordApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropertyCallRecordApi.h"
#import "PropertyCallRecordEntity.h"

@implementation PropertyCallRecordApi

- (NSDictionary *)getBody
{
    _startTime = _startTime ? _startTime : @"";
    _endTime = _endTime ? _endTime : @"";
    _userKeyId = _userKeyId ? _userKeyId :@"";
    _deptKeyId = _deptKeyId ? _deptKeyId :@"";
    
    return @{
             @"StartTime":_startTime,
             @"EndTime":_endTime,
             @"UserKeyId":_userKeyId,
             @"DeptKeyId":_deptKeyId,
             @"PropertyKeyId":_propertyKeyId,
             @"Scope":_scope,
             @"PageIndex":_pageIndex,
             @"PageSize":@"10",
             @"SortField":@"",
             @"Ascending":@"false",
             };
}



- (NSString *)getPath
{
    return @"WebApiProperty/property-call-record";
}


- (Class)getRespClass
{
    return [PropertyCallRecordEntity class];
}

@end
