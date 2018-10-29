//
//  MyPerformanceApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/7.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
#import "MyPerformanceEntity.h"

/// 当前登录业务员个人业绩
@interface MyPerformanceApi : APlusBaseApi

@property (nonatomic, copy) NSString *employeeNo;   // 员工编号
//@property (nonatomic, strong) NSNumber *empTopCount;  // 当前获取排名数量

@end
