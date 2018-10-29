//
//  GetPropDetailApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetPropDetailApi.h"
#import "PropPageDetailEntity.h"

@implementation GetPropDetailApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_propKeyId,
             };
}

- (NSString *)getPath {
   

    return @"property/details";
  
}

- (Class)getRespClass
{
    return [PropPageDetailEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
