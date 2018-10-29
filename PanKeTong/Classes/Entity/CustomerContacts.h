//
//  CustomerContacts.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface CustomerContacts : SubBaseEntity

@property (nonatomic,strong) NSString *contactType;     // 联系人类型
@property (nonatomic,strong) NSString *contactName;     // 联系人姓名
@property (nonatomic,strong) NSString *gender;          // 联系人性别：系统参数性别
@property (nonatomic,strong) NSString *mobile;          // 手机
@property (nonatomic,strong) NSString *tel;             // 座机
@property (nonatomic,strong) NSString *seq;             // 排序字段
@property (nonatomic,strong) NSString *regPerson;       // 登记人
@property (nonatomic,strong) NSString *regDeparment;    // 登记部门
@property (nonatomic,strong) NSString *createTime;      // 创建时间

@end
