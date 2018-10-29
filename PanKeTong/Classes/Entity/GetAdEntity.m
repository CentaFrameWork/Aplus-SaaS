//
//  GetAdEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/10/13.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GetAdEntity.h"

@implementation GetAdEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  [self getBaseFieldWithOthers:@{@"result":@"Result"}];

}

@end
