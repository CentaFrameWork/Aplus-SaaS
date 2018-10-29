//
//  CustomerListEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerListEntity.h"

@implementation CustomerListEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
         @"inquirys":@"Inquirys",
         @"recordCount":@"RecordCount"
         };
}

+ (NSValueTransformer *)inquirysJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CustomerEntity class]];
}

@end
