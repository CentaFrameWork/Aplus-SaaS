    //
//  ShareInformationApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ShareInformationApi.h"

@implementation ShareInformationApi

- (NSDictionary *)getBody
{
    return @{
             @"ArticleId":_articleId,
             @"EmployeeKeyId":_employeeKeyId,
             @"EmployeeNo":_employeeNo,
             @"EmployeeName":_employeeName,
             @"EmployeeDeptKeyId":_employeeDeptKeyId,
             @"EmployeeDeptName":_employeeDeptName
             };
}

- (NSString *)getPath
{
    return @"common/add-shere-information";
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
