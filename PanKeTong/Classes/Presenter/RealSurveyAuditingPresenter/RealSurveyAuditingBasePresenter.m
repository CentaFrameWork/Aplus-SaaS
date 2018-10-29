//
//  RealSurveyAuditingBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "RealSurveyAuditingBasePresenter.h"

@implementation RealSurveyAuditingBasePresenter

- (instancetype)initWithDelegate:(id<RealSurveyAuditingViewProtocol>)delegate
{
    self = [super init];
    if (self)
    {
        _selfView = delegate;
    }
    return self;
}

/// 获得获得下拉选项数组
- (NSArray *)getDropDownMeunArray
{
    return @[@"待审核",@"审核通过",@"审核拒绝"];
}

/// 获得默认状态
- (NSString *)getDefaultState
{
    return @"待审核";
}

/// 是否需要根据权限来隐藏"通过""拒绝"按钮
- (BOOL)needHidePushButtonOrRefuseButton
{
    return NO;
}

/// 实勘审核--通过
- (NSString *)passRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                            andListEntity:(RealSurveyAuditingListEntity *)listEntity
                      andDepartmentKeyIds:(NSString *)departmentKeyIds
{
    NSInteger auditPerScope = realSurveyAuditingEntity.auditPerScope;

    if (auditPerScope == MYDEPARTMENT)
    {
        // 拥有实勘审核本部权限
        PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];
        
        if ([entity.departmentKeyIds contains:listEntity.propertyChiefDeptKeyId])
        {
            [_selfView passAction];
        }
        else
        {
            return @"您没有相关权限！";
        }
        
    }
    else if(auditPerScope == ALL)
    {
        // 拥有实勘审核全部权限
        [_selfView passAction];
    }

    return nil;
}

/// 实勘审核--拒绝
- (NSString *)refusedRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                               andListEntity:(RealSurveyAuditingListEntity *)listEntity
                         andDepartmentKeyIds:(NSString *)departmentKeyIds
{
    NSInteger auditPerScope = realSurveyAuditingEntity.auditPerScope;
    if (auditPerScope == MYDEPARTMENT)
    {
        // 拥有实勘审核本部权限
        PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];
        
        // 其他城市
        if ([entity.departmentKeyIds contains:listEntity.propertyChiefDeptKeyId])
        {
            [_selfView refusedAction];
        }
        else
        {
            return @"您没有相关权限！";
        }
    }
    else if(auditPerScope == ALL)
    {
        // 拥有实勘审核全部权限
        [_selfView refusedAction];
    }

    return nil;
}

/// 是否需要拒绝理由
- (BOOL)needRefusedReason
{
    return NO;
}

/// 获得待审核右滑得到的按钮
- (NSArray *)getUnapprovedArray:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                  andListEntity:(RealSurveyAuditingListEntity *)listEntity
{
    return @[RefuseStr,PassStr,HouseDataStr];
}

/// 获得"待提交"右滑得到的按钮
- (NSArray *)getUnsibmitArray:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                andListEntity:(RealSurveyAuditingListEntity *)listEntity
{
    return @[];
}

/// 获得"审核"/"查看权限"状态
- (NSInteger)getAuditPerScope
{
    // 审核权限范围
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_NONET])
    {
        // 无权限
        return NONE;
    }
    else if([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_MYDEPARTMENT])
    {
        // 本部
        return MYDEPARTMENT;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_ALL])
    {
        // 全部
        return ALL;
    }
    
    return NONE;
}
@end
