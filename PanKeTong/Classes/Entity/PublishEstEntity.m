//
//  PublishEstEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishEstEntity.h"

@implementation PublishEstEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"publishEstates":@"PublicEstates",
             };
}

+(NSValueTransformer *)publishEstatesJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PublishEstDetailEntity class]];
}



@end
