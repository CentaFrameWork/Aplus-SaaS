//
//  BaseEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"rCode":@"RCode",
             @"rMessage":@"RMessage",
             @"total":@"Total",
             };
    
}
+ (NSMutableDictionary *)getBaseFieldMapping
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                 @"rCode":@"RCode",
                                                                                 @"rMessage":@"RMessage",
                                                                                 @"total":@"Total",
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
