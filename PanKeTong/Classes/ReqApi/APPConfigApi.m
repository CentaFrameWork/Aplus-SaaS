//
//  APPConfigApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/4.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APPConfigApi.h"

@implementation APPConfigApi

//请求体参数
- (NSDictionary *)getBody
{
    return @{
             
             @"location":_location == nil?@"":_location,
//             @"top":_top == nil?@"100":_top,

             };
}

- (NSString *)getPath
{
    return @"AppConfigRelation";
}


- (Class)getRespClass
{
    return APPConfigEntity.class;
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}


@end
