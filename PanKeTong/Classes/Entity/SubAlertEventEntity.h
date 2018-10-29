//
//  SubAlertEventEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"


///提醒记录列表二级实体
@interface SubAlertEventEntity : SubBaseEntity
/*
 EmployeeKeyId - 人员keyid (Nullable`1)
 EmployeeName - 人员名称 (String)
 EmployeeNo - 人员编号 (String)
 DeptKeyId - 部门keyid (Nullable`1)
 DeptName - 部门名称 (String)
 Remark - 提醒内容 (String)
 AlertEventTimes - 提醒时间 (Nullable`1)
 CreateTime - 创建时间 (Nullable`1)
 */
@property (nonatomic,copy)NSString *keyId;//提醒KeyId
@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,copy)NSString *employeeNo;
@property (nonatomic,copy)NSString *deptKeyId;
@property (nonatomic,copy)NSString *deptName;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *alertEventTimes;
@property (nonatomic,copy)NSString *createTime;


@end
