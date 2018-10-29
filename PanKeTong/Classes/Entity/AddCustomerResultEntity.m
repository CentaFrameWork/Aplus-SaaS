//
//  AddCustomerResultEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AddCustomerResultEntity.h"

@implementation AddCustomerResultEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                  @"keyId":@"KeyId"
                                  }];
}

@end
