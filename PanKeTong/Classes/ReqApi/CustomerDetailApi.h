//
//  CustomerDetailApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 客户详情
@interface CustomerDetailApi : APlusBaseApi

@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, copy) NSString *contactName;  // 显示联系人

@end
