//
//  PropAllPhotoDetailEntity.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropAllPhotoDetailEntity.h"

@implementation PropAllPhotoDetailEntity

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"isDefault":@"IsDefault",
             @"imgDescription":@"ImgDescription",
             @"createTime":@"CreateTime",
             @"postId":@"PostId",
             @"imgClassId":@"ImgClassId",
             @"imgPath":@"ImgPath",
             };
}


@end
