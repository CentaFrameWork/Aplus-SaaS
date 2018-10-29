//
//  UIColor+Custom.h
//  yucen_fdr
//
//  Created by ug19 on 15/5/8.
//  Copyright (c) 2015年 UG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)

/**
 *  使用十六进制的色值设置颜色
 *
 *  @param hexString 十六进制的颜色色值，“#”开头
 *
 *  @return UIColor 颜色
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;

/**
 *  使用十六进制的色值设置颜色，可设置透明度
 *
 *  @param hexString 十六进制的颜色色值，“#”开头
 *  @param alpha     颜色透明度
 *
 *  @return UIColor 颜色
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  设置 RGB 颜色，传入的颜色为最大 255.0 的色值，透明度为 1.0
 *
 *  @param r Red 色值
 *  @param g Green 色值
 *  @param b Blue 色值
 *
 *  @return UIColor 颜色
 */
+ (UIColor*)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

/**
 *  设置 RGB 颜色和透明度，传入的颜色为最大 255.0 的色值
 *
 *  @param r     Red 色值
 *  @param g     Green 色值
 *  @param b     Blue 色值
 *  @param alpha 透明度
 *
 *  @return UIColor 颜色
 */
+ (UIColor*)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha;

@end
