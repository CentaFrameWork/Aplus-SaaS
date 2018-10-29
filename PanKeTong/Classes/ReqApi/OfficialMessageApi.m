//
//  OfficialMessageApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "OfficialMessageApi.h"
#import "OfficialMessageEntity.h"

@implementation OfficialMessageApi

- (NSDictionary *)getBody
{
    return @{
             @"startIndex":_startIndex?_startIndex:@"0",
             @"length":_length
             };

}


- (NSString *)getPath
{
    return @"Info";
}


- (Class)getRespClass
{
    return [OfficialMessageEntity class];
}


- (int)getRequestMethod
{
    return RequestMethodGET;
}


@end
