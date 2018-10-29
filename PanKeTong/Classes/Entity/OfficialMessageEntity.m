//
//  OfficialMessageEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "OfficialMessageEntity.h"

@implementation OfficialMessageEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result",
             }];
}

+ (NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[OfficialMessageResultEntity class]];
}

@end
