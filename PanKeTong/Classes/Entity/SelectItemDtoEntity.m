//
//  SelectItemDtoEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SelectItemDtoEntity.h"

@implementation SelectItemDtoEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"itemValue":@"ItemValue",
             @"itemText":@"ItemText",
             @"itemCode":@"ItemCode",
             @"itemStatus":@"ItemStatus",
             @"extendAttr":@"ExtendAttr",
             @"flagDefault":@"FlagDefault",
             @"seq":@"Seq",
             };
}

@end
