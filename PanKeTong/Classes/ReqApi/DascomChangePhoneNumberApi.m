//
//  DascomChangePhoneNumberApi.m
//  PanKeTong
//
//  Created by 中原管家 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "DascomChangePhoneNumberApi.h"
#import "DascomGetPhoneDicBodyEntity.h"

@implementation DascomChangePhoneNumberApi

- (NSDictionary *)getBody
{
    NSDictionary *bodyParam = @{
                                @"msisdn":_phoneNumber
                                };
    
    return @{@"body":bodyParam};
}

//- (NSString *)getRootUrl{
//    return @"http://122.194.5.245/SSMN_ZY_Server/";
//}



- (NSString *)getPath
{
    if ([self isAplusPath])
    {
        if ([CommonMethod isRequestNewApiAddress]) {
            return @"modify-virtual-phone";
        }
        return @"dascom_change_number";
    }
    
    return  @"ChangeMsisdn.do";
}

- (Class)getRespClass
{
    return [DascomGetPhoneDicBodyEntity class];
}


@end
