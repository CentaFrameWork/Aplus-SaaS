//
//  CityConfigApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"

/// 城市配置
@interface CityConfigApi : HKBaseApi

@property (nonatomic, copy) NSString *configType;
@property (nonatomic, copy) NSString *length;

@end
