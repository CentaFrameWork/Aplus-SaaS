//
//  UIFont+MutlSizeFont.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MutlSizeFont)

/// 根据不同的屏幕尺寸设置字号
+ (UIFont *)setFontSizeWithFontName:(NSString *)fontName andSize:(CGFloat)fontSize;

@end
