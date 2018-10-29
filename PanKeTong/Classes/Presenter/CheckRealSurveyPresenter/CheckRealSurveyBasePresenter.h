//
//  CheckRealSurveyBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "CheckRealSurveyViewProtocol.h"
#import "RealSurveyAuditingListEntity.h"
#import "PhotoEntity.h"
#import "RealSurveyAuditingEntity.h"

@interface CheckRealSurveyBasePresenter : BasePresenter

@property (assign, nonatomic) id<CheckRealSurveyViewProtocol>selfView;

- (instancetype)initWithDelegate:(id<CheckRealSurveyViewProtocol>)delegate;

/// 设置装修情况字段显示情况
- (void)setDecorationSituationDisplaySituation;

/// 是否含有装修情况功能
- (BOOL)haveDecorationSituationFunction;

/// 是否需要根据权限来隐藏"通过""拒绝"按钮
- (BOOL)needHidePushButtonOrRefuseButton:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                           andListEntity:(RealSurveyAuditingListEntity *)listEntity;

/// 是否显示提交按钮
- (BOOL)needShowSubmitButton;

/// 拒绝实勘审核
- (NSString *)refusedRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                               andListEntity:(RealSurveyAuditingListEntity *)listEntity;

/// 通过实勘审核
- (NSString *)passRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                            andListEntity:(RealSurveyAuditingListEntity *)listEntity;

/// 是否需要拒绝理由
- (BOOL)needRefusedReason;

/// 是否有全景图功能
- (BOOL)havePanoramaFunction;

/// 是否有图片类型
- (BOOL)havePhotoType;

@end
