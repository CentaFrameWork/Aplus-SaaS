//
//  SignedApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 签到
@interface SignedApi : APlusBaseApi

@property (nonatomic,copy)NSString *goOutMsgKeyId;//外出信息keyID
@property (nonatomic, copy)NSString *employeeKeyId;//签到人员KeyId
@property (nonatomic, copy)NSString *employeeName;//签到人员姓名
@property (nonatomic, copy)NSString *employeeDeptKeyId;//签到部门KeyId
@property (nonatomic, copy)NSString *employeeDeptName;//签到部门名称
@property (nonatomic, copy)NSString *checkInTime;//签到时间
@property (nonatomic, copy)NSString *checkInAddress;//签到地点
@property (nonatomic, copy)NSString *longitude;//经度
@property (nonatomic, copy)NSString *latitude;//纬度
@property (nonatomic, copy)NSString *height;//高度

@end
