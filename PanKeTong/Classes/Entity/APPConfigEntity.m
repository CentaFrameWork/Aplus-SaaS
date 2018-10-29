//
//  APPConfigEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/4.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APPConfigEntity.h"

#import <MJExtension/MJExtension.h>

@implementation APPLocationEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"relationId":@"RelationId",
             @"companyCode":@"CompanyCode",
             @"showLocation":@"ShowLocation",
             @"configId":@"ConfigId",
             @"dispIndex":@"DispIndex",
             @"iconUrl":@"IconUrl",
             @"jumpType":@"JumpType",
             @"jumpContent":@"JumpContent",
             @"updateTime":@"UpdateTime",
             @"iconFrame":@"IconFrame",
             @"endDate":@"EndDate",
             @"title":@"Title",
             @"mDescription":@"Description"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return [self JSONKeyPathsByPropertyKey];
    
}

@end


@implementation APPConfigEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result"
                                          }];
}

+ (NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[APPLocationEntity class]];
}

@end
