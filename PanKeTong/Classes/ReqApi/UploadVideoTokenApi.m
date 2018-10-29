//
//  UploadVideoTokenApi.m
//  PanKeTong
//
//  Created by 张旺 on 2017/12/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "UploadVideoTokenApi.h"
#import "UploadVideoTokenEntity.h"

@implementation UploadVideoTokenApi

- (NSString *)getPath
{
    return @"property/qiniu-up-certificate";//@"property/qiniu-up-token";
}

- (Class)getRespClass
{
    return [UploadVideoTokenEntity class];
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

@end
