//
//  PersonalInfoEntity.m
//  PanKeTong
//
//  Created by zhwang on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PersonalInfoEntity.h"

@implementation PersonalInfoEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"employeeNo":@"EmployeeNo",
             @"employeeName":@"EmployeeName",
             @"position":@"Position",
             @"departmentName":@"DepartmentName",
             @"email":@"Email",
             @"tel":@"Tel",
             @"mobile":@"Mobile",
             @"wxNo":@"WxNo",
             @"weiXinQRCodeUrl":@"WeiXinQRCodeUrl",
             @"signature":@"Signature",
             @"photoPath":@"PhotoPath",
             @"extendTel":@"ExtendTel"
             };
    
}
@end
