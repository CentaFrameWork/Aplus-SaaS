//
//  AgencyUserInfoApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyUserInfoApi.h"
#import "DepartmentInfoEntity.h"

@implementation AgencyUserInfoApi

//请求体参数
- (NSDictionary *)getBody {
    
    
    NSDictionary *dict = @{@"UserNumbers":_staffNo};
    
    NSString *string = [dict JSONString];
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@":",
                                                              
                                                              
                                                              
                                                              kCFStringEncodingUTF8));
    return @{@"urlParams":encodedString};
    
}

- (NSString *)getPath
{
    
    return @"permission/user-permisstion";
}

- (Class)getRespClass
{
    return DepartmentInfoEntity.class;
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}


@end
