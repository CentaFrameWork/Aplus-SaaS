//
//  JMAlertResetGesturesViewController.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/2.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface JMAlertResetGesturesViewController : BaseViewController

@property (nonatomic, copy) void (^ensureBtnClickBlock)(void);

@property (nonatomic, copy) void (^cancleBtnClickBlock)(void);

@end
