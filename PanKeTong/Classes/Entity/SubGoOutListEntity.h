//
//  SubGoOutListEntity.h
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

///外出记录二级实体
@interface SubGoOutListEntity : SubBaseEntity

/*
 KeyId - 外出信息KeyId
 EmployeeKeyId - 外出人员ID (Nullable`1)
 EmployeeName - 外出人员姓名 (String)
 EmployeeDeptKeyid - 外出人员部门KeyId (Nullable`1)
 EmployeeDeptName - 外出人员部门名称 (String)
 GoOutTime - 外出日期 (Nullable`1)
 GoOutAddress - 外出地址 (String)
 FinishTime - 完成外出日期 (Nullable`1)
 FinishAddress - 完成外出地址 (String)
 GoOutStatus - 完成状态 (Int32)
 Remark - 备注 (String)
 */

@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,copy)NSString *employeeKeyId;//外出人员ID
@property (nonatomic,copy)NSString *employeeName;//外出人员姓名
@property (nonatomic,copy)NSString *employeeDeptKeyid;//外出人员部门KeyId
@property (nonatomic,copy)NSString *employeeDeptName;//外出人员部门名称
@property (nonatomic,copy)NSString *goOutTime;//外出日期
@property (nonatomic,copy)NSString *goOutAddress;//外出地址
@property (nonatomic,copy)NSString *finishTime;//完成外出日期
@property (nonatomic,copy)NSString *finishAddress;//完成外出地址
@property (nonatomic,copy)NSString *goOutStatus;//完成状态
@property (nonatomic,copy)NSString *remark;//备注

@end
