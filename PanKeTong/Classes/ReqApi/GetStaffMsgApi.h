//
//  GetStaffMsgApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"

///根据员工编号获取员工信息
@interface GetStaffMsgApi : HKBaseApi
@property (nonatomic,copy)NSString *staffNo;
@property (nonatomic,copy)NSString *cityCode;

@end
