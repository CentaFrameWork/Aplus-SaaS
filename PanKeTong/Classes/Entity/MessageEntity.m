//
//  MessageEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MessageEntity.h"

@implementation MessageEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"result":@"Informations",
             @"recordCount":@"RecordCount",
             };
}
+(NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MessageResultEntity class]];
}

@end
