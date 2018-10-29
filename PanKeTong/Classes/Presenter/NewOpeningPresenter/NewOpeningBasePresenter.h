//
//  NewOpeningBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/12.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"


@interface NewOpeningBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id )delegate;

/// 获得第一个itemText
- (NSString *)getFirstItemTextWithPropertyStatus:(NSInteger)propertyStatus andTradingState:(NSInteger)tradingState;

/// 获得第二个itemText
- (NSString *)getSecondItemTextWithPropertyStatus:(NSInteger)propertyStatus andTradingState:(NSInteger)tradingState;

/// 获得交易状态
- (NSInteger)getTradingState:(NSInteger)tradingState andPropertyStatus:(NSInteger)propertyStatus andOpeningStatus:(NSString *)openingStatus;

/// 是否有确认业主功能
- (BOOL)haveConfirmOwnerFunction;
@end
