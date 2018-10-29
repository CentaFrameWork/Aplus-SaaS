//
//  LoginEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "LoginEntity.h"

@implementation LoginEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"result":@"Result",
             };
    
}

+(NSValueTransformer *)resultJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[LoginResultEntity class]];
}

@end
