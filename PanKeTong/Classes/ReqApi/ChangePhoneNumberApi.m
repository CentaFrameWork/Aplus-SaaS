//
//  ChangePhoneNumberApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ChangePhoneNumberApi.h"

@implementation ChangePhoneNumberApi

- (NSDictionary *)getBody
{
    return @{
             @"EmployeeKeyId":_employeeKeyId,
             @"Mobile":_mobile
             };
}

/// 修改报备手机号
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @"permission/modify-employee";
    }
    return @"WebApiPermisstion/Organization-ModifyEmployee";

}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
