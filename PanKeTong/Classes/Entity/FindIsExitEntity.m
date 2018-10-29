//
//  FindIsExitEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FindIsExitEntity.h"

@implementation FindIsExitEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"keyId":@"KeyId",
                                          @"propertyKeyId":@"PropertyKeyId",
                                          @"status":@"Status",
                                          @"adNo":@"AdNo",
                                          @"postId":@"PostId"
                                          }];
}


@end
