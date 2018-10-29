//
//  LoginResultEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"
#import "LoginResultDomainUserEntity.h"

@interface LoginResultEntity : SubBaseEntity

@property (nonatomic,strong) NSString *seccion;
@property (nonatomic,strong) LoginResultDomainUserEntity *loginDomainUser;

@end
