//
//  ShadowImageView.h
//  图片遮罩
//
//  Created by 中原管家 on 2017/7/21.
//  Copyright © 2017年 王雅琦. All rights reserved.
//

#import <UIKit/UIKit.h>

// 默认总进度为100
static CGFloat kMaxProgressNumber = 100;

@interface ShadowImageView : UIImageView

@property (nonatomic, assign) BOOL haveShadow;              // 是否含有阴影遮罩
@property (nonatomic, assign) CGFloat progressNumber;       // 进度数字(默认0)

@end
