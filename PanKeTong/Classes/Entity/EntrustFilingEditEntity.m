//
//  EntrustFilingEditEntity.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/28.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EntrustFilingEditEntity.h"

@implementation EntrustFilingEditEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"value":@"Value",
             };
    
}

+(NSValueTransformer *)valueJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[EntrustFilingEditDetailEntity class]];
}

@end



