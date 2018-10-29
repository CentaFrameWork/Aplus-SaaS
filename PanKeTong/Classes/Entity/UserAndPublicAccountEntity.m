//
//  UserAndPublicAccountEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/1.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "UserAndPublicAccountEntity.h"

@implementation UserAndPublicAccountEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"userDepartmentDatas":@"UserDepartmentDatas"
                                          }];
}

//result
+(NSValueTransformer *)userDepartmentDatasJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RemindPersonDetailEntity class]];
}

@end
