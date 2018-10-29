//
//  ChannelCallEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/26.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelCallEntity.h"

@implementation ChannelCallEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                  @"mresult":@"Result"
                                  }];
}


+(NSValueTransformer *)mresultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ChannelCallModelEntity class]];
}


@end
