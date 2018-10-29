//
//  OnlyTrustApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "OnlyTrustApi.h"
#import "PropOnlyTrustListEntity.h"

@implementation OnlyTrustApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };
}


- (NSString *)getPath {
    
    
    return @"property/only-trusts";

}


- (Class)getRespClass
{
    return [PropOnlyTrustListEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}


@end
