//
//  GetGoodRateApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GetGoodRateApi.h"
#import "GoodRateEntity.h"

#define GoodRateUrl @"http://10.4.18.82/core/010/json/metadata?op=GetGoodEvaluationRequest"

@implementation GetGoodRateApi

- (NSString *)getRootUrl
{
    return GoodRateUrl;
}

- (Class)getRespClass
{
    return [GoodRateEntity class];
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

@end
