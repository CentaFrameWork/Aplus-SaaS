//
//  UITabBar+badge.h
//  PanKeTong
//
//  Created by TailC on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

/**
 *  显示角标红点
 *  @param index 位置
 */
- (void)showBadgeOnItemIndex:(NSInteger)index;

/**
 *  隐藏角标红点
 *  @param index 位置
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
