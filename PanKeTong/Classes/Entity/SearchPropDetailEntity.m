//
//  SearchPropDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SearchPropDetailEntity.h"

@implementation SearchPropDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"itemValue":@"ItemValue",
             @"itemText":@"ItemText",
             @"extendAttr":@"ExtendAttr",
             @"time":@"Time",
             @"houseNo":@"HouseNo",
             @"districtName":@"DistrictName",
             @"areaName":@"AreaName",
             };
}


@end
