//
//  SubRegisterTrustsEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/26.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubRegisterTrustsEntity.h"

@implementation SubRegisterTrustsEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
              @"keyId":@"KeyId",
              @"propertyChiefDeptKeyId":@"PropertyChiefDeptKeyId",
              @"personDeptKeyId":@"PersonDeptKeyId",
              @"personDeptDepName":@"PersonDeptDepName",
              @"creatorKeyId":@"CreatorKeyId",
              @"creatorDeptKeyId":@"CreatorDeptKeyId",
              @"creatorPersonName":@"CreatorPersonName",
              @"createTime":@"CreateTime",
              @"signDate":@"SignDate",
              @"photoCount":@"PhotoCount",
              @"propertyStatusKeyId":@"PropertyStatusKeyId",
              @"regTrustsAuditStatus":@"RegTrustsAuditStatus",
              @"buildingName":@"BuildingName",
              @"estateName":@"EstateName",
              @"houseName":@"HouseName",
              @"buildingKeyId":@"BuildingKeyId",
              @"estateKeyId":@"EstateKeyId",
              @"houseKeyId":@"EstateKeyId",
              @"propertyKeyId":@"PropertyKeyId",
              @"houseType":@"HouseType",
              @"houseDirection":@"HouseDirection",
              @"trustAuditPersonKeyId":@"TrustAuditPersonKeyId",
              @"trustAuditPersonName":@"TrustAuditPersonName",
              @"trustAuditDate":@"TrustAuditDate",
              @"propertyTrustType":@"PropertyTrustType"
             };
    
}


@end
