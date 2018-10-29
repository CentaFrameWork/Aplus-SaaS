//
//  CustomerContacts.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerContacts.h"

@implementation CustomerContacts

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"contactType":@"ContactType",
             @"contactName":@"ContactName",
             @"gender":@"Gender",
             @"mobile":@"Mobile",
             @"tel":@"Tel",
             @"seq":@"Seq",
             @"regPerson":@"RegPerson",
             @"regDeparment":@"RegDeparment",
             @"createTime":@"CreateTime"
             };
}

@end
