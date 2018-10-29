//
//  JMCropViewController.h
//  PanKeTong
//
//  Created by Admin on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCropViewController : UIViewController
@property(nonatomic,copy) void(^btnSure)(UIImage *image);
@property(nonatomic,copy) void(^btnCancel)(void);

+ (instancetype)loadControllerWithImage:(UIImage*)image;

@end
