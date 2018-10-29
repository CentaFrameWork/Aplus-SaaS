//
//  PhotoEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PhotoEntity : SubBaseEntity

/*
 "IsDefault": true,
 "ImgDescription": "sample string 5",
 "CreateTime": "2016-07-18T10:01:45.0971151+08:00",
 "PostId": "fa6f4ec1-4136-4176-8c7b-1b3e6939318e",
 "ImgClassId": 3,
 "ImgPath": "sample string 4"
 "PhotoType": "sample string 5"
 */

@property (nonatomic, assign) BOOL isDefault;// 是否是封面
@property (nonatomic, copy) NSString *imgDescription;// 图片描述
@property (nonatomic, copy) NSString *createTime;// 创建时间
@property (nonatomic, copy) NSString *postId;// 图片所属的原始业务对象KeyId
@property (nonatomic, strong) NSNumber *imgClassId;
@property (nonatomic, copy) NSString *imgPath;// 图片地址
@property (nonatomic, copy) NSString *isPanorama;// 是否为全景图
@property (nonatomic, copy) NSString *photoType;// 图片类型
@property (nonatomic, copy) NSString *isVideo;  //是否是视频
@property (nonatomic, copy) NSString *thumbPhotoPath;       // 视频第一帧

@end
