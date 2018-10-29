//
//  CheckVersonEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CheckVersonEntity.h"

@implementation CheckVersonEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  [self getBaseFieldWithOthers:@{@"result":@"Result"}];
    
}

+(NSValueTransformer *)resultJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CheckVersonResultEntity class]];
}

@end
