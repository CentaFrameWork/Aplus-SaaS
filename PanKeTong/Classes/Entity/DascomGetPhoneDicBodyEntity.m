//
//  DascomGetPhoneDicBodyEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/6.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomGetPhoneDicBodyEntity.h"

@implementation DascomGetPhoneDicBodyEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mHeader":@"header",
             @"mBody":@"body"};
}

+(NSValueTransformer *)mHeaderJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DascomGetPhoneHeaderEntity class]];
}

@end
