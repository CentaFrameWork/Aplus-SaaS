//
//  GetAllRealSurveyPhotoApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetAllRealSurveyPhotoApi.h"
#import "CheckRealSurveyEntity.h"

@implementation GetAllRealSurveyPhotoApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             };
}

- (NSString *)getPath {
    

    return @"property/real-survey-photos";
    
}


- (Class)getRespClass
{
    return [CheckRealSurveyEntity class];
}
- (int)getRequestMethod {
    
    return RequestMethodGET;
}


@end
