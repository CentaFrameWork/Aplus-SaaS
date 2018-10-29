//
//  UILabel+Extension.h
//  AOPAyun
//
//  Created by AOPA云 on 15/9/22.
//  Copyright (c) 2015年 AOPA云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/// 设置字号的同时加粗字体
@property (nonatomic, assign) CGFloat boldFont;
///  计算label中文字长度
@property (nonatomic, assign) CGFloat textWidth;
/// 计算label中文字高度
@property (nonatomic, assign) CGFloat textHeight;

#pragma mark - method
- (CGSize)contentSizeForWidth:(CGFloat)width;
- (CGSize)contentSize;
- (BOOL)isTruncated;

///改变部分字体大小
+ (NSMutableAttributedString *)chageLableFontWithString:(NSString *)content withFont:(UIFont *)font withStart:(NSInteger)start withLength:(NSInteger)length;

@end
