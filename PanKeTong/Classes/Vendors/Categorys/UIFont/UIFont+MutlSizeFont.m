//
//  UIFont+MutlSizeFont.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "UIFont+MutlSizeFont.h"

@implementation UIFont (MutlSizeFont)

/// 根据不同的屏幕尺寸设置字号
+ (UIFont *)setFontSizeWithFontName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    
    if ([CommonMethod is4_7InchScreen])
    {
        fontSize = fontSize+1;
    }else if ([CommonMethod is5InchScreen])
    {
        fontSize = fontSize+2;
    }
    
    UIFont *mutlSize = [self fontWithName:fontName
                                     size:fontSize];
    return mutlSize;
}

@end
