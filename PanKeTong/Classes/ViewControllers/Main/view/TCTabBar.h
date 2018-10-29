//
//  TCTabBar.h
//  PanKeTong
//
//  Created by TailC on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCTabBar;

@protocol TCTabBarDelegate <NSObject>

@optional

- (void)tabBarDidClickedPlusButton:(TCTabBar *)tabBar;

@end

@interface TCTabBar : UITabBar

@property (nonatomic, strong) UIButton *plusButton;     // 定义中间按钮的属性
@property (nonatomic , assign) id<TCTabBarDelegate> tabBarDelegate;

- (void)setPlusButtonImage;
@end
