//
//  CheckRealProtectedEntity.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckRealProtectedEntity.h"

@implementation CheckRealProtectedEntity
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [self getBaseFieldWithOthers:@{
                                          @"high":@"High",
                                          @"width":@"Width",
                                          @"imgUploadCount":@"ImgUploadCount",
                                          @"isLockRoom":@"IsLockRoom",
                                          @"imgRoomMaxCount":@"ImgRoomMaxCount",
                                          @"imgAreaMaxCount":@"ImgAreaMaxCount"
                                          }];
}

@end
