//
//  RealSurveySearchApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//--------实勘搜索

#import "APlusBaseApi.h"
/// 搜索通盘房源
@interface RealSurveySearchApi : APlusBaseApi
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *topCount;
@property (nonatomic, copy) NSString *estateSelectType;
@property (nonatomic, copy) NSString *buildName;
@end
