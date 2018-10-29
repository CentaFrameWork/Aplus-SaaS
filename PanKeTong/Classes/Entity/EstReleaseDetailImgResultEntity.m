//
//  EstReleaseDetailImgResultEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstReleaseDetailImgResultEntity.h"

@implementation EstReleaseDetailImgResultEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postId":@"PostId",
             @"imgId":@"ImgId",
             @"imgPath":@"ImgPath",
             @"imgSrcExt":@"ImgSrcExt",
             @"imgDestExt":@"ImgDestExt",
             @"imgClassId":@"ImgClassId",
             @"imgTitle":@"ImgTitle",
             @"imgDescription":@"ImgDescription",
             @"imgOrder":@"ImgOrder",
             @"isDefault":@"IsDefault",
             @"createTime":@"CreateTime",
             @"updateTime":@"UpdateTime",
             };
}
@end
