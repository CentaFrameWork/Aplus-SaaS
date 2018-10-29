//
//  UITabBar+badge.m
//  PanKeTong
//
//  Created by TailC on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "UITabBar+badge.h"

static NSInteger const tabbarItemCount = 3;

@implementation UITabBar (badge)

#pragma mark Public Method

- (void)showBadgeOnItemIndex:(NSInteger)index
{
	// 移除之前的红点
	[self removeBadgeOnItemIndex:index];
	
	// 新建红点
	UIView *badgeView = [[UIView alloc] init];
	badgeView.tag = 888 + index;
	badgeView.layer.cornerRadius = 5.0f;
	badgeView.backgroundColor = [UIColor redColor];
	CGRect tabFrame = self.frame;
	
	// 确定红点位置
	float percentX = (index + 0.66)/tabbarItemCount;
	CGFloat x = ceilf(percentX * tabFrame.size.width);
	CGFloat y = ceilf(0.1 * tabFrame.size.height);
	badgeView.frame = CGRectMake(x, y, 10, 10);
	[self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(NSInteger)index
{
	[self removeBadgeOnItemIndex:index];
}

#pragma mark Private Method

- (void)removeBadgeOnItemIndex:(NSInteger)index
{
	for (UIView *subView in self.subviews)
    {
		if (subView.tag == 888 + index)
        {
			[subView removeFromSuperview];
		}
	}
}

@end
