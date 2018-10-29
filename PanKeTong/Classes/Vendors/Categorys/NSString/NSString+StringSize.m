//
//  NSString+StringSize.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/7/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)
/**
 *  计算文本的高度
 *
 *  @param font  字体
 *  @param width 固定的宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithLabelFont:(UIFont *)font withLabelWidth:(CGFloat)width
{
    CGFloat height = 0;

    if (self.length == 0)
    {
        height = 0;
    }
    else
    {
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font)
        {
            attribute = @{NSFontAttributeName: font};
        }

        // 尺寸
        CGSize retSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;

        height = retSize.height;
    }

    return height;
}


/**
 *  计算文本的宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 */
- (CGFloat)widthWithLabelFont:(UIFont *)font
{
    CGFloat retHeight = 0;

    if (self.length == 0)
    {
        retHeight = 0;
    }
    else
    {
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font)
        {
            attribute = @{NSFontAttributeName: font};
        }

        // 尺寸
        CGSize retSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                            options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;

        retHeight = retSize.width;
    }

    return retHeight;
}

- (CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width size:(CGFloat)minSize
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    [attributedString addAttributes:attrSyleDict range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    
    return stringRect.size.height;
}

- (CGFloat)getStringWidth:(UIFont*)font Height:(CGFloat)height size:(CGFloat)minSize
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys: font, NSFontAttributeName, nil];
    [attributedString addAttributes:attrSyleDict range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];

    return stringRect.size.width;
}

/// 计算字符串的大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}

/// 特殊字符串计算高度
- (CGFloat)mutableAttributedStringWithFont:(UIFont *)font
                                     width:(CGFloat)width
                              andLineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;

    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  paragraphStyle, NSParagraphStyleAttributeName,
                                  font, NSFontAttributeName,
                                  nil];

    [attributedString addAttributes:attrSyleDict range:NSMakeRange(0, self.length)];

    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    
    return stringRect.size.height;
}

@end
