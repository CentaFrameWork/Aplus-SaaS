//
//  PropAllPhotoEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropAllPhotoEntity.h"

@implementation PropAllPhotoEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"photos":@"Photos",
             };
}

+(NSValueTransformer *)photosJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropAllPhotoDetailEntity class]];
}

@end
