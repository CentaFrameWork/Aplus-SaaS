//
//  StaffInfoEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "StaffInfoEntity.h"

@implementation StaffInfoEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return [self getBaseFieldWithOthers:@{@"result":@"Result"}];
}

+(NSValueTransformer *)resultJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[StaffInfoResultEntity class]];
}

@end
