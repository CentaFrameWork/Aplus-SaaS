//
//  APlusBaseApi.m
//  MCocoapods
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "APlusBaseApi.h"
#import "AgencyUserPermisstionUtil.h"
#import "NSString+MD5Additions.h"

@implementation APlusBaseApi

- (NSString *)getRootUrl
{
    return [NSString stringWithFormat:@"%@/api/",NewBaseUrl];
}

- (NSMutableDictionary *)getBaseBody
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                 @"IsMobileRequest":@"true"
                                                                                 }];
    return mdic;
}

- (int)getTimeOut
{
    return 10;
}

- (NSDictionary *)getBaseHeader
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *agencyToken = [AgencyUserPermisstionUtil getToken];
    
    if (agencyToken &&
        ![agencyToken isEqualToString:@""])
    {    
        [headerDic setValue:agencyToken forKey:@"token"];
        
    }
    
    NSString *staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    NSString *key = @"CYDAP_com-group";
    NSString *company = @"~Centa@";
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long unixTimeLong = (long)timestamp;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
    
    NSLog(@"unixTimeStr:%@",unixTimeStr);
    
    NSString *osign = [NSString stringWithFormat:@"%@%@%@%@",key,company,unixTimeStr,staffNo];
    NSString *sign = [osign md5];
    
    
    [headerDic setValue:app_Version forKey:@"ClientVer"];
    [headerDic setValue:@"iOS" forKey:@"platform"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    [headerDic setValue:FINAL_CORPORATION_KEY_ID forKey:@"corporationKeyId"];
    
    [headerDic setValue:staffNo forKey:@"staffno"];
    [headerDic setValue:unixTimeStr forKey:@"number"];
    [headerDic setValue:sign forKey:@"sign"];

    return (NSDictionary *)headerDic;
}

@end
