//
//  FaceSearchApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceSearchApi.h"

@implementation FaceSearchApi

- (NSString *)getPath {
    return @"FaceExistsImageRequest";
}

- (NSDictionary *)getBody {
    return @{
             @"CompanyCode":_companyCode,
             @"StaffCode":_staffCode,
             @"AppCode":_appCode,
             @"CallOn":_callOn,
             @"Sign":_sign,
             };
}

- (Class)getRespClass {
    return [FaceUploadEntity class];
}

@end
