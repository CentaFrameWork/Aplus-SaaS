//
//  RealSurveyOperationApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyOperationApi.h"
#import "RealSurveyOperationEntity.h"

@implementation RealSurveyOperationApi

- (NSDictionary *)getBody
{
    return @{
             @"AuditStatus":_auditStatus,
             @"KeyId":_keyId
             };
}

/// 实勘审核审核操作
- (NSString *)getPath
{
    if ([CommonMethod isRequestFinalApiAddress])
    {
        return @"property/operate-real-survey-detail";
    }
    
    return @"WebApiProperty/property-detail-real-survey-oper";
}


- (Class)getRespClass
{
    return [RealSurveyOperationEntity class];
}


@end
