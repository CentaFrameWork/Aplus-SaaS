//
//  MyQuantificationEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "OperateResultEntity.h"

/// 天津量化数据返回实体
@interface MyQuantificationEntity : AgencyBaseEntity


@property (nonatomic,strong)OperateResultEntity * operateResult;
@property (nonatomic,assign)NSInteger newPropertysCount;//新增房源
@property (nonatomic,assign)NSInteger newInquirysCount;
@property (nonatomic,assign)NSInteger newKeysCount;
@property (nonatomic,assign)NSInteger newRealsCount;
@property (nonatomic,assign)NSInteger newOnlyTrustsCount;
@property (nonatomic,assign)NSInteger newTakeSeesCount;
@property (nonatomic,assign)NSInteger newPropertyFollowsCount;
@property (nonatomic,assign)NSInteger newyInquiryFollowsCount;

@end
