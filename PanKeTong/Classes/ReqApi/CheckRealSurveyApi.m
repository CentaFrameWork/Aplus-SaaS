//
//  CheckRealSurveyApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckRealSurveyApi.h"
#import "CheckRealSurveyEntity.h"

@implementation CheckRealSurveyApi


- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId
             };


}

//根据实勘ID获取 实勘下全部图片与实勘详情
- (NSString *)getPath {
    

    return @"property/byrealid-real-survey-photos";
    
}


- (Class)getRespClass
{
    return [CheckRealSurveyEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodGET;
}


@end
