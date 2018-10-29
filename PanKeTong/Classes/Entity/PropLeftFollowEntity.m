//
//  PropLeftFollowEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropLeftFollowEntity.h"

@implementation PropLeftFollowEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return [self getBaseFieldWithOthers:@{
                                              @"propFollows":@"PropertyFollows"
                                              }];
    }
    return [self getBaseFieldWithOthers:@{
                                          @"propFollows":@"PropFollows"
                                          }];
}


+(NSValueTransformer *)propFollowsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropLeftFollowItemEntity class]];
}

@end
