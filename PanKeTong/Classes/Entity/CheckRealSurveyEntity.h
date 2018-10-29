//
//  CheckRealSurveyEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//-------查看实勘页面的实体

#import "AgencyBaseEntity.h"
#import "PhotoEntity.h"

@interface CheckRealSurveyEntity : AgencyBaseEntity
/*
 {
 "RealSurveyComment": "sample string 1",
 "PropertyRoomTypePhotoIsHav":YES,//广州
 "Photos": [
             {
             "IsDefault": true,
             "ImgDescription": "sample string 5",
             "CreateTime": "2016-07-18T10:01:45.0971151+08:00",
             "PostId": "fa6f4ec1-4136-4176-8c7b-1b3e6939318e",
             "ImgClassId": 3,
             "ImgPath": "sample string 4"
             },
             {
             "IsDefault": true,
             "ImgDescription": "sample string 5",
             "CreateTime": "2016-07-18T10:01:45.0971151+08:00",
             "PostId": "fa6f4ec1-4136-4176-8c7b-1b3e6939318e",
             "ImgClassId": 3,
             "ImgPath": "sample string 4"
             },
             {
             "IsDefault": true,
             "ImgDescription": "sample string 5",
             "CreateTime": "2016-07-18T10:01:45.0971151+08:00",
             "PostId": "fa6f4ec1-4136-4176-8c7b-1b3e6939318e",
             "ImgClassId": 3,
             "ImgPath": "sample string 4"
             }
  ],
 "Flag": true,
 "ErrorMsg": "sample string 3",
 "RunTime": "sample string 4"
 }
 */

@property (nonatomic,copy)NSString *realSurveyComment;//实勘点评
@property (nonatomic,strong)NSArray *photos;//图片数组
@property (nonatomic,assign)BOOL propertyRoomTypePhotoIsHav;//是否有小区图或者户型图

@property (nonatomic, copy)NSString *decorationSituation; // 装修情况

@end
