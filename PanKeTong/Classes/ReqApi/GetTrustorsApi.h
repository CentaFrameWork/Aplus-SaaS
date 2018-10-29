//
//  GetTrustorsApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 获取联系人信息
@interface GetTrustorsApi : APlusBaseApi

@property (nonatomic, copy)NSString *keyId;
@property (nonatomic, copy)NSString *departmentKeyId;
@property (nonatomic, copy)NSString *userPhone;
@property (nonatomic, copy)NSString *userKeyId;

@end
