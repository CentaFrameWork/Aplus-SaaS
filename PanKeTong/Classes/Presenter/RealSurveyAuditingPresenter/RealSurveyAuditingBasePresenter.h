//
//  RealSurveyAuditingBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "RealSurveyAuditingViewProtocol.h"
#import "RealSurveyAuditingListEntity.h"
#import "RealSurveyAuditingEntity.h"

#define PassStr         @"通过"
#define RefuseStr       @"拒绝"
#define HouseDataStr    @"房源详情"
#define SubmitStr       @"提交"
#define RecordStr       @"审核记录"

@interface RealSurveyAuditingBasePresenter : BasePresenter

@property (assign, nonatomic) id<RealSurveyAuditingViewProtocol>selfView;

- (instancetype)initWithDelegate:(id<RealSurveyAuditingViewProtocol>)delegate;

/// 获得获得下拉选项数组
- (NSArray *)getDropDownMeunArray;

/// 获得默认状态
- (NSString *)getDefaultState;

/// 是否需要根据权限来隐藏"通过""拒绝"按钮
- (BOOL)needHidePushButtonOrRefuseButton;

/// 获得"待审核"右滑得到的按钮
- (NSArray *)getUnapprovedArray:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                  andListEntity:(RealSurveyAuditingListEntity *)listEntity;

/// 获得"待提交"右滑得到的按钮
- (NSArray *)getUnsibmitArray:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                andListEntity:(RealSurveyAuditingListEntity *)listEntity;

/// 获得"审核"/"查看权限"状态
- (NSInteger)getAuditPerScope;

/// 实勘审核--通过
- (NSString *)passRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                            andListEntity:(RealSurveyAuditingListEntity *)listEntity
                      andDepartmentKeyIds:(NSString *)departmentKeyIds;

/// 实勘审核--拒绝
- (NSString *)refusedRealSurveyAuditPerScope:(RealSurveyAuditingEntity *)realSurveyAuditingEntity
                               andListEntity:(RealSurveyAuditingListEntity *)listEntity
                         andDepartmentKeyIds:(NSString *)departmentKeyIds;

/// 是否需要拒绝理由
- (BOOL)needRefusedReason;
@end
