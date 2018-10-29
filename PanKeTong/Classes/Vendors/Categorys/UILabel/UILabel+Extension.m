//
//  UILabel+Extension.m
//  AOPAyun
//
//  Created by AOPA云 on 15/9/22.
//  Copyright (c) 2015年 AOPA云. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


#pragma mark ====设置字号的同时加粗字体====
///  设置字号的同时加粗字体
- (void)setBoldFont:(CGFloat)boldFont
{
     [self setFont:[UIFont fontWithName:@"Helvetica-Bold" size:boldFont]];//加粗字体
}

#pragma mark ====计算label中文字长度====
/// 计算label中文字长度
- (CGFloat)textWidth
{
    CGSize size =  [self.text sizeWithFont:self.font
                           constrainedToSize:CGSizeMake(FLT_MAX,FLT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    return  size.width;
}

#pragma mark ====计算label中文字高度====

/// 计算label中文字高度
- (CGFloat)textHeight
{
    return [self heightForLabel:self.text];
}


#pragma mark ====label高度自适应====

/// label高度自适应
- (CGFloat)heightForLabel:(NSString *)content
{
    //参数1:设置计算内容的宽和高
    //参数2:设置计算高度模式
    //参数3:设置计算字体大小属性
    //参数4:系统备用参数,设置为nil
    
    //其中宽度一定与显示内容的label宽度一致,否则计算不准确
    
    CGSize size = CGSizeMake(self.width, 10000);
    
    
    //字体大小一定与限时内容的label字体大小一致
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
    CGRect frame = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return frame.size.height;
}

#pragma mark - method

- (CGSize)contentSizeForWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;

    CGRect contentFrame = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : self.font } context:nil];
    return contentFrame.size;
}

- (CGSize)contentSize
{
    return [self contentSizeForWidth:CGRectGetWidth(self.bounds)];
}

- (BOOL)isTruncated
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    return (size.height > self.frame.size.height);
}

/**
 改变部分字体大小
 
 @param content 要改变的字符串
 @param font 要改变的字体Font
 @param start 开始改变的位置
 @param length 改变的长度
 @return  返回NSMutableAttributedString
 */
+ (NSMutableAttributedString *)chageLableFontWithString:(NSString *)content withFont:(UIFont *)font withStart:(NSInteger)start withLength:(NSInteger)length
{
    NSString *contentString = content ? content : @"" ;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(start, length)];
    return attributedString;
}

@end
