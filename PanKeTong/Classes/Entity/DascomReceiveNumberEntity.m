//
//  DascomReceiveNumberEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomReceiveNumberEntity.h"

@implementation DascomReceiveNumberEntity

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

+(NSValueTransformer *)mBodyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ReceiveBodyEntity class]];
}



@end
