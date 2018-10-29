//
//  RealSurveyAuditingListApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#import "RealSurveyAuditingEntity.h"
/// 实勘审核查询列表
@interface RealSurveyAuditingListApi : APlusBaseApi

@property (nonatomic,strong)RealSurveyAuditingEntity *realSurveyAuditingEntity;
//@property (nonatomic,copy)NSString *propertyKeyId;//房源KeyId
//@property (nonatomic,copy)NSString *buildingNames;//选择的栋座单元名称条件,多栋座单元用","分隔
//@property (nonatomic,copy)NSString *houseNo;//房号
//@property (nonatomic,copy)NSString *createTimeFrom;//实勘时间起始值
//@property (nonatomic,copy)NSString *createTimeTo;//实勘时间截止值
//@property (nonatomic,copy)NSString *auditPersonKeyId;//审核人keyId
//@property (nonatomic,copy)NSString *auditPersonDeptKeyId;//审核人部门KeyId
//@property (nonatomic,copy)NSString *estateKeyId;//楼盘KeyId
//@property (nonatomic,copy)NSString *estateNames;//输入的楼盘名称条件,多楼盘用"+"分隔
//@property (nonatomic,copy)NSString *buildingKeyId;//栋座单元KeyId
//@property (nonatomic,copy)NSString *propertyChiefDeptKeyId;
//@property (nonatomic,copy)NSString *auditPerson2KeyId;//复审人
//@property (nonatomic,copy)NSString *auditPerson2Name;//复审人名称
//@property (nonatomic,copy)NSString *auditStatus;//实勘状态类型
//@property (nonatomic,copy)NSString *realSurveyPersonDeptKeyId;//实勘人部门
//@property (nonatomic,copy)NSString *realSurveyPersonKeyId;//实勘人
//@property (nonatomic,copy)NSString *auditPerScope;//审核权限范围
//@property (nonatomic,copy)NSString *realSurveysPerType;//当前用户拥有实勘审核权限类型
@property (nonatomic,copy)NSString *pageIndex;//当前页码
@property (nonatomic,copy)NSString *pageSize;//页容量
@property (nonatomic,copy)NSString *sortField;//排序字段名称
@property (nonatomic,copy)NSString *ascending;//排序方向
@end
