//
//  FindRegisterTrustEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/3/2.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FindRegisterTrustEntity.h"

@implementation FindRegisterTrustEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"keyId":@"KeyId",
                                          @"status":@"Status"
                                          }];
}

@end
