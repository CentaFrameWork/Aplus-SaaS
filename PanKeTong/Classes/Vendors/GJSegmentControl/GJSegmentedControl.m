//
//  GJSegmentedControl.m
//  PanKeTong
//
//  Created by zhwang on 16/4/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GJSegmentedControl.h"
#define SegmentBtnBaseTag           1000
#define CornerRadius                5.0f

#define SELECTBTN_RED_COLOR                           [UIColor colorWithRed:251.0 / 255.0 green:68.0 / 255.0 blue:6.0 / 255.0 alpha:1.0f]

@implementation GJSegmentedControl
{
    GJSegmentedIndexChangeBlock _changeSegmentBlock;
    UIView *_selectedView;
    
    NSArray *_sectionTitles;
    
    CGFloat _segmentBtnWidth;
    CGFloat _segmentBtnHeight;
    
    NSInteger _lastSelectedSegmentBtnTag;
    
}

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self sizeToFit];
        
    }
    
    return self;
    
}


-(void)sectionTitles:(NSArray *)sectionTitles
{
    
    /**
     创建背景图片、选中的图片
     */
    
    _segmentBtnWidth = self.bounds.size.width/sectionTitles.count;
    _segmentBtnHeight = self.bounds.size.height;
    
    _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                             _segmentBtnWidth,
                                                             _segmentBtnHeight)];
    [_selectedView setBackgroundColor:[UIColor whiteColor]];
    _selectedView.layer.masksToBounds = YES;
    [self setMaskLayer];
    
    [self addSubview:_selectedView];
    
    
    /**
     *  创建segment按钮
     */
    for (int i = 0; i<sectionTitles.count; i++) {
        
        NSString *titleStr = [NSString stringWithFormat:@"%@",[sectionTitles objectAtIndex:i]];
        
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentBtn setFrame:CGRectMake(i*_segmentBtnWidth,
                                        0,
                                        _segmentBtnWidth,
                                        _segmentBtnHeight)];
        [segmentBtn setBackgroundColor:[UIColor clearColor]];
        [segmentBtn setTag:SegmentBtnBaseTag + i];
        segmentBtn.titleLabel.font = [UIFont fontWithName:FontName
                                                     size:15.0];
        [segmentBtn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [segmentBtn setTitle:titleStr
                    forState:UIControlStateNormal];
        [segmentBtn addTarget:self
                       action:@selector(clickSegmentBtnMethod:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:segmentBtn];
        
    }
    [self selectedItemWithIndex:0];
    
}

//设置背景左角为圆角
-(void)setMaskLayer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_selectedView.bounds
                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft
                                                 cornerRadii:(CGSize){CornerRadius, CornerRadius}].CGPath;
    _selectedView.layer.mask = maskLayer;
}
/**
 *  设置回调block
 */
-(void)indexChangeBlock:(GJSegmentedIndexChangeBlock)indexChangeBlock
{
    _changeSegmentBlock = indexChangeBlock;
}


/**
 *  点击segment按钮
 */
-(void)clickSegmentBtnMethod:(UIButton *)button
{
    
    NSInteger selectedIndex = button.tag - SegmentBtnBaseTag;
    
    [self selectedItemWithIndex:selectedIndex];
    
    if (_changeSegmentBlock) {
        
        _changeSegmentBlock(selectedIndex);
    }
    
}

/**
 *  设置选中的index
 */
-(void)selectedItemWithIndex:(NSInteger)selectedIndex
{
    
    UIButton *curSelectBtn = (UIButton *)[self viewWithTag:selectedIndex + SegmentBtnBaseTag];
    [curSelectBtn setTitleColor:SELECTBTN_RED_COLOR
                       forState:UIControlStateNormal];
    
    UIButton *lastSelectedBtn = (UIButton *)[self viewWithTag:_lastSelectedSegmentBtnTag];
    
    if ([lastSelectedBtn isKindOfClass:[UIButton class]] &&
        _lastSelectedSegmentBtnTag != (selectedIndex + SegmentBtnBaseTag)) {
        
        [lastSelectedBtn setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        
        if (selectedIndex == 0) {
            [self setMaskLayer];
            [_selectedView setFrame:CGRectMake(selectedIndex * _segmentBtnWidth,
                                               0,
                                               _segmentBtnWidth,
                                               _segmentBtnHeight)];
        }else{
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_selectedView.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                                         cornerRadii:(CGSize){CornerRadius, CornerRadius}].CGPath;
            _selectedView.layer.mask = maskLayer;
            [_selectedView setFrame:CGRectMake(selectedIndex * _segmentBtnWidth,
                                               0,
                                               _segmentBtnWidth,
                                               _segmentBtnHeight)];
        }
        
        
        
    }
    
    _lastSelectedSegmentBtnTag = selectedIndex + SegmentBtnBaseTag;
    
}

@end
