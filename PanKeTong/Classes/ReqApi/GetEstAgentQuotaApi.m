//
//  GetEstAgentQuotaApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetEstAgentQuotaApi.h"
#import "AgentQuotaEntity.h"

@implementation GetEstAgentQuotaApi

- (NSDictionary *)getBody
{
    return nil;
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"advert/online-permissions";
    }
    return @"WebApiAdvert/online-permissions";

}


- (Class)getRespClass
{
    return [AgentQuotaEntity class];
}


@end
