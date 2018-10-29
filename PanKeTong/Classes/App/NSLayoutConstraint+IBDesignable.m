//
//  NSLayoutConstraint+IBDesignable.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/4/18.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"

@implementation NSLayoutConstraint (IBDesignable)

- (void)setAdapterScreen:(BOOL)adapterScreen{
    
    if (adapterScreen) {
        self.constant = self.constant * NewRatio;
    }
}

- (BOOL)adapterScreen{
    return YES;
}

@end
