//
//  PropKeysEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropKeysEntity.h"

@implementation PropKeysEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"receiver":@"Receiver",
             @"receivedTime":@"ReceivedTime",
             @"keyCount":@"KeyCount",
             @"propKeyStatus":@"PropKeyStatus",
             @"type":@"Type",
             @"departmentName":@"DepartmentName",
             @"receiverPhone":@"ReceiverPhone",
             @"propertyKeyNo":@"PropertyKeyNo",
             @"linkPhone":@"LinkPhone",
             @"keyLocation":@"KeyLocation"
             };
}

@end
