//
//  IdentifyEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "IdentifyEntity.h"

@implementation IdentifyEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uId":@"UId",
             @"uName":@"UName",
             @"departId":@"DepartId",
             @"departName":@"DepartName",
             @"userNo":@"UserNo",
             };
    
}
@end