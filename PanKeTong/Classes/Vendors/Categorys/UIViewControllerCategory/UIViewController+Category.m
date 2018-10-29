//
//  UIViewController+Category.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/18.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

+ (instancetype)viewControllerFromStoryboard{
    
    NSString *sbName = NSStringFromClass([self class]);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    
    return [sb instantiateViewControllerWithIdentifier:sbName];
}

@end
