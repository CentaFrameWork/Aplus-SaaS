//
//  LoginApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"
/// 登录Api
@interface LoginApi : HKBaseApi

@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *psd;

@end
