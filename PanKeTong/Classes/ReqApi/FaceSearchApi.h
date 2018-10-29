//
//  FaceSearchApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceBaseApi.h"
#import "FaceUploadEntity.h"

/// 查询是否上传过照片
@interface FaceSearchApi : FaceBaseApi

@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *staffCode;
@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *callOn;
@property (nonatomic, copy) NSString *sign;

@end
