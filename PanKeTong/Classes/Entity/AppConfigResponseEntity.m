//
//  AppConfigResponseEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/11.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AppConfigResponseEntity.h"

@implementation AppConfigResponseEntity


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"configId":@"ConfigId",
             @"parentId":@"ParentId",
             @"title":@"Title",
             @"mdescription":@"Description",
             @"iconUrl":@"IconUrl",
             @"jumpType":@"JumpType",
             @"jumpContent":@"JumpContent",
             @"homeShow":@"HomeShow"
             };
}


@end
