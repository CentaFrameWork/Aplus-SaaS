//
//  AllTakeSeesApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/3.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AllTakeSeesApi.h"

@implementation AllTakeSeesApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };
}

- (NSString *)getPath {
    return @"property/all-takesee";
}

- (Class)getRespClass
{
    return [TakingSeeEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}
@end
