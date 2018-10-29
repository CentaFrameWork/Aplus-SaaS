//
//  PhoneAddressInfo.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "PhoneAddressInfo.h"

@implementation PhoneAddressInfo

//"areacode": "0571",
//"city": "杭州",
//"operator": "中国移动",
//"phone": "13588857364",
//"postcode": "310000",
//"province": "浙江"

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"areacode":@"areacode",
             @"city":@"city",
             @"operator":@"operator",
             @"phone":@"phone",
             @"postcode":@"postcode",
             @"province":@"province"
             };
    
}

@end
