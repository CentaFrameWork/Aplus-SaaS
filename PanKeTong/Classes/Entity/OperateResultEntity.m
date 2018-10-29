//
//  OperateResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "OperateResultEntity.h"

@implementation OperateResultEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"operateResult":@"OperateResult",
             @"faildReason":@"FaildReason",
             };
}

@end
