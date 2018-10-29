//
//  ModifyPwdApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//--------管理密码

#import "APlusBaseApi.h"
/// 管理密码
@interface ModifyPwdApi : APlusBaseApi

@property (nonatomic,copy)NSString *oldPassword;
@property (nonatomic,copy)NSString *nowPassword;
@property (nonatomic,copy)NSString *nowPassword2;

@end
