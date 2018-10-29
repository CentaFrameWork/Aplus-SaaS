//
//  CheckRealSurveyViewController.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//------查看实勘


#import "BaseViewController.h"
#import "RealSurveyAuditingListEntity.h"
#import "RealSurveyAuditingEntity.h"

@protocol CheckRealSurveyOperDelegate <NSObject>

- (void)refreshData;

@end


@interface CheckRealSurveyViewController : BaseViewController

@property (nonatomic,copy)NSString *keyId;//实勘ID

@property (nonatomic,assign)NSInteger realSurveyStatus;//实勘状态

@property (nonatomic,copy)NSString *realSurveyPersonDeptKeyId;//实勘审核部门

@property (nonatomic,assign)NSInteger auditPerScope;//实勘审核权限
@property (nonatomic, strong)NSString *propertyChiefDeptKeyId; //房源归属部门KeyId（部门)
@property (strong, nonatomic) RealSurveyAuditingListEntity *listEntity;
@property (strong, nonatomic)RealSurveyAuditingEntity *realSurveyAuditingEntity;


@property (nonatomic,assign)id <CheckRealSurveyOperDelegate>operDelegate;
@end
