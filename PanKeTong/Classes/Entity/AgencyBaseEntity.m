//
//  AgencyBaseEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@implementation AgencyBaseEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *dic = [self getBaseFieldWithOthers:nil];
    return dic;
}

+ (NSMutableDictionary *)getBaseFieldMapping
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:@{
             @"flag":@"Flag",
             @"errorMsg":@"ErrorMsg",
             @"runTime":@"RunTime",
             }];
    return mdic;
}

+ (NSMutableDictionary *)getBaseFieldWithOthers:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [self getBaseFieldMapping];
    [mdic addEntriesFromDictionary:dic];
    return mdic;
}

@end
