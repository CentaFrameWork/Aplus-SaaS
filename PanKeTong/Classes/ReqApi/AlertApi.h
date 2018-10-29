//
//  AlertApi.h
//  PanKeTong
//
//  Created by 张旺 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

@interface AlertApi : APlusBaseApi

/*
 TimeFrom - 提醒日期起始值 (Nullable`1)
 TimeTo - 提醒日期截止值 (Nullable`1)
 EmployeeKeyId - 人员keyid (Nullable`1)
 DeptKeyId - 部门keyid (Nullable`1)
 Remark - 提醒内容(String)
 PageIndex - 当前页码 (Int32)
 PageSize - 页容量（每页多少条） (Int32)
 SortField - 排序字段名称 (String)
 Ascending - 排序方向 (Boolean)
 IsMobileRequest - 是否是手机端请求 (Boolean)
 */

@property (nonatomic,copy)NSString *timeFrom;
@property (nonatomic,copy)NSString *timeTo;
@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,copy)NSString *deptKeyId;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *sortField;
@property (nonatomic,copy)NSString *ascending;

@end
