//
//  VirtualConfigEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "VirtualConfigEntity.h"

@implementation VirtualConfigEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"virtualCall":@"VirtualCall",
             @"callLimit":@"CallLimit"};
}


@end
