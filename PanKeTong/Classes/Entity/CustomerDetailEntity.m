//
//  CustomerDetailEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerDetailEntity.h"


@implementation CustomerDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
             @"contacts":@"Contacts",
             @"takeSeeCount":@"TakeSeeCount",
             @"inquiryTradeType":@"InquiryTradeType",
             @"houseType":@"HouseType",
             @"area":@"Area",
             @"houseDirection":@"HouseDirection",
             @"roomType":@"RoomType",
             @"houseFloor":@"HouseFloor",
             @"inquiryPaymentType":@"InquiryPaymentType",
             @"targetEstates":@"TargetEstates",
             @"emergency":@"Emergency",
             @"familySize":@"FamilySize",
             @"transportations":@"Transportations",
             @"payCommissionType":@"PayCommissionType",
             @"propertyType":@"PropertyType",
             @"rentExpireDate":@"RentExpireDate",
             @"decorationSituation":@"DecorationSituation",
             @"inquirySource":@"InquirySource",
             @"salePrice":@"SalePrice",
             @"rentPrice":@"RentPrice",
             @"buyReason":@"BuyReason",
             @"propertyUsage":@"PropertyUsage",
             @"chiefDeptKeyId":@"ChiefDeptKeyId",
             @"chiefKeyId":@"ChiefKeyId"
             }];
}

+(NSValueTransformer *)contactsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CustomerContacts class]];
}

@end
