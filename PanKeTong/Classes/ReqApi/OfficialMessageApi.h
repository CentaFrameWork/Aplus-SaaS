//
//  OfficialMessageApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "HKBaseApi.h"
#define AllOfficialMessage 1//获取官方消息列表
#define OneOfficialMessage 2//获取一条官方消息

///官方消息获取
@interface OfficialMessageApi : HKBaseApi

@property (nonatomic,copy)NSString *startIndex;
@property (nonatomic,copy)NSString *length;
@property (nonatomic,assign)NSInteger officialType;

@end
