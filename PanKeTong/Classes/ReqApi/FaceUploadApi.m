//
//  FaceUploadApi.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceUploadApi.h"

@implementation FaceUploadApi

- (NSString *)getPath {
    return @"FaceUploadImgRequest";
}

- (NSDictionary *)getBody {
    return @{
             @"CompanyCode":_companyCode,
             @"StaffCode":_staffCode,
             @"AppCode":_appCode,
             @"CallOn":_callOn,
             @"Sign":_sign,
             @"Img":_img
             };
}

- (Class)getRespClass {
    return [FaceUploadEntity class];
}

@end
