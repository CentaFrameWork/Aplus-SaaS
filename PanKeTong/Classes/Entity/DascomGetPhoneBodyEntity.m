//
//  DascomGetPhoneBodyEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomGetPhoneBodyEntity.h"

@implementation DascomGetPhoneBodyEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mMsisdn":@"msisdn",
             @"mSsmnNumber":@"ssmnNumber"};
}


@end
