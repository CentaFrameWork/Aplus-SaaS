//
//  GetEditGoOutApi.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/16.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GetEditGoOutApi.h"
#import "EditGoOutEntity.h"

@implementation GetEditGoOutApi

- (NSDictionary *)getBody
{
    return @{
             
             @"keyid":_keyId,
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress])
    {
        return [NSString stringWithFormat:@"customer/gooutmessage?keyid=%@",_keyId];;
    }
    return [NSString stringWithFormat:@"WebApiCustomer/get_gooutmessage_edit_model?keyid=%@",_keyId];
}


- (Class)getRespClass
{
    return [EditGoOutEntity class];
}

@end
