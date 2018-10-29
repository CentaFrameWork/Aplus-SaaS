//
//  FollowRecordEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "FollowRecordEntity.h"

@implementation FollowRecordEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @{
                 @"propFollows":@"PropertyFollows",
                 };
    }
    
    return @{
             @"propFollows":@"PropFollows",
             };
}

+ (NSValueTransformer *)propFollowsJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropFollowRecordDetailEntity class]];
}

@end
