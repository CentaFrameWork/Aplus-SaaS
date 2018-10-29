//
//  TurnPrivateCustomerApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TurnPrivateCustomerApi.h"
#import "TurnPrivateCustomerEntity.h"

@implementation TurnPrivateCustomerApi

- (NSDictionary *)getBody
{
    if (self.TurnPrivateCustomerType == BJ) {
        //北京
        return @{
                 @"ContactName":_contactName,
                 @"InquiryStatusKeyId":_inquiryStatusKeyId,
                 @"ChannelInquiryKeyId":_channelInquiryKeyId,
                 @"GenderKeyId":_genderKeyId,
                 @"ContactTypeKeyId":_contactTypeKeyId,
                 @"InquirySourceKeyId":_inquirySourceKeyId,
                 @"BuyReasonKeyId":_buyReasonKeyId,
                 @"Mobile":_mobile,
                 @"InquiryTradeTypeId":_inquiryTradeTypeId,
                 @"SalePriceFrom":_salePriceFrom,
                 @"SalePriceTo":_salePriceTo,
                 @"RentPriceFrom":_rentPriceFrom,
                 @"RentPriceTo":_rentPriceTo,
                 @"Tel":_tel,
                 @"IsMyPayChannelInquiry":_isMyPayChannelInquiry?_isMyPayChannelInquiry:@""
                 };
    }

    //其他地区
    return @{
             @"ContactName":_contactName,
             @"InquiryStatusKeyId":_inquiryStatusKeyId,
             @"ChannelInquiryKeyId":_channelInquiryKeyId,
             @"GenderKeyId":_genderKeyId,
             @"ContactTypeKeyId":_contactTypeKeyId,
             @"InquirySourceKeyId":_inquirySourceKeyId,
             @"BuyReasonKeyId":_buyReasonKeyId,
             @"Mobile":_mobile,
             @"InquiryTradeTypeId":_inquiryTradeTypeId,
             @"SalePriceFrom":_salePriceFrom,
             @"SalePriceTo":_salePriceTo,
             @"RentPriceFrom":_rentPriceFrom,
             @"RentPriceTo":_rentPriceTo,
             };
}


//转私客
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"customer/channel-to-inquiry";
    }
    return @"WebApiCustomer/turn_owner_inquiry";

}


- (Class)getRespClass
{
    return [TurnPrivateCustomerEntity class];
}


@end
