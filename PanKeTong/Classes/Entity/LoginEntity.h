//
//  LoginEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"
#import "LoginResultEntity.h"

@interface LoginEntity : BaseEntity

@property (nonatomic,strong) LoginResultEntity *result;


@end
