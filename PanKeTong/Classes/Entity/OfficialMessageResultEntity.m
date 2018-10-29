//
//  OfficialMessageResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "OfficialMessageResultEntity.h"

@implementation OfficialMessageResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
            @"infoId":@"InfoId",
            @"title":@"Title",
            @"infoContent":@"InfoContent",
            @"createTime":@"CreateTime",
            @"updateTime":@"UpdateTime",
            @"companyCode":@"CompanyCode",
            @"staffNo":@"StaffNo",
            @"pushPlatform":@"PushPlatform",
            @"pushClientVer":@"PushClientVer",

             };
}

+ (NSArray *)chh_cache_ignoredPropertyNames{
    
    return [BaseEntity propertyNameArray];
    
}

@end
