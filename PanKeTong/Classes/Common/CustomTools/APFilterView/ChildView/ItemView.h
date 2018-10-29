//
//  ItemView.h
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/23.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FilterViewHeight                40

#define ItemTitleBaseTag                30000
#define ArrowImageBaseTag               10000
#define ItemButtonBaseTag               20000

#define ArrowDownGrayImgName        @"icon_jm_arrow_under_solid_gray"
#define ArrowDownRedImgName         @"icon_jm_arrow_under_solid_green"

typedef void(^ButtonClickBlock)(UIButton *button);

@interface ItemView : UIView

@property(nonatomic, copy)ButtonClickBlock btnClickBlock;                   // Item按钮点击回调

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setItemTitleArray:(NSArray *)itemTitleArray;

@end
