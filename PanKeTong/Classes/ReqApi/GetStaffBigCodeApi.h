//
//  GetStaffBigCodeApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

/// 获得员工400号码等信息
@interface GetStaffBigCodeApi : APlusBaseApi

@property (nonatomic, copy) NSString *staffno;  // 经纪人工号

@end
