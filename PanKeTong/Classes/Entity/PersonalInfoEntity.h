//
//  PersonalInfoEntity.h
//  PanKeTong
//
//  Created by zhwang on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PersonalInfoEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *employeeNo;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *wxNo;
@property (nonatomic, copy) NSString *weiXinQRCodeUrl;      // 微信二维码图片
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *photoPath;
@property (nonatomic, strong) NSArray *extendTel;           // 其他报备手机号码

@end
