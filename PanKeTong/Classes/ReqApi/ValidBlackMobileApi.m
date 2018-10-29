//
//  ValidBlackMobileApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ValidBlackMobileApi.h"
#import "TurnPrivateCustomerEntity.h"

@implementation ValidBlackMobileApi

- (NSDictionary *)getBody
{
    return @{
             @"Mobile":_mobile,
             };
    }


//验证手机黑名单
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"customer/validate-black-list";
    }
    return @"WebApiCustomer/validate_black_mobile";

}


- (Class)getRespClass
{
    return [TurnPrivateCustomerEntity class];
}


@end
