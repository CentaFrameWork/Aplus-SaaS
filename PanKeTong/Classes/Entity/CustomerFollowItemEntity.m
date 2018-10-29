//
//  CustomerFollowItemEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerFollowItemEntity.h"

@implementation CustomerFollowItemEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"followPerson":@"FollowPerson",
             @"followType":@"FollowType",
             @"followDate":@"FollowDate",
             @"followContent":@"FollowContent"
             };
}

@end
