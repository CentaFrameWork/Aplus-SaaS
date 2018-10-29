//
//  AlertEventEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AlertEventEntity.h"
#import "SubAlertEventEntity.h"

@implementation AlertEventEntity
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"alertEvents":@"AlertEvents"
                                          }];
}


//提醒
+(NSValueTransformer *)alertEventsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubAlertEventEntity class]];
}

@end
