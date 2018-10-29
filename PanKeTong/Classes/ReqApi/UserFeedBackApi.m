//
//  UserFeedBackApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "UserFeedBackApi.h"
#import "ConfirmSuccessEntity.h"

@implementation UserFeedBackApi


- (NSDictionary *)getBody
{
    return @{
             @"Content":_content
             };
}

//用户反馈意见
- (NSString *)getPath
{
    return @"Feedback";

}


- (Class)getRespClass
{
    return [ConfirmSuccessEntity class];
}


@end
