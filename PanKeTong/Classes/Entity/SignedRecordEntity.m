//
//  SignedRecordEntity.m
//  PanKeTong
//
//  Created by zhwang on 16/4/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SignedRecordEntity.h"

@implementation SignedRecordEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"checkIns":@"CheckIns",
             };
}

+(NSValueTransformer *)checkInsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SigendRecordListEntity class]];
}

@end
