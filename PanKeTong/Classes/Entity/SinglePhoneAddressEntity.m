//
//  SinglePhoneAddressEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/15.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "SinglePhoneAddressEntity.h"

@implementation SinglePhoneAddressEntity

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
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PhoneAddressInfo class]];
}

@end
