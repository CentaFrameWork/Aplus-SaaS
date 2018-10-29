//
//  AddCustomerViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/9/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "AddCustomerSelectionTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerPriceTableViewCell.h"
#import "AddCustomerResultEntity.h"
#import "AgencySysParamUtil.h"
#import "CustomActionSheet.h"

@protocol AddCustomerDelegate <NSObject>

- (void)backAddCustomerListViewController;

@end


@interface AddCustomerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,UIAlertViewDelegate>

@property(nonatomic, assign)id<AddCustomerDelegate>delegate;

@property (nonatomic, assign) BOOL isFromHomePage;  // 是否是首页快捷入口进来

@end
