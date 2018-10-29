//
//  GetAdApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/13.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetAdApi.h"
#import "GetAdEntity.h"

@implementation GetAdApi

- (NSDictionary *)getBody
{
    return nil;
}

//- (NSString *)getRootUrl{
//    return @"http://10.4.18.111/apitest/api/";
//}


- (NSString *)getPath
{
    return @"StartAnimation";
}


- (Class)getRespClass
{
    return [GetAdEntity class];
}


- (int)getRequestMethod
{
    return RequestMethodGET;
}


@end
