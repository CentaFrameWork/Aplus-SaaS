//
//  NewOpeningBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/12.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "NewOpeningBasePresenter.h"

@implementation NewOpeningBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 获得第一个itemText
- (NSString *)getFirstItemTextWithPropertyStatus:(NSInteger)propertyStatus andTradingState:(NSInteger)tradingState;
{
    NSString *firstItemText = @"";
    
    if (propertyStatus == 1) {
        // 有效
        
        if(tradingState == 1){
            //出售
            firstItemText = @"售开租";

        }else if (tradingState == 2){
            //出租
            firstItemText = @"租开售";
        }
        
    }
    else
    {
        // 无效
        if(tradingState == 1){
            //出售
            firstItemText = @"新开售";
            
        }else if (tradingState == 2){
            //出租
            firstItemText = @"新开租";
            
        }else if (tradingState == 3){
            //租售
            firstItemText = @"新开售";
        }
    }

    return firstItemText;
}

/// 获得第二个itemText
- (NSString *)getSecondItemTextWithPropertyStatus:(NSInteger)propertyStatus andTradingState:(NSInteger)tradingState
{
    NSString *secondItemText = @"";
    
    if (propertyStatus == 1) {
        // 有效
    }
    else
    {
        // 无效
        if(tradingState == 1){
            //出售
            secondItemText = @"售开租";
            
        }else if (tradingState == 2){
            //出租
            secondItemText = @"租开售";
            
        }else if (tradingState == 3){
            //租售
            secondItemText = @"新开租";
        }
    }
    
    return secondItemText;
}

/// 获得交易状态
- (NSInteger)getTradingState:(NSInteger)tradingState andPropertyStatus:(NSInteger)propertyStatus andOpeningStatus:(NSString *)openingStatus
{
    return tradingState;
}

/// 是否有确认业主功能
- (BOOL)haveConfirmOwnerFunction
{
    return NO;
}

@end
