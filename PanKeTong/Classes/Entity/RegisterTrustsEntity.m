//
//  RegisterTrustsEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/25.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "RegisterTrustsEntity.h"

@implementation RegisterTrustsEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"propertyRegisterTrusts":@"PropertyRegisterTrusts"
                                          }];
}

+(NSValueTransformer *)propertyRegisterTrustsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubRegisterTrustsEntity class]];
}


@end
