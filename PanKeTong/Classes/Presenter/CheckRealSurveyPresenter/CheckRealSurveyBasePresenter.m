//
//  CheckRealSurveyBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckRealSurveyBasePresenter.h"

@implementation CheckRealSurveyBasePresenter

- (instancetype)initWithDelegate:(id<CheckRealSurveyViewProtocol>)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 是否需要根据权限来隐藏"通过""拒绝"按钮
- (BOOL)needHidePushButtonOrRefuseButton:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                           andListEntity:(RealSurveyAuditingListEntity *)listEntity
{
    return NO;
}

/// 是否显示提交按钮
- (BOOL)needShowSubmitButton
{
    return NO;
}

/// 设置装修情况字段显示情况
- (void)setDecorationSituationDisplaySituation
{
    [_selfView controlDecorationSituationDisplaySituation];
}

/// 是否含有装修情况功能
- (BOOL)haveDecorationSituationFunction
{
    return NO;
}


/// 通过实勘审核
- (NSString *)passRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                            andListEntity:(RealSurveyAuditingListEntity *)listEntity
{
    NSInteger auditPerScope = realSurveyAuditingEntity.auditPerScope;

    if (auditPerScope == MYDEPARTMENT)
    {
        // 拥有实勘审核本部权限
        PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];
        
            if ([entity.departmentKeyIds contains:listEntity.propertyChiefDeptKeyId])
            {
                [self.selfView passAlert];
                
            }else{
                return @"您没有相关权限！";
            }
        
    }else if(auditPerScope == ALL){
        //拥有实勘审核全部权限
        [self.selfView passAlert];
    }

    return nil;
}

/// 拒绝实勘审核
- (NSString *)refusedRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                               andListEntity:(RealSurveyAuditingListEntity *)listEntity
{
    NSInteger auditPerScope = realSurveyAuditingEntity.auditPerScope;
    
    if (auditPerScope == MYDEPARTMENT) {
        //拥有实勘审核本部权限
        PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];

        if ([entity.departmentKeyIds contains:listEntity.propertyChiefDeptKeyId]) {
            
            [self.selfView refusedAlert];
            
        }else{
            return @"您没有相关权限！";
        }
        
    }else if(auditPerScope == ALL){
        //拥有实勘审核全部权限
        [_selfView refusedAlert];
        
    }
    
    return nil;
}

/// 是否需要拒绝理由
- (BOOL)needRefusedReason
{
    return NO;
}


/// 是否有全景图功能
- (BOOL)havePanoramaFunction
{
    return NO;
}

/// 是否有图片类型
- (BOOL)havePhotoType
{
    return NO;
}
@end
