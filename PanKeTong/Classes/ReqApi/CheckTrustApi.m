//
//  CheckTrustApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/31.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckTrustApi.h"

@implementation CheckTrustApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/entrust-path";
    }
    return @"WebApiProperty/property-entrust-for-keyid-path";
}


- (Class)getRespClass
{
    return [CheckTrustEntity class];
}


@end
