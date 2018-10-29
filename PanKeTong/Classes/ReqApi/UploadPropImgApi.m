//
//  UploadPropImgApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "UploadPropImgApi.h"

@implementation UploadPropImgApi

- (NSDictionary *)getBody
{
    return @{
             @"KeyId":_keyId,
             @"Photos":_photo,
             @"DecorationSituationKeyId":_decorationSituationKeyId == nil?@"":_decorationSituationKeyId
             };
}

- (NSString *)getPath {
    
   return @"property/upload-real-survey";
    
    
}



- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}


@end
