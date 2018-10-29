//
//  PropPermisstionsModelEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropPermisstionsModelEntity.h"

@implementation PropPermisstionsModelEntity

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

@end
