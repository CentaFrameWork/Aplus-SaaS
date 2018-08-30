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

#import "ZYHomeMainViewDelegate.h"
@protocol ZYHomeControllerProtocol <NSObject>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end




@interface ZYHomeControllerPresent : ZYBasePresent<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataArray;

- (void)sendRequest;

- (void)setPresentView:(UIView*)view;

@end
