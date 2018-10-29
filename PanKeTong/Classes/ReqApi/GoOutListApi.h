//
//  GoOutListApi.h
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

//外出记录Api
@interface GoOutListApi : APlusBaseApi

/*
 EmployeeKeyId - 外出人员id (Nullable`1)
 EmployeeName - 外出人员姓名 (String)
 EmployeeDeptKeyid - 外出人员部门KeyId (Nullable`1)
 EmployeeDeptName - 外出人员部门名称 (String)
 StartTime - 开始时间 (Nullable`1)
 EndTime - 结束时间（Nullable`1）
 GoOutStatus - 完成状态（Int32）
 PageIndex - 当前页码（Int32）
 PageSize - 页容量(每页多少条)(Int32)
 ScopeType - 数据查看范围枚举：1-全部，3-本部，4-本人 
 SortField - 排序字段名称 (String)
 Ascending - 排序方向 (Boolean)
 IsMobileRequest - 是否是手机端请求 (Boolean)
 */

@property (nonatomic,assign)int scopeType;
@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,copy)NSString *employeeDeptKeyid;
@property (nonatomic,copy)NSString *employeeDeptName;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *goOutStatus;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *sortField;
@property (nonatomic,copy)NSString *ascending;

@end
