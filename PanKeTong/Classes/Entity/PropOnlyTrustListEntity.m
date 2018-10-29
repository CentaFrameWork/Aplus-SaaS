//
//  PropOnlyTrustListEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropOnlyTrustListEntity.h"

@implementation PropOnlyTrustListEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return [self getBaseFieldWithOthers:@{
                                              @"propOnlyTrusts":@"PropertyOnlyTrusts"
                                              }];

    }
    return [self getBaseFieldWithOthers:@{
                                          @"propOnlyTrusts":@"PropOnlyTrusts"
                                          }];
}



+(NSValueTransformer *)propOnlyTrustsJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropOnlyTrustEntity class]];
}

@end
