//
//  SubScrollView.m
//  UI10-task4
//
//  Created by imac on 15/8/18.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "SubScrollView.h"

@implementation SubScrollView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 实现imageView
        imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.multipleTouchEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        
        // 设置每个小滑动视图的最大和最小缩放倍数
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 1;
        
        // 取消水平和垂直的滑动条显示
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        // 设置每个小滑动块的代理
        self.delegate = self;

        // 添加双击手势（实现放大和缩小）
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer: doubleTap];
    }
    return self;
}

#pragma mark - set方法 

- (void)setImageUrlStr:(NSString *)imageUrlStr
{
    if (_imageUrlStr != imageUrlStr)
    {
        _imageUrlStr = imageUrlStr;
        [imgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlStr]];
    }
}

#pragma mark - 返回缩放的视图

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

#pragma mark - 双击

- (void)doubleTapAction:(UITapGestureRecognizer *)tap2
{
    if (self.zoomScale > 1)
    {
        // 缩小
        [self setZoomScale:1 animated:YES];
    }
    else
    {
        // 放大
        [self setZoomScale:3 animated:YES];
    }
}

@end
