//
//  SearchListCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/7.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SearchListCell.h"

@implementation SearchListCell
{
    __weak IBOutlet UILabel *_propLabel;        // 房源名
    __weak IBOutlet UILabel *_moreDetailLabel;  // 城区片区
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setEntity:(SearchPropDetailEntity *)entity
{
    if (_entity != entity)
    {
        _entity = entity;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSString *houseNo = [NSString nilToEmptyWithStr:self.entity.houseNo];
    _propLabel.text = [NSString stringWithFormat:@"%@ %@",self.entity.itemText,houseNo];

    if (self.entity.districtName.length > 0 && self.entity.areaName.length > 0)
    {
        _moreDetailLabel.text = [NSString stringWithFormat:@"(%@-%@)",self.entity.districtName,self.entity.areaName];
    }
    else
    {
        _moreDetailLabel.text = nil;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ref, 15, 43);                        // 起点
    CGContextAddLineToPoint(ref, APP_SCREEN_WIDTH, 43);  // 终点
    CGContextSetStrokeColorWithColor(ref, RGBColor(200, 200, 200).CGColor);
    CGContextSetLineWidth(ref, 0.5);
    CGContextDrawPath(ref, kCGPathFillStroke);
}

@end
