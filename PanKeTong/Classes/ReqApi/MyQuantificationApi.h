//
//  MyQuantificationApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 获取我的工作量化
@interface MyQuantificationApi : APlusBaseApi

@property (nonatomic,copy)NSString *DepartmentKeyId;
@property (nonatomic,copy)NSString *userKeyId;

@end
