//
//  RealSurveyAuditingEntity.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingEntity.h"

@implementation RealSurveyAuditingEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"propertyKeyId":@"PropertyKeyId",
//                                          @"estateBuildingName":@"EstateBuildingName",
                                          @"buildingNames":@"BuildingNames",
                                          @"houseNo":@"HouseNo",
                                          @"createTimeFrom":@"CreateTimeFrom",
                                          @"createTimeTo":@"CreateTimeTo",
                                          @"auditPersonKeyId":@"AuditPersonKeyId",
                                          @"auditPersonDeptKeyId":@"AuditPersonDeptKeyId",
                                          @"estateKeyId":@"EstateKeyId",
                                          @"estateNames":@"EstateNames",
                                          @"buildingKeyId":@"BuildingKeyId",
                                          @"propertyChiefDeptKeyId":@"PropertyChiefDeptKeyId",
                                          @"auditPerson2KeyId":@"AuditPerson2KeyId",
                                          @"auditPerson2Name":@"AuditPerson2Name",
                                          @"auditStatus":@"AuditStatus",
                                          @"realSurveyPersonDeptKeyId":@"RealSurveyPersonDeptKeyId",
                                          @"realSurveyPersonKeyId":@"RealSurveyPersonKeyId",
                                          @"auditPerScope":@"AuditPerScope",
                                          @"realSurveysPerType":@"RealSurveysPerType",
                                          @"pageIndex":@"PageIndex",
                                          @"pageSize":@"PageSize",
                                          @"sortField":@"SortField",
                                          @"ascending":@"Ascending",
                                          @"isMobileRequest":@"IsMobileRequest",
                                          @"auditPersonKeyName":@"AuditPersonKeyName",
                                          @"realSurveyPersonKeyName":@"RealSurveyPersonKeyName",
                                          @"realSurveyPersonDeptName":@"realSurveyPersonDeptName",
                                          }];
}

@end
