//
//  RealSurveyAuditingListApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingListApi.h"
#import "RealSurveyReviedListEntity.h"

@implementation RealSurveyAuditingListApi

- (NSDictionary *)getBody
{
    NSString *auditPerScope = [NSString stringWithFormat:@"%ld",_realSurveyAuditingEntity.auditPerScope];
    NSString *realSurveysAuditType = [NSString stringWithFormat:@"%ld",_realSurveyAuditingEntity.realSurveysAuditType];
    
    return @{
             @"PropertyKeyId" : _realSurveyAuditingEntity.propertyKeyId?_realSurveyAuditingEntity.propertyKeyId:@"",
             @"BuildingNames" : _realSurveyAuditingEntity.buildingNames?_realSurveyAuditingEntity.buildingNames:@"",
             @"HouseNo" : _realSurveyAuditingEntity.houseNo?_realSurveyAuditingEntity.houseNo:@"",
             @"CreateTimeFrom" : _realSurveyAuditingEntity.createTimeFrom?_realSurveyAuditingEntity.createTimeFrom:@"",
             @"CreateTimeTo" : _realSurveyAuditingEntity.createTimeTo?_realSurveyAuditingEntity.createTimeTo:@"",
             @"AuditPersonKeyId" : _realSurveyAuditingEntity.auditPersonKeyId?_realSurveyAuditingEntity.auditPersonKeyId:@"",
             @"AuditPersonDeptKeyId" : _realSurveyAuditingEntity.auditPersonDeptKeyId?_realSurveyAuditingEntity.auditPersonDeptKeyId:@"",
             @"EstateKeyId" : _realSurveyAuditingEntity.estateKeyId?_realSurveyAuditingEntity.estateKeyId:@"",
             @"EstateNames" : _realSurveyAuditingEntity.estateNames?_realSurveyAuditingEntity.estateNames:@"",
             @"BuildingKeyId" : _realSurveyAuditingEntity.buildingKeyId?_realSurveyAuditingEntity.buildingKeyId:@"",
//             @"PropertyChiefDeptKeyId" : _realSurveyAuditingEntity.propertyChiefDeptKeyId?_realSurveyAuditingEntity.propertyChiefDeptKeyId:@"",
             @"AuditPerson2KeyId" : _realSurveyAuditingEntity.auditPerson2KeyId?_realSurveyAuditingEntity.auditPerson2KeyId:@"",
             @"AuditPerson2Name" : _realSurveyAuditingEntity.auditPerson2Name?_realSurveyAuditingEntity.auditPerson2Name:@"",
             @"AuditStatus" : _realSurveyAuditingEntity.auditStatus?_realSurveyAuditingEntity.auditStatus:@"",
             @"RealSurveyPersonDeptKeyId" : _realSurveyAuditingEntity.realSurveyPersonDeptKeyId?_realSurveyAuditingEntity.realSurveyPersonDeptKeyId:@"",
             @"RealSurveyPersonKeyId" : _realSurveyAuditingEntity.realSurveyPersonKeyId?_realSurveyAuditingEntity.realSurveyPersonKeyId:@"",
             @"AuditPerScope" :auditPerScope ?auditPerScope:@"",
             @"RealSurveysPerType" : _realSurveyAuditingEntity.realSurveysPerType?_realSurveyAuditingEntity.realSurveysPerType:@"",
             @"PageIndex":_pageIndex?_pageIndex:@"",
             @"PageSize":_pageSize?_pageSize:@"",
             @"SortField":_sortField?_sortField:@"",
             @"Ascending":_ascending?_ascending:@"",
             @"RealSurveysAuditType":realSurveysAuditType?realSurveysAuditType:@"",
             };
}

//实勘审核查询列表
- (NSString *)getPath
{
    if ([CommonMethod isRequestFinalApiAddress])
    {
        return @"property/revied-real-surveys";
    }
    return @"WebApiProperty/get_real_survey_revied_list";
}


- (Class)getRespClass
{
    return  [RealSurveyReviedListEntity class];
}


@end
