//
//  PermisstionsEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PermisstionsEntity.h"

@implementation PermisstionsEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"menuPermisstion":@"MenuPermisstion",
             @"rights":@"Rights",
             @"operatorValPermisstion":@"OperatorValPermisstion",
             @"departmentKeyIds":@"DepartmentKeyIds",
             @"rightUpdateTime":@"RightUpdateTime",
             };
    
}

+(NSValueTransformer *)operatorValPermisstionJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[OperatorValPermisstionEntity class]];
}

@end
