//
//  PropertyCallRecordEntity.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropertyCallRecordEntity.h"
#import "PropertyCallRecordResultEntity.h"

@implementation PropertyCallRecordEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result"
                                          }];
}


+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropertyCallRecordResultEntity class]];
}
@end
