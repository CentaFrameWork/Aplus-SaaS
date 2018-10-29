//
//  RegisterTrustsApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/25.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
#import "RegisterTrustsEntity.h"


///委托审核列表
@interface RegisterTrustsApi : APlusBaseApi
/*
 BuildingNames - 选择的栋座单元名称条件,多栋座单元用","分隔 (String)
 HouseNo - 房号 (String)
 CreateTimeFrom - 签署时间时间起始值 (Nullable`1)
 CreateTimeTo - 签署时间截止值 (Nullable`1)
 EstateKeyId - 楼盘KeyId (Nullable`1)
 EstateNames - 输入的楼盘名称条件,多楼盘用"+"分隔 (String)
 BuildingKeyId - 栋座单元KeyId (Nullable`1)
  RegTrustsAuditStatus - 业主审核状态类型 (Nullable`1)
 CreatorPersonDeptKeyId - 签署人部门 (Nullable`1)
 CreatorPersonKeyId - 签署人 (Nullable`1)
 AuditPerScope - 审核权限范围 (Nullable`1)
 PageIndex - 当前页码 (Int32)
 PageSize - 页容量（每页多少条） (Int32)
 SortField - 排序字段名称 (String)
 Ascending - 排序方向 (Boolean)
 */

@property (nonatomic,copy) NSString *buildingNames;//选择的栋座单元名称条件,多栋座单元用","分隔
@property (nonatomic,copy) NSString *houseNo;//房号
@property (nonatomic,copy) NSString *createTimeFrom;//签署时间时间起始值
@property (nonatomic,copy) NSString *createTimeTo;//签署时间截止值
@property (nonatomic,copy) NSString *estateKeyId;//楼盘KeyId
@property (nonatomic,copy) NSString *estateNames;//输入的楼盘名称条件,多楼盘用"+"分隔
@property (nonatomic,copy) NSString *buildingKeyId;//栋座单元KeyId
@property (nonatomic,assign) int regTrustsAuditStatus;//业主审核状态类型(待审核0、审核通过1、审核拒绝2)
@property (nonatomic,copy) NSString *creatorPersonDeptKeyId;//签署人部门keyid
@property (nonatomic,copy) NSString *creatorPersonKeyId;//签署人keyid
@property (nonatomic,assign) int auditPerScope;//审核权限范围
@property (nonatomic,copy) NSString *pageIndex;//当前页码
@property (nonatomic,copy) NSString *pageSize;//页容量
@property (nonatomic,copy) NSString *sortField;//排序字段名称
@property (nonatomic,copy) NSString *ascending;//排序方向




@end
