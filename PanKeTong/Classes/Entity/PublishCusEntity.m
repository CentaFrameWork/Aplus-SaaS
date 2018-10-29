//
//  PublishCusEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCusEntity.h"

@implementation PublishCusEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"publicCustomers":@"PublicCustomers",
             };
}

+(NSValueTransformer *)publicCustomersJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PublishCusDetailEntity class]];
}


@end
