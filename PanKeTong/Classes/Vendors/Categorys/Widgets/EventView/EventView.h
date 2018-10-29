//
//  AddEventView.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RowHeight   40  // 行高
#define RowWidth    150 // 行宽
#define ArrowHeight 10  // 箭头高度


@protocol EventDelegate <NSObject>
- (void)eventClickWithBtnTitle:(NSString *)title;
@end

/// 新增事件视图
@interface EventView : UIView

- (instancetype)initWithFrame:(CGRect)frame andIsHaveImage:(BOOL)isHaveImage;

@property (nonatomic,weak) id <EventDelegate> eventDelegate;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,assign) BOOL isHaveImage;// 是否有背景图

@end
