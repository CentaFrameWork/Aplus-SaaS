//
//  HKBaseApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"
#import "CENTANETKeyChain.h"

@implementation HKBaseApi

- (NSString *)getRootUrl {
    
    return [[BaseApiDomainUtil getApiDomain] getHouseKeeperUrl];
}

- (int)getTimeOut {
    return 10;
}

- (NSDictionary *)getBaseHeader
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceUDID = [CENTANETKeyChain getAppOnlyIdentifierOnDevice];
    NSString * session=[[NSUserDefaults standardUserDefaults]stringForKey:HouseKeeperSession];
    NSString *companyCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    
    [headerDic setValue:deviceUDID forKey:@"Udid"];
    [headerDic setValue:app_Version forKey:@"ClientVer"];
    
    if (session &&
        ![session isEqualToString:@""]) {
        
        [headerDic setValue:session forKey:@"HKSession"];
    }
    
    if (companyCode &&
        ![companyCode isEqualToString:@""]) {
        
        [headerDic setValue:companyCode forKey:@"CompanyCode"];
   
    }
    
    [headerDic setValue:@"none" forKey:@"Channel"];
    [headerDic setValue:@"iOS" forKey:@"platform"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];
    
    return (NSDictionary *)headerDic;
}

@end
