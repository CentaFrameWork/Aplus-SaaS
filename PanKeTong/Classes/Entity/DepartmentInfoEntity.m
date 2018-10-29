//
//  DepartmentInfoEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DepartmentInfoEntity.h"
#import "DepartmentInfoResultEntity.h"
@implementation DepartmentInfoEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return @{
                 @"result":@"PermisstionUserInfo",
                 };
    }

    return @{
             @"result":@"PermUserInfos",
            };
    
}

+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DepartmentInfoResultEntity class]];
}

@end
