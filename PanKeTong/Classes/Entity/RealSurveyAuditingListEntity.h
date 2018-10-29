//
//  RealSurveyAuditingListEntity.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface RealSurveyAuditingListEntity : AgencyBaseEntity


@property (nonatomic, strong)NSString *keyId;
@property (nonatomic, strong)NSString *propertyChiefDeptKeyId; //房源归属部门KeyId（部门)
@property (nonatomic, strong)NSString *personDeptKeyId;//实勘人部门KeyId
@property (nonatomic, strong)NSString *personDeptDepName;// 部门名称
@property (nonatomic, strong)NSString *realSurveyPersonKeyId;//实勘人KeyId
@property (nonatomic, strong)NSString *realSurveyPersonName;//实勘人名称
@property (nonatomic, strong)NSString *realSurveyPersonDeptKeyId;//实勘人部门KeyId
@property (nonatomic, strong)NSString *createTime;// 创建日期
@property (nonatomic, strong)NSString *realSurveyDate;//实勘日期
@property (nonatomic, assign)NSInteger photoCount;//照片数量
@property (nonatomic, strong)NSString *propertyStatusKeyId;//房源状态KeyId
@property (nonatomic, assign)NSInteger auditStatus;//状态
@property (nonatomic, strong)NSString *auditPersonKeyId;//审核人KeyId
@property (nonatomic, strong)NSString *auditPersonName;//初审审核人名称
@property (nonatomic, strong)NSString *auditTime;//初审时间
@property (nonatomic, strong)NSString *buildinName;//栋座Name
@property (nonatomic, strong)NSString *estateName;//楼盘Name
@property (nonatomic, strong)NSString *houseName;//房号号Name
@property (nonatomic, strong)NSString *buildingKeyId;//楼盘KeyId
@property (nonatomic, strong)NSString *estateKeyId;//楼盘Name
@property (nonatomic, strong)NSString *houseKeyId;//房号号Name
@property (nonatomic, strong)NSString *propertyKeyId;//房源KeyId
@property (nonatomic, copy)NSString *houseDirection;// 朝向
@property (nonatomic, copy)NSString *houseType;//房型
@end
