//
//  StaffInfoResultEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "StaffInfoResultEntity.h"

@implementation StaffInfoResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{@"cityCode":@"CityCode",
             @"staffNo":@"StaffNo",
             @"cnName":@"CnName",
             @"deptName":@"DeptName",
             @"domainAccount":@"DomainAccount",
             @"mobile":@"Mobile",
             @"title":@"Title",
             @"email":@"Email",
             @"agentUrl":@"AgentUrl",
             @"position":@"Position",};
}


@end
