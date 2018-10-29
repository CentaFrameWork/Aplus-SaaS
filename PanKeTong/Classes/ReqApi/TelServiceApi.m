//
//  TelServiceApi.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/11/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TelServiceApi.h"
#import "HQCallNumberEntity.h"

@implementation TelServiceApi

- (NSString *)getRootUrl
{
    return @"http://10.68.2.224/";
}

- (NSString *)getPath
{
    return @"TelService/";
}


- (NSDictionary *)getBody
{
    return @{
             @"StaffNo":_staffNo,
             @"Tel1":_tel1,
             @"Tel2":_tel2,
             };
}



- (Class)getRespClass
{
    return [HQCallNumberEntity class];
}

@end
