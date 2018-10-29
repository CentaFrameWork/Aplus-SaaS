//
//  ChannelCallModelEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/26.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelCallModelEntity.h"

@implementation ChannelCallModelEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mkeyId":@"KeyId",
             @"mphone":@"Phone",
             @"mcreateTime":@"CreateTime",
             @"mchannelSourceKeyId":@"ChannelSourceKeyId",
             @"mchannelInquirySources":@"ChannelInquirySources",
             @"motherNetComments":@"OtherNetComments",
             @"mchannelInquiryChief":@"ChannelInquiryChief",
             @"mchannelInquiryChiefDept":@"ChannelInquiryChiefDept",
             @"mpublicAccount":@"PublicAccount",
             @"isMyPayChannelInquiry":@"IsMyPayChannelInquiry"
             };
}


@end
