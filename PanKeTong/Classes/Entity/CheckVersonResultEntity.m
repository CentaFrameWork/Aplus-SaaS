//
//  CheckVersonResultEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CheckVersonResultEntity.h"

@implementation CheckVersonResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"platform":@"Platform",
             @"clientVer":@"ClientVer",
             @"channer":@"Channel",
             @"forceUpdate":@"ForceUpdate",
             @"updateUrl":@"UpdateUrl",
             @"updateContent":@"UpdateContent",
             @"createTime":@"CreateTime"};
}

@end
