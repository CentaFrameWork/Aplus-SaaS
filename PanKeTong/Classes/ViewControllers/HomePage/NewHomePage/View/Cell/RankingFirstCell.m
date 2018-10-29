//
//  TopFirstCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/15.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "RankingFirstCell.h"
#import "DDProgressView.h"

@implementation RankingFirstCell 
{
    __weak IBOutlet DDProgressView *_performView;
    
    __weak IBOutlet UILabel *_rankingLabel;

    __weak IBOutlet UILabel *_performanceLabel;

    __weak IBOutlet UILabel *_billLabel;
    
    __weak IBOutlet UILabel *_distanceLabel;

    __weak IBOutlet UILabel *_describeLabel;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _topPerformance = 0.00;
    [self.employeeImg setLayerCornerRadius:24];
    UIView *bgView = [self.contentView viewWithTag:111];
    [bgView setLayerCornerRadius:6];

    _performView.progress = 0;
    _performView.emptyColor = RGBColor(254, 212, 212);


}

- (void)setMyPerformance:(PerformanceItemEntity *)myPerformance
{
    if (_myPerformance != myPerformance)
    {
        _myPerformance = myPerformance;

        [self setNeedsLayout];
    }
}

- (void)setTopPerformance:(float)topPerformance
{
    if (_topPerformance != topPerformance)
    {
        _topPerformance = topPerformance;
        _performView.progress = [_myPerformance.performance floatValue] / _topPerformance;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_topPerformance == 0.00)
    {
        _describeLabel.hidden = YES;
    }
    else
    {
        _describeLabel.hidden = NO;
    }

    _rankingLabel.text = [NSString stringWithFormat:@"%ld",[_myPerformance.achievementPlace integerValue]];
    _performanceLabel.text = [NSString stringWithFormat:@"%.2f万", [_myPerformance.performance doubleValue] / 10000];
    _billLabel.text = [NSString stringWithFormat:@"%.1f单", [_myPerformance.billCount floatValue]];
    _distanceLabel.text = [NSString stringWithFormat:@"距离上一名还有%.2f元差距",[_myPerformance.achievementDiff floatValue]];
    
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 绘制顶部图片 文字
    UIImage *img = [UIImage imageNamed:@"Top"];
    [img drawInRect:CGRectMake(20, 20, 30, 30)];
    
    NSString *textStr = @"TOP10 业绩排行";
    [textStr drawInRect:CGRectMake(65, 20, 150, 30) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ref, 220, 30); // 起点
    CGContextAddLineToPoint(ref, APP_SCREEN_WIDTH, 30);
    CGContextSetStrokeColorWithColor(ref, SeparateLineColor.CGColor);
    CGContextSetLineWidth(ref, 1);
    CGContextDrawPath(ref, kCGPathFillStroke);

}

@end
