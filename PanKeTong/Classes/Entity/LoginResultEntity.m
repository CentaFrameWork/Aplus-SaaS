//
//  LoginResultEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "LoginResultEntity.h"

@implementation LoginResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"seccion":@"Session",
             @"loginDomainUser":@"DomainUser",
             };
    
}

+(NSValueTransformer *)loginDomainUserJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[LoginResultDomainUserEntity class]];
}

@end
