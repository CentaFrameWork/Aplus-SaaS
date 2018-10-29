//
//  SSOBaseApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SSOBaseApi.h"

@implementation SSOBaseApi

- (NSString *)getRootUrl
{
    return [[BaseApiDomainUtil getApiDomain] getSSOUrl];
}



@end
