//
//  ChangePhoneNumberApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//------修改报备手机号

#import "APlusBaseApi.h"
/// 修改报备手机号
@interface ChangePhoneNumberApi : APlusBaseApi

@property (nonatomic,copy)NSString *employeeKeyId;
@property (nonatomic,copy)NSString *mobile;

@end
