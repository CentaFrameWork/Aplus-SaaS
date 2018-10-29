//
//  FaceRecogApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceRecogApi.h"

@implementation FaceRecogApi

- (NSString *)getPath {
    return @"FaceRecognitionRequest";
}

- (NSDictionary *)getBody {
    return @{
             @"CompanyCode":_companyCode,
             @"StaffCode":_staffCode,
             @"AppCode":_appCode,
             @"CallOn":_callOn,
             @"Sign":_sign,
             @"ImageBest":_imageBest,
             @"ImageEnv":_imageEnv,
             @"Delta":_delta,
             };
}

- (Class)getRespClass {
    return [FaceRecogEntity class];
}

@end
