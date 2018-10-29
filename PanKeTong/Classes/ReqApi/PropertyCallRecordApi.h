//
//  PropertyCallRecordApi.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
/// 房源详情获取通话记录
@interface PropertyCallRecordApi : APlusBaseApi

@property (nonatomic, copy) NSString *startTime; //- 开始日期 (Nullable`1)
@property (nonatomic, copy) NSString *endTime; // 结束时期 (Nullable`1)
@property (nonatomic, copy) NSString *userKeyId; // 用户KeyId (Nullable`1)
@property (nonatomic, copy) NSString *deptKeyId; // 部门KeyId
@property (nonatomic, copy) NSString *propertyKeyId; // - 房源KeyId (Guid);
@property (nonatomic, copy) NSString *scope; // 通话记录查看范围枚举：4-本人，3-本部，1-全部 (String);
@property (nonatomic, copy) NSString *pageIndex; //当前页码
@property (nonatomic, copy) NSString *pageSize; // 页容量（每页多少条） (Int32);
@property (nonatomic, copy) NSString *sortField; // 排序字段名称 ;
@property (nonatomic, copy) NSString *ascending; // 排序方向 ;
@end
