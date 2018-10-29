//
//  TimeScreenViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/4/22.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterEntity.h"

typedef void (^ moreFilterInfoBlock)(NSString *startTime,NSString *endTime,NSString *followDeptKeyId,BOOL isNative);

@interface TimeScreenViewController : BaseViewController

@property (nonatomic, copy)moreFilterInfoBlock block;

@property (nonatomic, readwrite, strong) RemindPersonDetailEntity *entity;

@property (nonatomic, readwrite, copy) NSString *startTime;     // 开始时间
@property (nonatomic, readwrite, copy) NSString *endTime;       // 结束时间

@property (nonatomic, readwrite, assign) BOOL isNative;           // 是否为本部

@end
