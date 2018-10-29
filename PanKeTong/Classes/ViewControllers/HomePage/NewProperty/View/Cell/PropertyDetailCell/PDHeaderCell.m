//
//  PDHeaderCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDHeaderCell.h"

@implementation PDHeaderCell
{
    __weak IBOutlet UILabel *_titleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setTitleStr:(NSString *)titleStr
{
    if (_titleStr != titleStr)
    {
        _titleStr = titleStr;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _titleLabel.text = self.titleStr;

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

//    // 绘制直线
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(ref, 15, 49);                        // 起点
//    CGContextAddLineToPoint(ref, APP_SCREEN_WIDTH - 10, 49);  // 终点
//    CGContextSetStrokeColorWithColor(ref, SeparateLineColor.CGColor);
//    CGContextSetLineWidth(ref, 1);
//    CGContextDrawPath(ref, kCGPathFillStroke);
}


@end
