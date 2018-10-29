//
//  SimApiDomainUtil.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/16.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SimApiDomainUtil.h"

@implementation SimApiDomainUtil

static NSString *APlusDomain;
static NSString *ImageServerUrl;

/// 管家url (决定环境)
- (NSString *)getHouseKeeperUrl
{
//    return @"http://zygj.centanet.com/api/api/";      // 正式环境
    return NewHousekeeperUrl;         // 从测试环境读取域名配置信息
}

- (NSString *)faceRecogUrl
{
    return @"https://sso.centanet.com/ssoservice/json/reply/";
}

#pragma mark - 后台可配置Url
/// A＋ url
- (NSString *)getAPlusDomainUrl
{
    // 天津
    return NewBaseUrl;
}

/// A+图片服务地址
- (NSString *)getImageServerUrl
{
    // 天津
    return @"https://tjstatic.centaline.com.cn:442/image/upload2/";
}

- (NSString *)getTQTOKEN
{
    return TQ_TEST_TOKEN;
}

@end
