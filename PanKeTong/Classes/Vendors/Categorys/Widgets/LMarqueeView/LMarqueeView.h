//
//  LMarqueeView.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/9.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickNewPropDelegate<NSObject>

- (void)clickNewPropWithIndex:(NSInteger)index;

@end


/// 文字滚动视图效果
@interface LMarqueeView : UIView

@property (nonatomic, copy) NSArray *titleArr;

@property (nonatomic, weak) id <ClickNewPropDelegate> delegate;

// 开始计时器
- (void)startTimer;

// 暂停计时器
- (void)pauseTimer;

// 结束计时器
- (void)stopTimer;
@end
