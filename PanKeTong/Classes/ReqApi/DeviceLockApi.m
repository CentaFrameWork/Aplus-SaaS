//
//  DeviceLock.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "DeviceLockApi.h"
#import "ConfirmSuccessEntity.h"

@implementation DeviceLockApi


//请求体参数
- (NSDictionary *)getBody
{
    return @{};
}

- (NSString *)getPath
{
    return @"DeviceLock" ;
}


- (Class)getRespClass
{
    return [ConfirmSuccessEntity class];
}

@end
