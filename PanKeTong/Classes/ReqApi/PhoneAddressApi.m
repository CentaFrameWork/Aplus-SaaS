//
//  PhoneAddressUtil.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "PhoneAddressApi.h"
#import "SinglePhoneAddressEntity.h"
#import "PhoneAddressEntity.h"

#define     Url             @"http://apis.baidu.com/chazhao/mobilesearch/phonesearch"   //手机号码归属地查询地址
#define     Apikey          @"d053e2ab47b3345269a1c4c5147f0e27"     //手机号码归属地查询key

@implementation PhoneAddressApi


- (NSString *)getRootUrl
{
    NSString *getStr = [NSString stringWithFormat:@"%@?",Url];
//    NSURL *url = [NSURL URLWithString:[getStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return getStr;
}


- (NSString *)getPath
{
   return [NSString stringWithFormat:@"phone=%@",_phones];
}


- (Class)getRespClass
{
    
    if([CommonMethod content:_phones containsWith:@","])
    {
        return [PhoneAddressEntity class];
    }
    
    return [SinglePhoneAddressEntity class];
}


- (int)getRequestMethod
{
    return RequestMethodGET;
}


- (NSDictionary *)getBaseHeader
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:Apikey forKey:@"apikey"];
    
    return (NSDictionary *)headerDic;
}

//- (NSDictionary *)getHeader
//{
//    return [NSDictionary dictionary];
//}

@end
