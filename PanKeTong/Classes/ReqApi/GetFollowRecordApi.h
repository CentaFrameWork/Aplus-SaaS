//
//  GetFollowRecordApi.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
/// 获取房源跟进记录
@interface GetFollowRecordApi : APlusBaseApi

@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *pageIndex;
@property (nonatomic, copy)NSString *isDetails;
@property (nonatomic, copy)NSString *propKeyId;
@property (nonatomic, copy)NSString *followTypeKeyId;

@end
