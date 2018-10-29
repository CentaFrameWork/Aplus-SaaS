//
//  JMScanController.h
//  PanKeTong
//
//  Created by Admin on 2018/3/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//


#import "BaseViewController.h"

@interface JMScanController : BaseViewController

+ (void)scanController:(void(^)(bool isInstance ,UIViewController *vc ))block;

@end
