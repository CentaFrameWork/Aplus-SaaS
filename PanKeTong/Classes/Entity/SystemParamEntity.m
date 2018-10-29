//
//  SystemParamEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SystemParamEntity.h"

@implementation SystemParamEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *sysParamNewUpdTime = @"SysParamNewUpdTime";
    NSString *sysParam = @"SysParam";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        sysParamNewUpdTime = @"SysParamNewUpdateTime";
        sysParam = @"SystemParam";
    }
    
    return @{
             @"sysParamNewUpdTime":sysParamNewUpdTime,
             @"needUpdate":@"NeedUpdate",
             @"sysParamList":sysParam
             };
}

+ (NSValueTransformer *)sysParamListJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SysParamItemEntity class]];
}

@end