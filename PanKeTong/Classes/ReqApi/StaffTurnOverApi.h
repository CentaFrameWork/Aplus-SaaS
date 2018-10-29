//
//  StaffTurnOverApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/12.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///人员异动APi
@interface StaffTurnOverApi : APlusBaseApi

/*
 KeyId - KeyId (Guid)
 EmployeeKeyId - 签到人员KeyId (Guid)
 EmployeeName - 签到人员姓名 (String)
 EmployeeDeptKeyId - 签到部门KeyId (Guid)
 EmployeeDeptName - 签到部门名称 (String)
 OperationType - 操作类型（1-新增，0-删除 2-查询） (Int32)
 */
@property (nonatomic,copy)NSString *keyId;//
@property (nonatomic,copy)NSString *employeeKeyId;//签到人员KeyId
@property (nonatomic,copy)NSString *employeeName;//签到人员姓名
@property (nonatomic,copy)NSString *employeeDeptKeyId;//签到部门KeyId
@property (nonatomic,copy)NSString *employeeDeptName;//签到部门名称
@property (nonatomic,copy)NSString *operationType;//操作类型


@end
