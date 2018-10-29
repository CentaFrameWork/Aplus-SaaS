//
//  AllListEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/2/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AllListEntity.h"

@implementation AllListEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"goOutMessages":@"GoOutMessages",
                                          @"takingSees":@"TakingSees",
                                          @"takeSees":@"TakeSees",
//                                          @"alertEvents":@"AlertEvents",
                                          }];
}

//外出
+(NSValueTransformer *)goOutMessagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubGoOutListEntity class]];
}

//约看
+(NSValueTransformer *)takingSeesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubTakingSeeEntity class]];
}

//带看
+(NSValueTransformer *)takeSeesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubTakingSeeEntity class]];
}

//提醒
//+(NSValueTransformer *)alertEventsJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubAlertEventEntity class]];
//}


@end
