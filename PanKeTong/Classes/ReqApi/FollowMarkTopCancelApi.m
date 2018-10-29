//
//  FollowMarkTopCancelApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/7/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FollowMarkTopCancelApi.h"

@implementation FollowMarkTopCancelApi

- (NSDictionary *)getBody
{
    return @{
             @"PropertyFollowKeyId" : _propertyFollowKeyId,
             @"PropertyKeyId" : _propertyKeyId
             };
}

- (NSString *)getPath
{
    return @"property/follow-marktop-cancel";
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
