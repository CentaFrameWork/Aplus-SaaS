//
//  RealListApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealListApi.h"
#import "RealSurveyListEntity.h"

@implementation RealListApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             };
}

- (NSString *)getPath {
    
    
    return @"property/real-surveys";
    
}

- (Class)getRespClass {
    return [RealSurveyListEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}

@end
