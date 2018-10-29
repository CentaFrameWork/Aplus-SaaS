//
//  PhoneAddressEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "PhoneAddressEntity.h"

@implementation PhoneAddressEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"data":@"data",
             @"msg":@"msg",
             @"error":@"error"
             };
}

+(NSValueTransformer *)dataJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PhoneAddressInfo class]];
}

@end
