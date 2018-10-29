//
//  CityConfigEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/11.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CityConfigEntity.h"

@implementation CityConfigEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result"
                                          }];
}

+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AppConfigResponseEntity class]];
}

@end
