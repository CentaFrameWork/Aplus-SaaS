//
//  DascomGetPhoneEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomGetPhoneEntity.h"

@implementation DascomGetPhoneEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mHeader":@"header",
             @"mBody":@"body"};
}

+(NSValueTransformer *)mBodyJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DascomGetPhoneBodyEntity class]];
}

+(NSValueTransformer *)mHeaderJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[DascomGetPhoneHeaderEntity class]];
}

@end
