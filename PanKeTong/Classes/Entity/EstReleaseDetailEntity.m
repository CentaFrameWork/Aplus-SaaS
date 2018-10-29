//
//  EstReleaseDetailEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstReleaseDetailEntity.h"
#import "PhotoEntity.h"

@implementation EstReleaseDetailEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSString *advertKeyId = @"AdvertKeyid";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        advertKeyId = @"AdvertKeyId";
    }
    
    return @{
           @"rentType":@"RentType",
           @"propertyRight":@"PropertyRight",
           @"payType":@"PayType",
           @"tenantType":@"TenantType",
           @"infoDescription":@"Description",
           @"opDate":@"OpDate",
           @"displayEstName":@"DisplayEstName",
           @"displayAddress":@"DisplayAddress",
           @"propertyTypeId":@"PropertyTypeId",
           @"floor":@"Floor",
           @"floorTotal":@"FloorTotal",
           @"nArea":@"NArea",
           @"roomCnt":@"RoomCnt",
           @"hallCnt":@"HallCnt",
           @"toiletCnt":@"ToiletCnt",
           @"direction":@"Direction",
           @"fitment":@"Fitment",
           @"sellPrice":@"SellPrice",
           @"rentalPrice":@"RentalPrice",
           @"title":@"Title",
           @"isOnline":@"IsOnline",
           @"tradeType":@"TradeType",
           @"postId":@"PostId",
           @"advertKeyid":advertKeyId,
           @"defaultImage":@"DefaultImage",
           @"expiredTime":@"ExpiredTime",
           @"propertyType":@"PropertyType",
           @"unitSellPrice":@"UnitSellPrice",
           @"staffNo":@"StaffNo",
           @"regionId":@"RegionId",
           @"districtId":@"DistrictId",
           @"floorDisplay":@"FloorDisplay",
           @"gArea":@"GArea",
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
           @"statusMessage":@"StatusMessage",
           @"regionName":@"RegionName",
           @"districtName":@"DistrictName",
           @"rentTyep":@"RentTyep",
           @"serviceInfo":@"ServiceInfo",
           @"applianceInfo":@"ApplianceInfo",
           @"mgtPrice":@"MgtPrice",
           @"mgtInclude":@"MgtInclude",
           @"withLeaseRental":@"WithLeaseRental",
           @"withLeaseExpired":@"WithLeaseExpired",
           @"visitTime":@"VisitTime",
           @"defaultImageExt":@"DefaultImageExt",
           @"soleExpired":@"SoleExpired",
           @"staffEmail":@"StaffEmail",
           @"cestKeywords":@"CestKeywords",
           @"plainDescription":@"PlainDescription",
           @"adsNo":@"AdsNo",
           @"untCode":@"UntCode",
           @"blgCode":@"BlgCode",
           @"estCode":@"EstCode",
           @"bigEstCode":@"BigEstCode",
           @"rotatedIn":@"RotatedIn",
           @"postScore":@"PostScore",
           @"agentScore":@"AgentScore",
           @"createTime":@"CreateTime",
           @"updateTime":@"UpdateTime",
           @"flag":@"Flag",
           @"errorMsg":@"ErrorMsg",
           @"runTime":@"RunTime",
           @"photos":@"Photos",
        };
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PhotoEntity class]];
}

@end
