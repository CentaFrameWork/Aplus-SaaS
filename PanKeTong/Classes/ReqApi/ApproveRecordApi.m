//
//  ApproveRecordApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ApproveRecordApi.h"

@implementation ApproveRecordApi

- (NSDictionary *)getBody
{
    NSDictionary *paraDic;

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_keyId,@"KeyId",_regTrustsAuditStatus,@"RegTrustsAuditStatus", nil];

    if (_isCredentials != nil) {
        [dic addEntriesFromDictionary:@{@"IsCredentials":_isCredentials}];
    }
    if (_reject != nil) {
        [dic addEntriesFromDictionary:@{@"Reject":_reject}];
    }

    paraDic = dic;
    dic = nil;
    
    return paraDic;
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/register-trusts-approve";
    }
    return @"WebApiProperty/registertrusts-approve";
}


- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}


@end
