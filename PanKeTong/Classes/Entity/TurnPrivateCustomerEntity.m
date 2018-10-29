//
//  TurnPrivateCustomerEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/2.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "TurnPrivateCustomerEntity.h"

@implementation TurnPrivateCustomerEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"keyId":@"KeyId"
                                          }];
}

@end
