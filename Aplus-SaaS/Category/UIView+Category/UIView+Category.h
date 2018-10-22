//
//  UIView+Category.h
//  powerlife
//
//  Created by 陈行 on 16/6/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;

+ (instancetype)viewFromNib;

+ (instancetype)viewFromNibWithFrame:(CGRect)frame;

- (void)layoutCornerRadiusWithCornerRadius:(CGFloat)cornerRadius;

@end
