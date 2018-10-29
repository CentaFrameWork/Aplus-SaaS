//
//  ShadowImageView.m
//  图片遮罩
//
//  Created by 中原管家 on 2017/7/21.
//  Copyright © 2017年 王雅琦. All rights reserved.
//

#import "ShadowImageView.h"

@interface ShadowImageView ()
{
    CALayer *_shadowLayer;
    CATextLayer *_textLayer;
}

@end

@implementation ShadowImageView

- (void)setHaveShadow:(BOOL)haveShadow
{
    _haveShadow = haveShadow;
    if (haveShadow)
    {
        [self createShadowLayer];
        [self createTextLayer];
    }
    else
    {
        [_shadowLayer removeFromSuperlayer];
        [_textLayer removeFromSuperlayer];
        _shadowLayer = nil;
        _textLayer = nil;
    }
}

/// 进度有改变
- (void)setProgressNumber:(CGFloat)progressNumber
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if (progressNumber > 0)
        {
            _progressNumber = progressNumber;
            _shadowLayer.bounds = CGRectMake(0,
                                             0,
                                             self.frame.size.width,
                                             self.frame.size.height - 1.5 * progressNumber);
            
            _textLayer.string = [NSString stringWithFormat:@"%.0f%%",_progressNumber];
            
            // 到百分之98就隐藏
            if (_progressNumber >= kMaxProgressNumber - 2)
            {
                [_textLayer removeFromSuperlayer];
                [_shadowLayer removeFromSuperlayer];
            }
        }
    });
}

/// 创建阴影layer
- (void)createShadowLayer
{
    if (!_shadowLayer)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            _shadowLayer = [CALayer layer];
            _shadowLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            // 设置其背景色
            _shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
            // 设置其位置
            _shadowLayer.anchorPoint = CGPointMake(0, 0);
            // 设置透明度
            [_shadowLayer setOpacity:0.5];
            
            [self.layer addSublayer:_shadowLayer];
        });
    }
}

/// 创建文字layer
- (void)createTextLayer
{
    if (!_textLayer)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
        
            _textLayer = [CATextLayer layer];
            _textLayer.frame = self.bounds;
            _textLayer.position = CGPointMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 10);
            _textLayer.anchorPoint = CGPointMake(0, 0);
            
            // 设置分辨率
            _textLayer.contentsScale = [UIScreen mainScreen].scale;
            
            // 设置文字属性
            _textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            _textLayer.alignmentMode = kCAAlignmentLeft;
            _textLayer.wrapped = YES;
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            _textLayer.font = fontRef;
            _textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            [self.layer addSublayer:_textLayer];
        });
    }
}

@end
