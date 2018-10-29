//
//  DascomBaseApi.m
//  PanKeTong
//
//  Created by 中原管家 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "DascomBaseApi.h"
#import "DascomDefine.h"
#import "NSString+MD5Additions.h"

@implementation DascomBaseApi

- (NSString *)getRootUrl
{
    return [[BaseApiDomainUtil getApiDomain] getDascomUrl];
}

- (NSMutableDictionary *)getBaseBody
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                 @"header":[self getHeaderParamWidthEmpNo:_empNo]
                                                                                 }];
    return mdic;
}


- (void)setEmpNo:(NSString *)empNo
{
    if (_empNo != empNo)
    {
        _empNo = empNo;
    }
}

- (NSMutableDictionary *)getBaseHeader
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
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
    
    [headerDic setValue:staffNo forKey:@"staffno"];
    [headerDic setValue:unixTimeStr forKey:@"number"];
    [headerDic setValue:sign forKey:@"sign"];
    
    return headerDic;
}

- (NSDictionary *)getHeaderParamWidthEmpNo:(NSString *)empNo
{
    NSString *strTemp = [NSString stringWithFormat:@"%@%@", empNo,DAS_CALL_KEY];
    NSString *md5Str = [strTemp md5];
    
    NSDictionary *headerParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                 empNo,@"empNo",
                                 md5Str,@"token",
                                 nil];
    
    return headerParam;
}


- (BOOL)isAplusPath
{
    NSString *rootUrl = [self getRootUrl];

    if ([CommonMethod isRequestNewApiAddress])
    {
        if ([rootUrl contains:@"center"])
        {
            return YES;
        }
    }

    if ([rootUrl contains:@"Dascom"]||[rootUrl contains:@"WebApiCenter"])
    {
        return YES;
    }
    
    return NO;
}

@end
