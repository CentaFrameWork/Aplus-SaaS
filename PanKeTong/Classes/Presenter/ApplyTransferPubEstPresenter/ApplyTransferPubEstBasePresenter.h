//
//  ApplyTransferPubEstBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/12.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"


@interface ApplyTransferPubEstBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 是否含有提醒时间功能
- (BOOL)haveReminderTimeFunction;

/// 获得楼盘状态
- (NSMutableArray *)getEstStatusArr:(NSMutableArray *)estStatusArr;

/// 获得修改状态
- (NSMutableArray *)getChangedStatusArr:(NSMutableArray *)currentArr CurrentStatus:(NSString *)currentStatus;

/// 提醒人是否屏蔽自己
- (BOOL)isExceptMe;

@end
