//
//  AddAlertApi.h
//  PanKeTong
//
//  Created by 张旺 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///新增／编辑提醒
@interface AddAlertApi : APlusBaseApi

@property (nonatomic,copy)NSString *keyId;
@property (nonatomic,strong)NSNumber *alertEventStatus;//传1时表示编辑外出。不传或者其他表示新增
@property (nonatomic, strong) NSString * employeeKeyId;
@property (nonatomic, strong) NSString * employeeName;
@property (nonatomic, strong) NSString * employeeNo;
@property (nonatomic, strong) NSString * deptKeyId;
@property (nonatomic, strong) NSString * deptName;
@property (nonatomic, strong) NSString * alertEventTimes;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * createUserKeyId;

@end
