//
//  GetAllListApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///获取约看／带看／外出／提醒所有列表
@interface GetAllListApi : APlusBaseApi
/*
 ScopeType - 数据查看范围枚举：1-全部，3-本部，4-本人 (Nullable`1)
 EmployeeKeyId - (Nullable`1)
 EmployeeDeptKeyid - 外出人员部门KeyId (Nullable`1)
 StartTime - 开始时间 (Nullable`1)
 EndTime - 结束时间 (Nullable`1)
 SeePropertyType - 看房类型（全部=null、看租=10、看售=20、看租售=30） (String)
 PageIndex - 当前页码 (Int32)
 PageSize - 页容量（每页多少条） (Int32)
 SortField - 排序字段名称 (String)
 Ascending - 排序方向 (Boolean)
 */

@property (nonatomic,assign)int scopeType;//约看带看的权限
@property (nonatomic,assign)int outScopeType;//外出的权限
@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *employeeDeptKeyId;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *sortField;
@property (nonatomic,copy)NSString *ascending;

@end
