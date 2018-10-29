//
//  PropKeysApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PropKeysApi.h"
#import "PropKeyListEntity.h"

@implementation PropKeysApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             };
}

- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/keys";
    }
    return @"WebApiProperty/get_key";
}



- (Class)getRespClass
{
    return [PropKeyListEntity class];
}

@end
