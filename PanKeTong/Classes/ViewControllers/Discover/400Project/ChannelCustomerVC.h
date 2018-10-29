//
//  ChannelCustomerViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/4.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "TurnPrivateCustomerViewController.h"
#import "SearchViewController.h"
#import "ChannelDetailViewController.h"
#import "ChannelCallFilterViewController.h"
#import "AutoCompleteTipViewController.h"
#import "QueryPhoneAddressUtil.h"
#import "ChannelCallApi.h"

@interface ChannelCustomerVC : BaseViewController<UITextFieldDelegate,AutoCompleteChiefOrPublicAccountDelegate,
UITableViewDelegate,UITableViewDataSource,ChannelFilterDelegate,
QueryResult,TurnPrivateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableview;

@end
