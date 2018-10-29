//
//  PropAllPhotoDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PropAllPhotoDetailEntity : AgencyBaseEntity

@property (nonatomic,assign) BOOL isDefault;   //封面图标记
@property (nonatomic,strong) NSString *imgDescription;  //图片描述
@property (nonatomic,strong) NSString *createTime;  //创建时间
@property (nonatomic,strong) NSString *postId;  //图片所属的原始业务对象keyId
@property (nonatomic,strong) NSString *imgClassId;  //图片id
@property (nonatomic,strong) NSString *imgPath; //图片地址

@end
