
//
//  PropertyTagEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropertyTagEntity.h"

@implementation PropertyTagEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"tagName":@"TagName",
             @"tagNo":@"TagNo",
             @"highLight":@"Highlight",
             @"styleColor":@"StyleColor",
             @"extendAttr":@"ExtendAttr",
             @"seq":@"Seq",
             };
}

@end
