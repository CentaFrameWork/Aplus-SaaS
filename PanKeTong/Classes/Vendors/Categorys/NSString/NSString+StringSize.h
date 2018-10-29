//
//  NSString+StringSize.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/7/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

/**
 *  计算文本的高度
 *
 *  @param font  字体
 *  @param width 固定的宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithLabelFont:(UIFont *)font withLabelWidth:(CGFloat)width;

/**
 *  计算文本的宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 */
- (CGFloat)widthWithLabelFont:(UIFont *)font;

/// 计算字符串的大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
- (CGFloat)getStringHeight:(UIFont*)font
                     width:(CGFloat)width
                      size:(CGFloat)minSize;

- (CGFloat)getStringWidth:(UIFont*)font
                   Height:(CGFloat)height
                     size:(CGFloat)minSize;

/// 特殊字符串计算高度
- (CGFloat)mutableAttributedStringWithFont:(UIFont *)font
                                     width:(CGFloat)width
                              andLineSpace:(CGFloat)lineSpace;

@end
