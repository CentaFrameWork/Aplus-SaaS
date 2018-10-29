//
//  HeaderView.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 房源详情头视图
@interface PDHeaderView : UIView

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIImageView *bgImgView;    // 房源图片背景图
@property (nonatomic, strong) UILabel *label;            // 标签文本
@property (nonatomic, strong) UILabel *photoSumlLabel;   // 房源实勘图总数
@property (nonatomic, strong) UILabel *propDetailLabel;  // 房源

@end
