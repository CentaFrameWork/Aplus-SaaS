//
//  CheckRealProtectedEntity.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface CheckRealProtectedEntity : AgencyBaseEntity

@property (nonatomic,copy) NSString *high;
@property (nonatomic,copy) NSString *width;
@property (nonatomic,copy) NSString *imgUploadCount;//长沙定为室内图最大数量  其他城市为一致的所有类型的最大数量
@property (nonatomic,copy) NSString *imgRoomMaxCount;// 户型图的最大值
@property (nonatomic,copy) NSString *imgAreaMaxCount;// 小区图的最大值
@property (nonatomic,assign) BOOL isLockRoom; /// 是否锁定房间户型图

@end
