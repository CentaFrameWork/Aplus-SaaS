//
//  ReminScreeningViewController.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertApi.h"
typedef void (^ alertScreeningBlock)(AlertApi * alertApi);

@interface ReminScreeningViewController : BaseViewController

@property (nonatomic, copy)alertScreeningBlock block;
@property (nonatomic, strong) AlertApi *alertScreeningEntity; 

@end
