//
//  CheckAppVersonApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/2.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckAppVersonApi.h"
#import "CheckVersonEntity.h"

@implementation CheckAppVersonApi

- (NSDictionary *)getBody{
    return nil;
}

//检查用户版本
- (NSString *)getPath
{
    return @"AppVersion?";
}


- (Class)getRespClass
{
    return [CheckVersonEntity class];

}

- (int)getRequestMethod
{
    return RequestMethodGET;
}


@end
