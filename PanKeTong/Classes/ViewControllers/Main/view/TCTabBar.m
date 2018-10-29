//
//  TCTabBar.m
//  PanKeTong
//
//  Created by TailC on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TCTabBar.h"
#import "UIView+Extension.h"

@interface TCTabBar ()


@end

@implementation TCTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
	
	self = [super initWithFrame:frame];
	if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setupPlusButton];
    }
	
	return  self;
}


- (void)setupPlusButton
{
    NSString *imgName;
    if ([CommonMethod isLoadNewView])
    {
        imgName = @"拍照";
    }
    else
    {
        imgName = @"tab_btn";
    }

    // 设置背景 tab_btn
	self.plusButton = [[UIButton alloc] init];
	[self.plusButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	[self.plusButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
	[self.plusButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	[self.plusButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
	[self.plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
	// 添加
	[self addSubview:self.plusButton];
    
    
}

- (void)setPlusButtonImage
{
    NSString *imgName;
    if ([CommonMethod isLoadNewView])
    {
        imgName = @"拍照";
    }
    else
    {
        imgName = @"tab_btn";
    }
    
    [self.plusButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
    [self.plusButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.plusButton setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
}

- (void)plusClick
{
	// 通知代理
	if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)])
    {
		[self.tabBarDelegate tabBarDidClickedPlusButton:self];
	}
}

/// 布局子控件
- (void)layoutSubviews
{
	[super layoutSubviews];
    
	// 设置plusButton的frame
	[self setupPlusButtonFrame];
    
	// 设置所有tabbarButton的frame
	[self setupAllTabBarButtonsFrame];
}


- (void)setupPlusButtonFrame
{
	self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    CGFloat pointY = IS_iPhone_X ? (self.height-BOTTOM_SAFE_HEIGHT)/2 : self.height/2;
	self.plusButton.center = CGPointMake(self.width * 0.5, pointY);
}

- (void)setupAllTabBarButtonsFrame
{
	int index = 0;
    
	// 遍历所有button
	for (UIView *tabBarButton in self.subviews)
    {
		if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
		[self setupTabBarButtonFrame:tabBarButton atIndex:index];
		
		index++;
	}
}

- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
	// 计算button的尺寸
	CGFloat buttonW = self.width / (self.items.count + 1);
	CGFloat buttonH = self.height;
	tabBarButton.width = buttonW;
	tabBarButton.height = 49;
    
	if (index >= 2)
    {
		tabBarButton.x = buttonW * (index + 1);
	}
    else
    {
		tabBarButton.x = buttonW * index;
	}
    
	tabBarButton.y = 0;
}



@end
