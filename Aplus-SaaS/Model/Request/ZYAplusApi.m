//
//  ZYAplusApi.m
//  Aplus-SaaS
//
//
//  Created by Admin on 2018/9/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ZYAplusApi.h"
#import "NSString+MD5Additions.h"
@implementation ZYAplusApi
- (NSString *)getRootUrl {
    return [NSString stringWithFormat:@"%@/api/",URL_SERVER];
}

- (NSMutableDictionary *)getBaseBody {
    
    return @{ @"IsMobileRequest":@"true" }.mutableCopy;
}

- (int)getTimeOut {
    return 30;
}

- (NSDictionary *)getBaseHeader {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *agencyToken = @"";
    
    if (agencyToken &&
        ![agencyToken isEqualToString:@""])
    {
        [headerDic setValue:agencyToken forKey:@"token"];
        
    }
    
    NSString *staffNo = @"";
    NSString *key = @"CYDAP_com-group";
    NSString *company = @"~Centa@";
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long unixTimeLong = (long)timestamp;
    NSString *unixTimeStr = [NSString stringWithFormat:@"%@",@(unixTimeLong)];
    
    
    
    NSString *osign = [NSString stringWithFormat:@"%@%@%@%@",key,company,unixTimeStr,staffNo];
    NSString *sign = [osign md5];
    
    
    [headerDic setValue:app_Version forKey:@"ClientVer"];
    [headerDic setValue:@"iOS" forKey:@"platform"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    
    [headerDic setValue:staffNo forKey:@"staffno"];
    [headerDic setValue:unixTimeStr forKey:@"number"];
    [headerDic setValue:sign forKey:@"sign"];
    
    return (NSDictionary *)headerDic;
}



@end
