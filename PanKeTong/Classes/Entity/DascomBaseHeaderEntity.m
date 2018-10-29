//
//  DascomBaseHeaderEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomBaseHeaderEntity.h"

@implementation DascomBaseHeaderEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    // resultCode; 返回码，失败时diagnostic为失败的诊断信息
    // diagnostic; 失败时的诊断信息，成功时空。
    return @{
             @"mResultCode":@"resultCode",
             @"mDiagnostic":@"diagnostic"};
}


@end
