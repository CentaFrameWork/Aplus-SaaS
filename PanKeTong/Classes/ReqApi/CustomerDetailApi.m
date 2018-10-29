//
//  CustomerDetailApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CustomerDetailApi.h"
#import "CustomerDetailEntity.h"

@implementation CustomerDetailApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             @"ContactName":_contactName
             };
}

/// 客户详情
- (NSString *)getPath {
    
 
    return @"customer/detail";
    
}

- (Class)getRespClass
{
    return [CustomerDetailEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
