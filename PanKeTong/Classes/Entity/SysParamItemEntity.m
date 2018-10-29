//
//  SysParamItemEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SysParamItemEntity.h"

@implementation SysParamItemEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"parameterName":@"ParameterName",
             @"parameterType":@"ParameterType",
             @"parameterStatus":@"ParameterStatus",
             @"itemList":@"Items",
             };
}

+(NSValueTransformer *)itemListJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}



@end
