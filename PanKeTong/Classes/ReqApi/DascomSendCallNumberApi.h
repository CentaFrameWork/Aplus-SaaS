//
//  DascomSendCallNumberApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "DascomBaseApi.h"
/// 发送拨打号码
@interface DascomSendCallNumberApi : DascomBaseApi

@property (nonatomic, copy)NSString *callNumber;
@property (nonatomic, copy)NSString *propertyId;
@property (nonatomic, copy)NSString *phoneID;
@property (nonatomic, copy)NSString *empID;
@property (nonatomic, copy)NSString *deptID;
@property (nonatomic, copy)NSString *propertyNo;

@end

