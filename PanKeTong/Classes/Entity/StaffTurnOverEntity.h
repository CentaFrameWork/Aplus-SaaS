//
//  StaffTurnOverEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/12.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

///人员异动时获取到的消息实体
@interface StaffTurnOverEntity : SubBaseEntity
@property (nonatomic,copy)NSString *keyId;//主键
@property (nonatomic,copy)NSString *employeeKeyId;//员工keyid
@property (nonatomic,copy)NSString *employeeName;//员工姓名
@property (nonatomic,copy)NSString *createTime;//创建时间
@property (nonatomic,copy)NSString *employeeDeptKeyId;//所属部门keyid
@property (nonatomic,copy)NSString *employeeDeptName;//所属部门名称
@property (nonatomic,copy)NSString *requestSourceType;//来源类型


@end
