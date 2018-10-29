//
//  PropertysModelEntty.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropertysModelEntty.h"

@implementation PropertysModelEntty

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"completeYear":@"CompleteYear",
             @"trustType":@"TrustType",
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"floor":@"Floor",
             @"houseType":@"HouseType",
             @"roomType":@"RoomType",
             @"propertyType":@"PropertyType",
             @"square":@"Square",
             @"houseDirection":@"HouseDirection",
             @"salePrice":@"SalePrice",
             @"realSurveyCount":@"RealSurveyCount",
             @"propertyStatus":@"PropertyStatus",
             @"propertyStatusCategory":@"PropertyStatusCategory",
             @"salePriceUnit":@"SalePriceUnit",
             @"rentPrice":@"RentPrice",
             @"favoriteFlag":@"FavoriteFlag",
             @"isOnlyTrust":@"IsOnlyTrust",
             @"propertyKeyEnum":@"PropertyKeyEnum",
             @"photoPath":@"PhotoPath",
             @"propertyTags":@"PropertyTags",
             @"takeToSeeCount":@"TakeToSeeCount",
             @"keyId":@"KeyId",
             @"isPropertyKey":@"IsPropertyKey",
             @"isRegisterTrusts":@"IsRegisterTrusts",
             @"entrustKeyId":@"EntrustKeyId",
             @"onlyTrustKeyId":@"OnlyTrustKeyId",
             @"departmentPermissions":@"DepartmentPermissions",
             @"isMacau":@"IsMacau",
             @"hasRegisterTrusts":@"HasRegisterTrusts",
             @"isVideoPhotoAddress":@"IsVideoPhotoAddress",
             };
    
}

+(NSValueTransformer *)propertyTagsJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PropertyTagEntity class]];
}

+ (NSArray *)chh_cache_allowedPropertyNames{
    
    return @[@"keyId", @"completeYear"];
    
}

+ (NSArray *)chh_cache_ignoredPropertyNames{
    
    return @[@"completeYear"];
    
}



@end
