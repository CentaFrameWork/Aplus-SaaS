//
//  GetStaffMsgApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/10.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetStaffMsgApi.h"
#import "StaffInfoEntity.h"

@implementation GetStaffMsgApi

- (NSDictionary *)getBody
{
    return @{
             @"staffNo":_staffNo,
             @"cityCode":_cityCode
             };
}


- (NSString *)getPath
{
    return @"Staff";

}


- (Class)getRespClass
{
    return [StaffInfoEntity class];
}


- (int)getRequestMethod
{
    return RequestMethodGET;
}



@end
