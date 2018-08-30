//
//  ZYHomeControllerPresent.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZYBasePresent.h"

#import "ZYHomeMainView.h"

#import "ZYHousePageFunc.h"

#import "ZYHomeControllerProtocol.h"


@interface ZYHomeControllerPresent : ZYBasePresent<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, weak) id<ZYHomeControllerProtocol>delegate;

- (void)sendRequest;

- (void)setPresentView:(UIView*)view;

@end






