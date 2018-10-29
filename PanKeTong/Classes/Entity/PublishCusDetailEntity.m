//
//  PublishCusDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCusDetailEntity.h"

@implementation PublishCusDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"inquiryTradeType":@"InquiryTradeType",
             @"customerName":@"CustomerName",
             @"districts":@"Districts",
             @"targetEstateName":@"TargetEstateName",
             @"roomType":@"RoomType",
             @"keyId":@"KeyId",
             };
}


@end
