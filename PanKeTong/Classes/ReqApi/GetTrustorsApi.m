//
//  GetTrustorsApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetTrustorsApi.h"
#import "PropTrustorsInfoEntity.h"
#import "PropTrustorsInfoForShenZhenEntity.h"

@implementation GetTrustorsApi

- (NSDictionary *)getBody
{
    if([CityCodeVersion isTianJin]||[CityCodeVersion isBeiJing]||[CityCodeVersion isNanJing]||[CityCodeVersion isChongQing])
    {
        return @{
                 @"KeyId":_keyId,
                 };
    }
    else
    {
        return @{
                 @"UserKeyId" : _userKeyId,
                 @"DepartmentKeyId" : _departmentKeyId,
                 @"UserPhone" : _userPhone,
                 @"KeyId":_keyId,
                 };
    }
    
}

- (NSString *)getPath {
    
    
    return @"property/trustors";
    
}



- (Class)getRespClass {
    if([CityCodeVersion isTianJin]||[CityCodeVersion isBeiJing]||[CityCodeVersion isNanJing]
       ||[CityCodeVersion isChongQing])
    {
        return [PropTrustorsInfoEntity class];

    }
    else
    {
        return [PropTrustorsInfoForShenZhenEntity class];
//        return [PropTrustorsInfoEntity class];

    }
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
