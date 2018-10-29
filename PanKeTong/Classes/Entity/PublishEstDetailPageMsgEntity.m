//
//  PublishEstDetailPageMsgEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishEstDetailPageMsgEntity.h"

@implementation PublishEstDetailPageMsgEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"salePrice":@"SalePrice",
             @"saleUnitPrice":@"SaleUnitPrice",
             @"rentPrice":@"RentPrice",
             @"square":@"Square",
             @"squareUse":@"SquareUse",
             @"houseType":@"HouseType",
             @"roomType":@"RoomType",
             @"floor":@"Floor",
             @"houseDirection":@"HouseDirection",
             @"propertyRightNature":@"PropertyRightNature",
             @"propertySourceName":@"PropertySourceName",
             @"propertySituation":@"PropertySituation",
             @"longitude":@"Longitude",
             @"latitude":@"Latitude",
             @"districtName":@"DistrictName",
             @"areaName":@"AreaName",
             @"trustTypeName":@"TrustTypeName",
             @"propertyCardDate":@"PropertyCardDate",
             @"propertyStatus":@"PropertyStatus",
             };
}

@end
