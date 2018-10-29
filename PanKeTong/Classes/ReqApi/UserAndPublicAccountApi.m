//
//  UserAndPublicAccountApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "UserAndPublicAccountApi.h"
#import "UserAndPublicAccountEntity.h"

@implementation UserAndPublicAccountApi


- (NSDictionary *)getBody
{
    return @{
             @"KeyWords":_keyWords,
             @"TopCount":_topCount
             };
}

- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @"common/user-public-acount-auto-complete";
    }
    return @"WebApiCommon/get_user_publicacount_auto_complete";
}


- (Class)getRespClass
{
    return [UserAndPublicAccountEntity class];
}



@end
