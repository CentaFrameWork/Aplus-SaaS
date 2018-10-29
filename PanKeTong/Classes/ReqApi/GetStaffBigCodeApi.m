//
//  GetStaffBigCodeApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/8/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GetStaffBigCodeApi.h"
#import "StaffBigCodeDetailEntity.h"

#define BigCodeUrl @"http://bj.centanet.com/page/v1/ajax/get400New.aspx?"

@implementation GetStaffBigCodeApi

- (NSString *)getRootUrl
{
    return BigCodeUrl;
}

- (NSString *)getPath
{
    return [NSString stringWithFormat:@"staffno=%@", _staffno];
}

- (Class)getRespClass
{
    return [StaffBigCodeDetailEntity class];
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

@end
