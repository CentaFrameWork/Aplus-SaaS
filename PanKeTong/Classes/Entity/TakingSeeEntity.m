//
//  TakingSeeEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/6.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakingSeeEntity.h"
#import "SubTakingSeeEntity.h"

@implementation TakingSeeEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"recordCount":@"RecordCount",
                                          @"takingSees":@"TakingSees",
                                          @"takeSees":@"TakeSees"
                                          }];
}

+(NSValueTransformer *)takingSeesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubTakingSeeEntity class]];
}

+(NSValueTransformer *)takeSeesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SubTakingSeeEntity class]];
}

@end
