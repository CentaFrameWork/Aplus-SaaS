//
//  SSOModifyApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SSOBaseApi.h"

/// SSO密码回写
@interface SSOModifyApi : SSOBaseApi

@property (nonatomic, copy)NSString *empNo;
@property (nonatomic, copy)NSString *passWord;

@end
