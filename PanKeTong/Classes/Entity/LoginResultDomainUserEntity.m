//
//  LoginResultDomainUserEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "LoginResultDomainUserEntity.h"

@implementation LoginResultDomainUserEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cityCode":@"CityCode",
             @"staffNo":@"StaffNo",
             @"cnName":@"CnName",
             @"deptName":@"DeptName",
             @"domainAccount":@"DomainAccount",
             @"mobile":@"Mobile",
             @"title":@"Title",
             @"email":@"Email",
             @"agentUrl":@"AgentUrl",
			 @"CompanyName":@"CompanyName",
             @"corporationKeyId" : @"CorporationKeyId",
             @"corporationName" : @"CorporationName",
             };
    
}

@end
