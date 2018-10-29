//
//  UploadRealPhotoApi.m
//  PanKeTong
//
//  Created by 张旺 on 2017/12/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "UploadRealPhotoApi.h"

@implementation UploadRealPhotoApi

- (NSDictionary *)getBody
{
    return @{
             @"Photos":_photo,
             @"RealKeyId":_realKeyId,
             @"KeyId":_keyId
             };
}

- (NSString *)getPath
{
    return @"property/upload-real-survey-video";
}



- (Class)getRespClass
{
    return [AgencyBaseEntity class];
}

- (int)getTimeOut
{
    return 120;
}

@end
