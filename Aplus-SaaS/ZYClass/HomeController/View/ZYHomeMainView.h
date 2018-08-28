//
//  ZYHomeMainView.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYMainTableView.h"

#import "ZYHousePageFunc.h"

#import "ZYHomeControllerPresent.h"

#import "ZYHomeMainViewDelegate.h"

@interface ZYHomeMainView : ZYMainTableView<UITableViewDelegate, UITableViewDataSource, ZYHomeMainViewDelegate>

@property (nonatomic, copy) void (^didSelectItemBlock)(NSIndexPath * indexPath);

@end
