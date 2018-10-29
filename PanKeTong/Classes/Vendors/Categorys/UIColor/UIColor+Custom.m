//
//  UIColor+Custom.m
//  yucen_fdr
//
//  Created by ug19 on 15/5/8.
//  Copyright (c) 2015年 UG. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
	return [self colorFromHexString:hexString alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
	unsigned rgbValue = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	[scanner setScanLocation:1]; // bypass '#' character
	[scanner scanHexInt:&rgbValue];
	return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
	return [UIColor colorWithRed:r / 255.0  green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:r / 255.0  green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

@end
