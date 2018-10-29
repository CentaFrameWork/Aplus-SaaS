//
//  CustomerEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerEntity.h"

@implementation CustomerEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"customerKeyId":@"CustomerKeyId",
             @"customerName":@"CustomerName",
             @"inquiryStatusKeyId":@"InquiryStatusKeyId",
             @"inquiryTradeType":@"InquiryTradeType",
             @"houseType":@"HouseType",
             @"houseDirection":@"HouseDirection",
             @"area":@"Area",
             @"salePrice":@"SalePrice",
             @"rentPrice":@"RentPrice",
             @"houseFloor":@"HouseFloor",
             @"decorationSituation":@"DecorationSituation",
             @"isVip":@"IsVip",
             @"districts":@"Districts",
             @"areas":@"Areas",
             @"male":@"Male",
             @"roomType":@"RoomType",
             @"regDate":@"RegDate",
             @"remark":@"Remark"
             };
}

@end
