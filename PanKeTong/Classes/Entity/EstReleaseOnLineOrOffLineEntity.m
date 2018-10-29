//
//  EstReleaseOnLineOrOffLineEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/11/10.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstReleaseOnLineOrOffLineEntity.h"

@implementation EstReleaseOnLineOrOffLineEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"operateResult":@"OperateResult",
             };
}
+(NSValueTransformer *)operateResultJSONTransformer
{

    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[OperateResultEntity class]];
}
@end
