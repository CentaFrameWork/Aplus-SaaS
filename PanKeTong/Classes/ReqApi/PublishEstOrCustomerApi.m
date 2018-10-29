//
//  PublishEstOrCustomerApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PublishEstOrCustomerApi.h"
#import "PublishEstEntity.h"
#import "PublishCusEntity.h"
#import "PublishCusDetailPageMsgEntity.h"
#import "PublishEstDetailPageMsgEntity.h"
//#define GetPublishEstateList 1//抢公盘
//#define GetPublishEstDetail 2 //公盘详情
//#define GetPublishCustomerList 3//抢公客
//#define GetPublishCustomerDetail 4//公客详情
//#define TransferPrivateInquiry 5//公客转私客


@implementation PublishEstOrCustomerApi
- (NSDictionary *)getBaseBody{
    return [NSMutableDictionary dictionary];;
}


- (NSDictionary *)getBody
{
    if (self.requestType == GetPublishEstateList || self.requestType == GetPublishCustomerList) {
        //抢公盘或公客
        return nil;
    }else if(self.requestType == GetPublishEstDetail) {
        //公盘详情
        return @{
                 @"KeyId":_keyId,
                 @"IsMobileRequest":@"true"
                 };

    }else if (self.requestType == GetPublishCustomerDetail){
        //公客详情
        return @{
                 @"KeyId":_keyId,
                 @"ContactName":_contactName?_contactName:@"",
                 @"IsMobileRequest":@"true"
                 };

    }
    //公客转私客
    return @{
             @"InquiryKeyId":_inquiryKeyId,
             @"IsMobileRequest":@"true"
             };


}

- (NSString *)getPath
{
    if (self.requestType == GetPublishEstateList)
    {
        // 公盘池
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"property/public-estate";
        }
        return @"WebApiProperty/public_estate";

    }
    else if (self.requestType == GetPublishEstDetail)
    {
        // 公盘详情
        if ([CommonMethod isRequestFinalApiAddress])
        {
            return @"property/public-estate-detail";
        }
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"property/public-estate_detail";
        }
        
        return @"WebApiProperty/public_estate_detail";

    }
    else if (self.requestType == GetPublishCustomerList)
    {
        // 公客池
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"customer/public-customers";
        }
        
        return @"WebApiCustomer/public_customer";

    }
    else if (self.requestType == GetPublishCustomerDetail)
    {
        // 公客详情
        if ([CommonMethod isRequestNewApiAddress])
        {
            return @"customer/public-customer";
        }
        
        return @"WebApiCustomer/public_customer_detail";

    }

    if ([CommonMethod isRequestNewApiAddress])
    {
        return @"customer/public-to-private";   // 公客转私客
    }
    return @"WebApiCustomer/transfer_private_inquiry";
}


- (Class)getRespClass
{
    if (self.requestType == GetPublishEstateList) {
        return [PublishEstEntity class];//公盘池

    }else if (self.requestType == GetPublishEstDetail){
        return [PublishEstDetailPageMsgEntity class];//公盘详情

    }else if (self.requestType == GetPublishCustomerList){
        return [PublishCusEntity class];//公客池

    }else if (self.requestType == GetPublishCustomerDetail){
        return [PublishCusDetailPageMsgEntity class];//公客详情

    }
    return [AgencyBaseEntity class];//公客转私客

}



@end
