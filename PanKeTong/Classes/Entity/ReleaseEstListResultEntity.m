//
//  ReleaseEstListResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ReleaseEstListResultEntity.h"

@implementation ReleaseEstListResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *advertKeyId = @"AdvertKeyid";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        advertKeyId = @"AdvertKeyId";
    }
    
    return @{
            @"postId":@"PostId",
            @"advertKeyid":advertKeyId,
            @"displayEstName":@"DisplayEstName",
            @"displayAddress":@"DisplayAddress",
            @"nArea":@"NArea",
            @"roomCnt":@"RoomCnt",
            @"sellPrice":@"SellPrice",
            @"rentalPrice":@"RentalPrice",
            @"defaultImage":@"DefaultImage",
            @"expiredTime":@"ExpiredTime",
            @"updateTime":@"UpdateTime",
            @"hallCnt":@"HallCnt",
            @"toiletCnt":@"ToiletCnt",
            @"opDate":@"OpDate",
            @"propertyType":@"PropertyType",
            @"floor":@"Floor",
            @"floorTotal":@"FloorTotal",
            @"direction":@"Direction",
            @"fitment":@"Fitment",
            @"unitSellPrice":@"UnitSellPrice",
            @"title":@"Title",
            @"staffNo":@"StaffNo",
            @"isOnline":@"IsOnline",
            @"createTime":@"CreateTime",
            @"regionId":@"RegionId",
            @"districtId":@"DistrictId",
            @"propertyTypeId":@"PropertyTypeId",
            @"floorDisplay":@"FloorDisplay",
            @"gArea":@"GArea",
            @"propertyStatus":@"PropertyStatus",
            @"balconyCnt":@"BalconyCnt",
            @"kitchenCnt":@"KitchenCnt",
            @"postType":@"PostType",
            @"withLease":@"WithLease",
            @"keywords":@"Keywords",
            @"remarkNo":@"RemarkNo",
            @"isFollow":@"IsFollow",
            @"isSole":@"IsSole",
            @"postTag":@"PostTag",
            @"staffName":@"StaffName",
            @"staffMobile":@"StaffMobile",
            @"postStatus":@"PostStatus",
            @"rotatedIn":@"RotatedIn",
            @"postScore":@"PostScore",
            @"agentScore":@"AgentScore",
            @"flag":@"Flag",
            @"errorMsg":@"ErrorMsg",
            @"runTime":@"RunTime",
            @"tradeType":@"TradeType",
            @"trustType":@"TrustType",
             };
}

@end
