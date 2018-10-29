//
//  SigendRecordListEntity.h
//  PanKeTong
//
//  Created by zhwang on 16/4/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"

@interface SigendRecordListEntity : BaseEntity

@property (nonatomic ,strong) NSString *employeeKeyId;//人员keyid
@property (nonatomic ,strong) NSString *employeeName;//人员名称
@property (nonatomic ,strong) NSString *employeeDeptKeyId;//部门keyid
@property (nonatomic ,strong) NSString *employeeDeptName;//部门名称
@property (nonatomic ,strong) NSString *checkInTime;//签到时间
@property (nonatomic ,strong) NSString *checkInAddress;// 签到地址
@property (nonatomic ,strong) NSString *longitude;// 经度
@property (nonatomic ,strong) NSString *latitude;//纬度
@property (nonatomic ,strong) NSString *height;//高度
@property (nonatomic ,strong) NSString *createTime;//创建时间 
@end
