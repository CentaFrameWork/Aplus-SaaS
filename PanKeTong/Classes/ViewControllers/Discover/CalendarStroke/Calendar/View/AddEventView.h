//
//  AddEventView.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RowHeight   40  //行高
#define ArrowHeight 5  //箭头高度


@protocol AddEventDelegate <NSObject>
- (void)addEventClickWithBtnTitle:(NSString *)title;
@end

/// 新增事件视图
@interface AddEventView : UIView

@property (nonatomic,assign) id <AddEventDelegate>addEventDelegate;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray * imageArr;
@property (nonatomic,assign) BOOL isHaveImage;// 是否有背景图
@property (nonatomic,assign) BOOL isAllRoundDetailNavRightBtn;//是否点击通盘房源详情右上角按钮

@end
