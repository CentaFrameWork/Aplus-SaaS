//
//  LoginResultDomainUserEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"

@interface LoginResultDomainUserEntity : BaseEntity

@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *staffNo;
@property (nonatomic,strong) NSString *cnName;
@property (nonatomic,strong) NSString *deptName;
@property (nonatomic,strong) NSString *domainAccount;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *agentUrl;
@property (strong,nonatomic) NSString *CompanyName;
@property (nonatomic, copy) NSString * corporationKeyId;
@property (nonatomic, copy) NSString * corporationName;

@end
