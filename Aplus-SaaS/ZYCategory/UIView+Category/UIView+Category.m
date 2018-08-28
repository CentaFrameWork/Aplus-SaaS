//
//  UIView+Category.m
//  powerlife
//
//  Created by 陈行 on 16/6/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x=x;
    self.frame=rect;
}
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y=y;
    self.frame=rect;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width=width;
    self.frame=rect;
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height=height;
    self.frame=rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}

+ (instancetype)viewFromNib{
    NSString * nibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] firstObject];
}

+ (instancetype)viewFromNibWithFrame:(CGRect)frame{
    
    UIView * view = [self viewFromNib];
    
    view.frame = frame;
    
    return view;
}
- (void)layoutCornerRadiusWithCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end
