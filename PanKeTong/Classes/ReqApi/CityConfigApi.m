//
//  CityConfigApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CityConfigApi.h"

@implementation CityConfigApi


//请求体参数
- (NSDictionary *)getBody
{
    return @{
             @"configType":_configType == nil?@"2":_configType,
             @"length":_length == nil?@"20":_length,
             };
}

- (NSString *)getPath
{
    return @"HomeConfig";
}


- (Class)getRespClass
{
    return CityConfigEntity.class;
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

@end
