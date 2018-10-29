//
//  PublishCusDetailPageMsgEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCusDetailPageMsgEntity.h"

@implementation PublishCusDetailPageMsgEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"customerLevel":@"CustomerLevel",
             @"customerName":@"CustomerName",
             @"inquiryTradeType":@"InquiryTradeType",
             @"salePrice":@"SalePrice",
             @"rentPrice":@"RentPrice",
             @"inquiryPayment":@"InquiryPayment",
             @"buyReason":@"BuyReason",
             @"propertyUsage":@"PropertyUsage",
             @"rentExpireDate":@"RentExpireDate",
             @"payCommissionType":@"PayCommissionType",
             @"districts":@"Districts",
             @"areas":@"Areas",
             @"targetEstates":@"TargetEstates",
             @"houseTypes":@"HouseTypes",
             @"houseArea":@"HouseArea",
             @"roomTypes":@"RoomTypes",
             @"houseDirections":@"HouseDirections",
             @"houseFloor":@"HouseFloor",
             @"emergency":@"Emergency",
             @"familySize":@"FamilySize",
             @"transportations":@"Transportations",
             @"inquirySource":@"InquirySource",
             @"decorationSituation":@"DecorationSituation",
             @"propertyType":@"PropertyType",
             @"inquiryStatus":@"InquiryStatus",
             @"showTags":@"ShowTags",
             @"floor":@"Floor",
             };
}

@end
