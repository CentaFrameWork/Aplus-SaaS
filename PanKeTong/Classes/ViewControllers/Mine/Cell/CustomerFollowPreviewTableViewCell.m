//
//  CustomerFollowPreviewTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerFollowPreviewTableViewCell.h"

@implementation CustomerFollowPreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = YCThemeColorBackground;
    self.selectedBackgroundView = view;
   
 
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(12, 0, rect.size.width-24, rect.size.height)
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    [[UIColor whiteColor] set];
    [maskPath fill];
}

@end
