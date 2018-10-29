//
//  SubTakingSeeEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubTakingSeeEntity.h"

#import "NSObject+Extension.h"

@implementation SubTakingSeeEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"reserveTime":@"ReserveTime",
             @"takeSeeTime":@"TakeSeeTime",
             @"reserveKeyId":@"ReserveKeyId",
             @"takeSeeKeyId":@"TakeSeeKeyId",
             @"customerNo":@"CustomerNo",
             @"customerName":@"CustomerName",
             @"mobile":@"Mobile",
             @"inquiryKeyId":@"InquiryKeyId",
             @"customerKeyId":@"CustomerKeyId",
             @"inquiryTradeTypeKeyId":@"InquiryTradeTypeKeyId",
             @"propertyKeyId":@"PropertyKeyId",
             @"estateKeyId":@"EstateKeyId",
             @"buildingKeyId":@"BuildingKeyId",
             @"houseKeyId":@"HouseKeyId",
             @"seePropertyType":@"SeePropertyType",
             @"estateName":@"EstateName",
             @"buildingName":@"BuildingName",
             @"houseNo":@"HouseNo",
             @"propertyInfo":@"PropertyInfo",
             @"floor":@"Floor",
             @"floorAll":@"FloorAll",
             @"countF":@"CountF",
             @"countT":@"CountT",
             @"countW":@"CountW",
             @"countY":@"CountY",
             @"square":@"Square",
             @"salePrice":@"SalePrice",
             @"rentPrice":@"RentPrice",
             @"content":@"Content",
             @"contentNext":@"ContentNext",
             @"propertyNo":@"PropertyNo",
             @"createUserKeyId":@"CreateUserKeyId",
             @"takingUserName":@"UserName",
             @"departmentKeyId":@"DepartmentKeyId",
             @"departmentName":@"DepartmentName",
             @"agreementNo":@"AgreementNo",
             @"trustType":@"TrustType",
             @"lookWithUserKeyId":@"LookWithUserKeyId",
             @"lookWithUserName":@"LookWithUserName",
             @"attachmentName":@"AttachmentName",
             @"attachmentPath":@"AttachmentPath",
             @"propertyList" : @"PropertyList",
             };

}

- (id)copyWithZone:(NSZone *)zone{
    
    return [self objectForCopy];
    
}


@end
