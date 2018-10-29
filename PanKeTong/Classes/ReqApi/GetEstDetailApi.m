//
//  GetEstDetailApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetEstDetailApi.h"
#import "EstReleaseDetailEntity.h"

@implementation GetEstDetailApi

- (NSDictionary *)getBody
{
    NSString *advertKeyId = @"AdvertKeyid";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        advertKeyId = @"AdvertKeyId";
    }
    
    return @{
             advertKeyId:_keyId?_keyId:@""
             };
}

/// 放盘管理详情
- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"advert/property-detail";
    }
    return @"WebApiAdvert/advert-propertys-detail";

}


- (Class)getRespClass
{
    return [EstReleaseDetailEntity class];
}


@end
