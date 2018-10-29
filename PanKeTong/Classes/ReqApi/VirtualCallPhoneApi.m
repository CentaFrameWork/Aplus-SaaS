//
//  VirtualCallPhoneApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/11/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "VirtualCallPhoneApi.h"
#import "HQCallNumberEntity.h"

@implementation VirtualCallPhoneApi

- (NSDictionary *)getBody
{
    return @{
             @"StaffNo":_staffNo,
             @"Tel1":_tel1,
             @"Tel2":_tel2,
             @"KeyId":_keyId
             };
}



- (NSString *)getPath
{
    return @"WebApiProperty/virtual_call_phone";
}


- (Class)getRespClass
{
    return [HQCallNumberEntity class];
}


@end
