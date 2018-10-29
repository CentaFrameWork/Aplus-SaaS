//
//  AddGoOutApi.h
//  PanKeTong
//
//  Created by 张旺 on 17/1/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
#define addGoOut 1//新增外出
#define editGoOut 2//编辑外出

//新增/编辑外出Api
@interface AddGoOutApi : APlusBaseApi

/*
 KeyId - keyId(Guid)
 GoOutCustProps - 外出房源客户信息集合（List`1）
 EmployeeKeyId - 外出人员id (Nullable`1)
 EmployeeName - 外出人员姓名 (String)
 EmployeeDeptKeyid - 外出人员部门KeyId (Nullable`1)
 EmployeeDeptName - 外出人员部门名称 (String)
 GoOutTime - 外出日期 (Nullable`1)
 GoOutAddress - 外出地址 (String)
 FinishTime - 完成外出日期 (Nullable`1)
 FinishAddress - 完成外出地址 (String)
 GoOutStatus - 完成状态（Int32）
 Remark - 备注（String）
 IsMobileRequest - 是否是手机端请求 (Boolean)
 */
@property (nonatomic,assign)NSInteger commitGoOutType;
@property (nonatomic,copy) NSString *keyId;
@property (nonatomic,strong) NSArray *goOutCustProps;
@property (nonatomic,copy) NSString *employeeKeyId;
@property (nonatomic,copy) NSString *employeeName;
@property (nonatomic,copy) NSString *employeeDeptKeyid;
@property (nonatomic,copy) NSString *employeeDeptName;
@property (nonatomic,copy) NSString *goOutTime;
@property (nonatomic,copy) NSString *goOutAddress;
@property (nonatomic,copy) NSString *finishTime;
@property (nonatomic,copy) NSString *finishAddress;
@property (nonatomic,copy) NSString *goOutStatus;
@property (nonatomic,copy) NSString *remark;

@end

@interface GoOutCustProps : APlusBaseApi

@property (nonatomic,copy) NSString *keyId;
@property (nonatomic,copy) NSString *goOutMsgKeyId;
@property (nonatomic,copy) NSString *propertyKeyId;
@property (nonatomic,copy) NSString *propertyName;
@property (nonatomic,copy) NSString *customerKeyId;
@property (nonatomic,copy) NSString *customerName;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *isDelete;

@end