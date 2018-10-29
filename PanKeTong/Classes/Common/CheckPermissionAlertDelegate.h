//
//  CheckPermissionAlertDelegate.h
//  PanKeTong
//
//  Created by 燕文强 on 15/12/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPermissionAlertDelegate : NSObject<UIAlertViewDelegate>

@property (nonatomic,strong)UIViewController *viewController;

+ (CheckPermissionAlertDelegate *)initWithController:(UIViewController *)viewController;

@end
