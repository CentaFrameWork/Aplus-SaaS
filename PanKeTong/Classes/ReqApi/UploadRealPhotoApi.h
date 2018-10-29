//
//  UploadRealPhotoApi.h
//  PanKeTong
//
//  Created by 张旺 on 2017/12/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

// 上传实勘到A+
@interface UploadRealPhotoApi : APlusBaseApi

@property (nonatomic, copy) NSString *realKeyId;
@property (nonatomic, strong) NSArray  *photo;
@property (nonatomic, copy) NSString *keyId;

@end
