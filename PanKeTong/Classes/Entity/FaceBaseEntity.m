//
//  FaceBaseEntity.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceBaseEntity.h"

@implementation FaceBaseEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"rCode":@"ResultNo",
             @"rMessage":@"Message",
             @"total":@"Total"
             };
}

+ (NSMutableDictionary *)getBaseFieldMapping
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                 @"rCode":@"ResultNo",
                                                                                 @"rMessage":@"Message",
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
