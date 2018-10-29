//
//  TakingSeeApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///约看记录Api
@interface TakingSeeApi : APlusBaseApi
/*
 DepartmentName - 部门名称 (String)
 EmployeeName - 人员名称 (String)
 ScopeType - 数据查看范围枚举：1-全部，3-本部，4-本人 (Nullable`1)
 DateTimeStart - 跟进开始时间 (Nullable`1)
 DateTimeEnd - 跟进结束时间 (Nullable`1)
 SeePropertyType - 看房类型（全部=null、看租=10、看售=20、看租售=30） (String)
 PageIndex - 当前页码 (Int32)
 PageSize - 页容量（每页多少条） (Int32)
 SortField - 排序字段名称 (String)
 Ascending - 排序方向 (Boolean)
 IsMobileRequest - 是否是手机端请求 (Boolean)
 */

@property (nonatomic,copy)NSString *departmentName;
@property (nonatomic,copy)NSString *employeeName;
@property (nonatomic,assign)int scopeType;
@property (nonatomic,copy)NSString *dateTimeStart;
@property (nonatomic,copy)NSString *dateTimeEnd;
@property (nonatomic,copy)NSString *seePropertyType;
@property (nonatomic,copy)NSString *pageIndex; 
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *sortField;
@property (nonatomic,copy)NSString *ascending;
@property (nonatomic,copy)NSString *inquiryFollowSearchType;//搜索类型（0-不限，1-手机，2-客户编号，3-座机）

@end
