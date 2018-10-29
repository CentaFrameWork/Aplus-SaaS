//
//  PropPageDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropPageDetailEntity.h"

@implementation PropPageDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"allHouseInfo":@"AllHouseInfo",
             @"salePrice":@"SalePrice",
             @"saleUnitPrice":@"SaleUnitPrice",
             @"rentPrice":@"RentPrice",
             @"roomType":@"RoomType",
             @"houseDirection":@"HouseDirection",
             @"floor":@"Floor",
             @"propertySituation":@"PropertySituation",
             @"propertyCardClassName":@"PropertyCardClassName",
             @"propertyTags":@"PropertyTags",
             @"remainingBrowseCount":@"RemainingBrowseCount",
             @"longitude":@"Longitude",
             @"latitude":@"Latitude",
             @"districtName":@"DistrictName",
             @"areaName":@"AreaName",
             @"square":@"Square",
             @"squareUse":@"SquareUse",
             @"squareEdit":@"SquareEdit",
             @"isFavorite":@"IsFavorite",
             @"propertyChiefKeyId":@"PropertyChiefKeyId",
             @"propertyChiefDepartmentKeyId":@"PropertyChiefDepartmentKeyId",
             @"propertyTraderKeyId":@"PropertyTraderKeyId",
             @"propertyTraderDepartmentKeyId":@"PropertyTraderDepartmentKeyId",
             @"propertyStatusCategory":@"PropertyStatusCategory",
             @"cCAIReturnTrustType":@"CCAIReturnTrustType",
             @"takeSeeCount":@"TakeSeeCount",
             @"photoPath":@"PhotoPath",
             @"trustType":@"TrustType",
             @"trustAuditState":@"TrustAuditState",
             @"departmentPermissions":@"DepartmentPermissions",
             @"salePriceReferent":@"SalePriceReferent",
             @"oldSalePriceReferent":@"OldSalePriceReferent",
             @"squareReferent":@"SquareReferent",
             @"saleUnitPriceReferent":@"SaleUnitPriceReferent",
             @"rentPriceReferent":@"RentPriceReferent",
             @"squareUseReferent":@"SquareUseReferent",
             @"squareGardenReferent":@"SquareGardenReferent",
             @"isMacau":@"IsMacau",
             @"propertyUsage":@"PropertyUsage",
             @"decorationSituation":@"DecorationSituation",
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"propertyNo":@"PropertyNo",
             @"propertyStatus":@"PropertyStatus",
             @"latelyTakeSeeDay7Count":@"LatelyTakeSeeDay7Count",
             @"latelyTakeSeeTime":@"LatelyTakeSeeTime",
             @"realSurveyCount":@"RealSurveyCount",
             @"houseType":@"HouseType",
             @"hasRegisterTrusts":@"HasRegisterTrusts",
             @"entrustKeepOnRecord":@"EntrustKeepOnRecord",
             @"noCallMessage":@"NoCallMessage"
             };
}

@end
