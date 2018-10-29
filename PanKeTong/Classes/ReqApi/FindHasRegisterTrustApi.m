//
//  FindHasRegisterTrustApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/3/2.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FindHasRegisterTrustApi.h"
#import "FindRegisterTrustEntity.h"

@implementation FindHasRegisterTrustApi

- (NSDictionary *)getBody
{
    return @{
             @"PropertyKeyId":_propertyKeyId
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"external/exist-register-trust-property";
    }
    
    return @"WebApiAdvert/FindHasRegisterTrustPropertyById";
}


- (Class)getRespClass
{
    return [FindRegisterTrustEntity class];
}


@end
