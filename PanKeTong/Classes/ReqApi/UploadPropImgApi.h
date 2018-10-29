//
//  UploadPropImgApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 上传图片到A+
@interface UploadPropImgApi : APlusBaseApi

@property (nonatomic, copy) NSString *keyId;
@property (nonatomic, strong) NSArray  *photo;
@property (nonatomic, copy) NSString *decorationSituationKeyId;

@end
