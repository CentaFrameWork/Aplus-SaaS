//
//  GetTrustorslist.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetTrustorslistApi.h"
#import "GetTrustorListEntity.h"

@implementation GetTrustorslistApi


- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };
}



- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"property/trustors";
    }
    return @"WebApiProperty/get_trustorslist";
}


- (Class)getRespClass
{
    return [GetTrustorListEntity class];
}

@end
