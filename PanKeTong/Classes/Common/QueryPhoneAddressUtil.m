//
//  QueryPhoneAddressUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/14.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "QueryPhoneAddressUtil.h"
#import "PhoneAddressApi.h"

#define     Url             @"http://apis.baidu.com/chazhao/mobilesearch/phonesearch"   //手机号码归属地查询地址
#define     Apikey          @"d053e2ab47b3345269a1c4c5147f0e27"     //手机号码归属地查询key
#define     PhoneSingle     6200        //单个手机号查询归属地
#define     PhoneMuti       6201        //多个手机号查询归属地

@implementation QueryPhoneAddressUtil

static QueryPhoneAddressUtil *queryPhoneAddressUtil;
static RequestManager *manager;

+ (QueryPhoneAddressUtil *)shareQueryPhoneAddressUtil
{
    if(queryPhoneAddressUtil)
    {
        return queryPhoneAddressUtil;
    }
    
    queryPhoneAddressUtil = [[self alloc]init];
    queryPhoneAddressUtil.urlStr = Url;
    manager = [RequestManager initManagerWithDelegate:queryPhoneAddressUtil];
    
    return queryPhoneAddressUtil;
}

#pragma mark - RequestQueryPhoneAddressMethod
- (void)requestQueryPhoneAddressWithPhones:(NSString *)phones;
{
    PhoneAddressApi *addressApi = [PhoneAddressApi new];
    addressApi.phones = phones;
    [manager sendRequest:addressApi];
}


+ (NSString *)extractPhoneFromChannelCall:(ChannelCallEntity *)entity
{
    NSMutableString *result = [[NSMutableString alloc]init];
    
    NSInteger count = entity.mresult.count;
    if(count > 10){
        count = 10;
    }
    
    for (int i = 0; i < count; i++) {
        ChannelCallModelEntity *channelCallEntity = entity.mresult[i];
        [result appendString:channelCallEntity.mphone];
        if(i < count-1){
            [result appendString:@","];
        }
    }
    
    return result;
}


- (void)respSuc:(id)data andRespClass:(id)cls
{
//    NSDictionary *dataDic = (NSDictionary *)data;
    
    if ([cls isEqual:[SinglePhoneAddressEntity class]])
    {
        SinglePhoneAddressEntity *singlePhoneAddressEntity = [DataConvert convertDic:data toEntity:cls];
            
        if (self.delegate && [self.delegate respondsToSelector:@selector(queryPhoneAddressResult:)]) {
            
            NSArray *arr = [[NSArray alloc]initWithObjects:singlePhoneAddressEntity.data, nil];
            
            if(singlePhoneAddressEntity.error == 0)
            {
                [self.delegate queryPhoneAddressResult:arr];
            }
            else
            {
//                NSLog(singlePhoneAddressEntity.msg);
            }
        }
    }
    else if([cls isEqual:[PhoneAddressEntity class]])
    {
        PhoneAddressEntity *phoneAddress = [DataConvert convertDic:data toEntity:cls];
        if (self.delegate && [self.delegate respondsToSelector:@selector(queryPhoneAddressResult:)]) {
            
            if(phoneAddress.error == 0){
                [self.delegate queryPhoneAddressResult:phoneAddress.data];
            }else{
//                NSLog(phoneAddress.msg);
            }
        }

    }

    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    
}


@end
