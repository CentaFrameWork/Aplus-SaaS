//
//  RongCloudBaseApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RongCloudBaseApi.h"


@implementation RongCloudBaseApi

- (NSString *)getRootUrl
{
    return RONG_CLOUD_URL;
}



- (NSDictionary *)getBaseHeader
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    
    //随机数
    int nonceNum = arc4random() % 100;
    NSString *nonceStr = [NSString stringWithFormat:@"%@",@(nonceNum)];
    
    //时间戳
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timestamp = [nowDate timeIntervalSince1970];
    long timesTampLong = (long)timestamp;
    NSString *timestampStr = [NSString stringWithFormat:@"%@",@(timesTampLong)];
    
    //数据签名 MD5/SHA1
    NSString *signatureStr = [CommonMethod getSHA1WithStringWithSecret:RongCloudAppSecret
                                                              andNonce:nonceStr
                                                          andTimestamp:timestampStr];
    
    //添加App Key、随机数、时间戳、数据签名 到requestHeader
    
    [headerDic setValue:RongCloudAppKey forKey:@"App-Key"];
    [headerDic setValue:nonceStr forKey:@"Nonce"];
    [headerDic setValue:timestampStr forKey:@"Timestamp"];
    [headerDic setValue:signatureStr forKey:@"Signature"];
    [headerDic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"content-type"];
    [headerDic setValue:@"iPhone" forKey:@"User-Agent"];

    return (NSDictionary *)headerDic;
}


@end
