//
//  SigendRecordListEntity.m
//  PanKeTong
//
//  Created by zhwang on 16/4/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SigendRecordListEntity.h"

@implementation SigendRecordListEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"employeeKeyId":@"EmployeeKeyId",
             @"employeeName":@"EmployeeName",
             @"employeeDeptKeyId":@"EmployeeDeptKeyId",
             @"employeeDeptName":@"EmployeeDeptName",
             @"checkInTime":@"CheckInTime",
             @"checkInAddress":@"CheckInAddress",
             @"longitude":@"Longitude",
             @"latitude":@"Latitude",
             @"height":@"Height",
             @"createTime":@"CreateTime",
             };
}
@end
