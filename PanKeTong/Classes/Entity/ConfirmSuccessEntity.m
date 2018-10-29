//
//  ConfirmSuccessEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ConfirmSuccessEntity.h"

@implementation ConfirmSuccessEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"result":@"Result",
                                          }];
}


@end
