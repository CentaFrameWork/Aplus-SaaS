//
//  PropOnlyTrustEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropOnlyTrustEntity.h"

@implementation PropOnlyTrustEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"onlyTrustPerson":@"OnlyTrustPerson",
             @"onlyTrustType":@"OnlyTrustType",
             @"effectiveDate":@"EffectiveDate"
             };
}


@end
