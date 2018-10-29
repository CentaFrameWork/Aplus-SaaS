//
//  SendMessageEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/12/7.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SendMessageEntity.h"

@implementation SendMessageEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"returnMessage":@"ReturnMessage"
                                          }];
}

@end
