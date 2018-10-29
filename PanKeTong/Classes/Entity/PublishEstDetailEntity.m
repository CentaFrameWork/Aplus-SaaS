//
//  PublishEstDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishEstDetailEntity.h"

@implementation PublishEstDetailEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"trustType":@"TrustType",
             @"trustTypeName":@"TrustTypeName",
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"floor":@"Floor",
             @"keyId":@"KeyId",
             };
}

@end
