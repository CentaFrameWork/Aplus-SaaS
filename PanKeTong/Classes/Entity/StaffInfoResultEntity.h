//
//  StaffInfoResultEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface StaffInfoResultEntity : SubBaseEntity

@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *staffNo;
@property (nonatomic,strong) NSString *cnName;
@property (nonatomic,strong) NSString *deptName;
@property (nonatomic,strong) NSString *domainAccount;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *agentUrl;
@property (nonatomic,strong) NSString *position;

@end
