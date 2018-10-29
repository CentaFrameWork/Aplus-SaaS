//
//  ApiDomainUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ApiDomainUtil.h"

@implementation ApiDomainUtil

static NSString *APlusDomain;
static NSString *ImageServerUrl;

/// 管家url (决定环境)
- (NSString *)getHouseKeeperUrl
{
    return NewHousekeeperUrl;  // 从测试环境读取域名配置信息

    
}

- (NSString *)faceRecogUrl
{
    return @"http://10.4.18.113:8086/ssoservicetest/json/reply/";
}

#pragma mark - 后台可配置Urlsh
/// A＋ url
- (NSString *)getAPlusDomainUrl
{

    return NewBaseUrl;
}

- (NSString *)getTQTOKEN
{
    return TQ_TEST_TOKEN;
}

@end
