//
//  ChannelDetailEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/28.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelDetailEntity.h"

@implementation ChannelDetailEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return [self getBaseFieldWithOthers:@{
                                              @"result":@"ChannelInquiryDetails"
                                              }];
    }
    
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result"
                                          }];
}

//result

+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ChannelDetailModel class]];
}


@end
