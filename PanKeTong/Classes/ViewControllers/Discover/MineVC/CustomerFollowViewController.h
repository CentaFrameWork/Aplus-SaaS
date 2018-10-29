//
//  CustomerFollowViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
//#import "BaseService.h"
#import "CustomActionSheet.h"
#import "MoreFollowListCell.h"
#import "CustomerEntity.h"


@protocol CustomerFollowBackDelegate <NSObject>

@optional
- (void)customerFollowBack;

@end

@interface CustomerFollowViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,doneSelect>

@property (nonatomic, strong) CustomerEntity *customerEntity;
@property (nonatomic, weak) id <CustomerFollowBackDelegate> backDelegate;

@end
