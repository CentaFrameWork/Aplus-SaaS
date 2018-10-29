//
//  RealSurveyEntity.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RealSurveyEntity.h"

@implementation RealSurveyEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"realSurveyPerson":@"RealSurveyPerson",
             @"realSurveyTime":@"RealSurveyTime",
             @"auditStatus":@"AuditStatus",
             @"photoCount":@"PhotoCount",
             @"keyId":@"KeyId",
             @"isVideo":@"IsVideo"
             };
}

@end
