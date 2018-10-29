//
//  EditModuleVC.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/24.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseViewController.h"

/// 编辑应用
@interface EditModuleVC : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewHeight;

@property (nonatomic, copy) NSArray *homeModuleArr; // 首页显示应用

@property (nonatomic, copy) NSArray *allModuleArr;  // 所有应用

@end
