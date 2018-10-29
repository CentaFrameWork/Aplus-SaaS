//
//  GoOutListEntity.m
//  PanKeTong
//
//  Created by 张旺 on 17/1/6.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "GoOutListEntity.h"
#import "SubGoOutListEntity.h"

@implementation GoOutListEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"recordCount":@"RecordCount",
                                          @"goOutMessages":@"GoOutMessages",
                                          }];
}

+(NSValueTransformer *)goOutMessagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubGoOutListEntity class]];
}

@end
