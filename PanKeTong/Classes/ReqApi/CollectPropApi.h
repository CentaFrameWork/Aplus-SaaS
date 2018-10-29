//
//  CollectPropApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 收藏房源
@interface CollectPropApi : APlusBaseApi

@property (nonatomic, assign)BOOL isCollect;
@property (nonatomic, copy)NSString *propKeyId;

@end
