//
//  CustomerFollowEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerFollowEntity.h"

@implementation CustomerFollowEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return [self getBaseFieldWithOthers:@{
                                              @"inqFollows":@"InquiryFollows",
                                              @"recordCount":@"RecordCount"
                                              }];
    }
    return [self getBaseFieldWithOthers:@{
                                          @"inqFollows":@"InqFollows",
                                          @"recordCount":@"RecordCount"
                                          }];
}


+(NSValueTransformer *)inqFollowsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CustomerFollowItemEntity class]];
}


@end
