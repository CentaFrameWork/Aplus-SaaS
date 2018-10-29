//
//  ChannelCallApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ChannelCallApi.h"
#import "ChannelCallEntity.h"

@implementation ChannelCallApi

- (NSDictionary *)getBody
{
    if (self.channelType == ChannelCall) {
        //渠道来电
        return @{
                 @"PhoneLike":_phoneLike,
                 @"ChannelSourceStr":_channelSourceStr,
                 @"StartDate":_startDate,
                 @"EndDate":_endDate,
                 @"ChiefDeptKeyId":_chiefDeptKeyId,
                 @"ChiefKeyId":_chiefKeyId,
                 @"PublicAccountKeyId":_publicAccountKeyId,
                 @"ChannelInquiryRange":_channelInquiryRange,
                 @"PageIndex":_pageIndex,
                 @"PageSize":_pageSize,
                 @"SortField":_sortField,
                 @"Ascending":_ascending,
                 
                 };

    }

    //渠道公客池
    return @{
             @"ChannelSourceStr":_channelSourceStr,
             @"StartDate":_startDate,
             @"EndDate":_endDate,
             @"ChiefDeptKeyId":_chiefDeptKeyId,
             @"ChiefKeyId":_chiefKeyId,
             @"PublicAccountKeyId":_publicAccountKeyId,
             @"ChannelInquiryRange":_channelInquiryRange,
             @"PageIndex":_pageIndex,
             @"PageSize":_pageSize,
             @"SortField":_sortField,
             @"Ascending":_ascending,

             };
}

/// 渠道来电或渠道公客池
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        if (self.channelType == ChannelCall) {
            return @"customer/all-channel";
        }

        return @"customer/public-channel";
    }
    
    if (self.channelType == ChannelCall) {
        return @"WebApiCustomer/get_channelinquiry_list";
    }

    return @"WebApiCustomer/get_publicchannelinquiry_list";
}


- (Class)getRespClass
{
    return [ChannelCallEntity class];
}




@end
