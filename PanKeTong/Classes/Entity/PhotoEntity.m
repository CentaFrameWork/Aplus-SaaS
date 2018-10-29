//
//  PhotoEntity.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PhotoEntity.h"

@implementation PhotoEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"isDefault":@"IsDefault",
             @"imgDescription":@"ImgDescription",
             @"createTime":@"CreateTime",
             @"postId":@"PostId",
             @"imgClassId":@"ImgClassId",
             @"imgPath":@"ImgPath",
             @"isPanorama":@"IsPanorama",
             @"photoType":@"PhotoType",
             @"isVideo":@"IsVideo",
             @"thumbPhotoPath":@"ThumbPhotoPath"};
}
@end
