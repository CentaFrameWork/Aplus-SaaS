//
//  FollowMarkTopApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/7/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FollowMarkTopApi.h"

@implementation FollowMarkTopApi

- (NSDictionary *)getBody
{
    return @{
             @"PropertyFollowKeyIds" : _propertyFollowKeyIds,
             @"PropertyKeyId" : _propertyKeyId
             };
}

- (NSString *)getPath
{
    return @"property/follow-marktop";
}

- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

@end
