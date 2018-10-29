//
//  SearchPropEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SearchPropEntity.h"

@implementation SearchPropEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    if ([CommonMethod isRequestNewApiAddress]) {
        return @{
                 @"propPrompts":@"PropertyParamHints",
                 };
    }
    
    return @{
             @"propPrompts":@"PropPrompts",
             };
}



+(NSValueTransformer *)propPromptsJSONTransformer
{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SearchPropDetailEntity class]];
}


@end
