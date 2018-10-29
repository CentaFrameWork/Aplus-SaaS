//
//  PropertyCallRecordResultEntity.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/17.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PropertyCallRecordResultEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *owner; // 业主
@property (nonatomic, copy) NSString *operatorStr; // 操作者
@property (nonatomic, copy) NSString *empID; // 操作人
@property (nonatomic, copy) NSString *deptID; // 操作人所属部门
@property (nonatomic, copy) NSString *callTime; // 通话时间
@property (nonatomic, copy) NSString *startTime;// 通话时间
@property (nonatomic, copy) NSString *endTime; // 通话时间
@property (nonatomic, copy) NSString *operationDepart;// 操作部门;
@property (nonatomic, copy) NSString *tape; // 录音
@property (nonatomic, copy) NSString *recordId;// 录音ID
@property (nonatomic, copy) NSString *relevantFollow;//  相关跟进
@property (nonatomic, copy) NSString *propertyKeyId;// 房源KeyId;
@property (nonatomic, copy) NSString *tapDownUrl;// 录音下载地址;
@property (nonatomic, copy) NSString *followContent;// - 跟进内容 (String);
@property (nonatomic, copy) NSString *peroId;// 通话时长;
@end
