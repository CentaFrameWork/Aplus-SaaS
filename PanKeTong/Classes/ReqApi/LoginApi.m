//
//  LoginApi.m
//  PanKeTong
//
//  Created by 王雅琦on 16/7/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "LoginApi.h"
#import "LoginEntity.h"

#import "DESUtil.h"

@implementation LoginApi

//请求体参数
- (NSDictionary *)getBody
{
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long unixTimeLong = (long)timestamp;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
    
    NSString * userNo = self.account;
    
    NSString * key = FINAL_KEY_SIGN;
    
    NSString * sign = [[NSString stringWithFormat:@"%@%@%@", userNo, unixTimeStr, key] md5];
    
    NSString * password = [DESUtil encrypWithText:_psd andKey:FINAL_KEY_DES];
    

    return @{
              @"DomainAccount" : _account,
              @"DomainPass": password,
              @"TimeStamp" : unixTimeStr,
              @"Sign" : sign,
              };
}

- (NSString *)getPath
{
    return @"Login";
}

- (Class)getRespClass
{
    return LoginEntity.class;
}
@end
