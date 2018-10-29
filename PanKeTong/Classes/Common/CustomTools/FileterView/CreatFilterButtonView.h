//
//  CreatFilterButtonView.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterView.h"

@protocol ButtonClickDelegate <NSObject>

- (void)getButtonTag:(NSInteger)tag;

@end

/// 创建过滤器
@interface CreatFilterButtonView : UIView


@property (nonatomic,assign)id <ButtonClickDelegate> delegate;

- (void)creatButtonFirstLabel:(NSString *)first
                 SecondLabel:(NSString *)second
                  ThirdLabel:(NSString *)third
                 FourthLabel:(NSString *)fourth;

- (void)creatButtonFirstLabel:(NSString *)first
                 SecondLabel:(NSString *)second
                  ThirdLabel:(NSString *)third;

- (void)creatButtonFirstLabel:(NSString *)first
                 SecondLabel:(NSString *)second;

- (void)creatRegionButtonWithTitle:(NSString *)title;

@end