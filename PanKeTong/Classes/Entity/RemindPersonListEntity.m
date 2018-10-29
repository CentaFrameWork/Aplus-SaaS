//
//  RemindPersonListEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RemindPersonListEntity.h"

@implementation RemindPersonListEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userDepartments":@"UserDepartmentDatas"
             };
}

+(NSValueTransformer *)userDepartmentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RemindPersonDetailEntity class]];
}

@end
