//
//  ChannelDetailApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ChannelDetailApi.h"
#import "ChannelDetailEntity.h"

@implementation ChannelDetailApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };
}


//渠道来电,渠道公客池 详情
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"customer/channel-records";
    }
    
    return @"WebApiCustomer/get_channelinquirydetail_list";

}


- (Class)getRespClass
{
    return [ChannelDetailEntity class];
}


@end
