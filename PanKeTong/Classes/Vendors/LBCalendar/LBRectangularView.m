//
//  LBRectangularView.m
//  Calendar module
//
//  Created by king on 1511-4-308.
//  Copyright © 2015年 luqinbin. All rights reserved.
//

#import "LBRectangularView.h"

@implementation LBRectangularView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];


    return self;
}



- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = _color;
}

@end

