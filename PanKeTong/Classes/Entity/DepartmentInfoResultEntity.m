//
//  DepartmentInfoResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DepartmentInfoResultEntity.h"

@implementation DepartmentInfoResultEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identify":@"Identify",
             @"permisstions":@"Permisstions",
             @"accountInfo":@"AccountInfo",
             };
    
}
+(NSValueTransformer *)identifyJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[IdentifyEntity class]];
}
+(NSValueTransformer *)permisstionsJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[PermisstionsEntity class]];
}
@end
