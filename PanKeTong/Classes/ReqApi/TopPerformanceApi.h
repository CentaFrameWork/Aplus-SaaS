//
//  TopPerformanceApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"
#import "TopPerformanceEntity.h"


// 业绩排行Api
@interface TopPerformanceApi : APlusBaseApi

@property (nonatomic, copy) NSString *employeeNo;
@property (nonatomic, strong) NSNumber *empTopCount;

@end
