//
//  DascomSendCallNumberApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "DascomSendCallNumberApi.h"
#import "DascomReceiveNumberEntity.h"

@implementation DascomSendCallNumberApi

- (NSDictionary *)getBody
{
    NSDictionary *bodyParam;
    if ([CityCodeVersion isGuangZhou] || [CityCodeVersion isHuiZhou]) {
        // 广州增加房源编号
        bodyParam =  @{
                     @"calledNumber":_callNumber,
                     @"type":@"iPhone",
                     @"propertyID":_propertyId,
                     @"phoneID":_phoneID,
                     @"empID":_empID,
                     @"deptID":_deptID,
                     @"propertyNo":_propertyNo
                     };
    }
    else{
        bodyParam =  @{
                       @"calledNumber":_callNumber,
                       @"type":@"iPhone",
                       @"propertyID":_propertyId,
                       @"phoneID":_phoneID,
                       @"empID":_empID,
                       @"deptID":_deptID,
                       };
    }

    return @{@"body":bodyParam};
}

- (NSString *)getPath
{    
    if ([self isAplusPath]) {
        if ([CommonMethod isRequestNewApiAddress]) {
            return @"call-virtual-phone";
        }
        return @"dascom_call_phone";
    }
    
    return @"ReceiveNumber.do";
}

- (Class)getRespClass
{
    return [DascomReceiveNumberEntity class];
}

@end
