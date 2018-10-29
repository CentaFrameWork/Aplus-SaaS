//
//  ApplyTransferPubEstBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/12.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ApplyTransferPubEstBasePresenter.h"

@implementation ApplyTransferPubEstBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 是否含有提醒时间功能
- (BOOL)haveReminderTimeFunction
{
    return YES;
}

/// 获得楼盘状态
- (NSMutableArray *)getEstStatusArr:(NSMutableArray *)estStatusArr
{
    NSInteger arrNumber = estStatusArr.count - 1;
    
    for (NSInteger i = arrNumber; i >= 0 ; i--) {
        SelectItemDtoEntity *entity = estStatusArr[i];
        if ([entity.itemCode isEqualToString:@"300"]) {
            //移除预定
            [estStatusArr removeObjectAtIndex:i];
            break;
        }
    }
    
    return estStatusArr;
}

- (NSMutableArray *)getChangedStatusArr:(NSMutableArray *)currentArr CurrentStatus:(NSString *)currentStatus
{
    return currentArr;
}

/// 提醒人是否屏蔽自己
- (BOOL)isExceptMe
{
    return NO;
}

@end
