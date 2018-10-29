//
//  LBPointView.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "LBPointView.h"

@implementation LBPointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.color = [UIColor whiteColor];
    }

    return self;
}


- (void)setColor:(UIColor *)color
{
    self->_color = color;

    [self setNeedsDisplay];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = self.color;
    self.layer.cornerRadius = self.width / 2;
    self.layer.masksToBounds = YES;

    
}

@end
