//
//  PropKeyListEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropKeyListEntity.h"

@implementation PropKeyListEntity


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return [self getBaseFieldWithOthers:@{
                                              @"keyList":@"PropertyKeys"
                                              }];
    }

    return [self getBaseFieldWithOthers:@{
                                          @"keyList":@"PropKeys"
                                          }];
}

+(NSValueTransformer *)keyListJSONTransformer
{

    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropKeysEntity class]];
}



@end
