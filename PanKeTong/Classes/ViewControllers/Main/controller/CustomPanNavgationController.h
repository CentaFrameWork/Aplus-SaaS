 //
//  CustomPanNavgationController.h
//  SaleHouse
//
//  Created by 苏军朋 on 14-12-17.
//  Copyright (c) 2014年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPanNavgationController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/// 导航的当前Viewcontroller
@property(nonatomic,weak) UIViewController *currentShowVC;

@end
