//
//  RealSurveyAuditingListEntity.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingListEntity.h"

@implementation RealSurveyAuditingListEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"keyId":@"KeyId",
                                          @"propertyChiefDeptKeyId":@"PropertyChiefDeptKeyId",
                                          @"personDeptKeyId":@"PersonDeptKeyId",
                                          @"personDeptDepName":@"PersonDeptDepName",
                                          @"realSurveyPersonKeyId":@"RealSurveyPersonKeyId",
                                          @"realSurveyPersonName":@"RealSurveyPersonName",
                                          @"realSurveyPersonDeptKeyId":@"RealSurveyPersonDeptKeyId",
                                          @"createTime":@"CreateTime",
                                          @"realSurveyDate":@"RealSurveyDate",
                                          @"photoCount":@"PhotoCount",
                                          @"propertyStatusKeyId":@"PropertyStatusKeyId",
                                          @"auditStatus":@"AuditStatus",
                                          @"auditPersonKeyId":@"AuditPersonKeyId",
                                          @"auditPersonName":@"AuditPersonName",
                                          @"auditTime":@"AuditTime",
                                          @"buildinName":@"BuildinName",
                                          @"estateName":@"EstateName",
                                          @"houseName":@"HouseName",
                                          @"buildingKeyId":@"BuildingKeyId",
                                          @"estateKeyId":@"EstateKeyId",
                                          @"houseKeyId":@"HouseKeyId",
                                          @"propertyKeyId":@"PropertyKeyId",
                                          @"houseType":@"HouseType",
                                          @"houseDirection":@"HouseDirection"
                                          }];
}

@end
