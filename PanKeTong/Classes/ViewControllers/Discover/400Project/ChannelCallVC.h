//
//  ChannelCallViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/5.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "TurnPrivateCustomerViewController.h"
#import "SearchViewController.h"
#import "ChnnelCallTableViewCell.h"
#import "ChannelDetailViewController.h"
#import "ChannelCallFilterViewController.h"
#import "AutoCompleteTipViewController.h"
#import "ChannelCallEntity.h"
#import "AgencyUserPermisstionUtil.h"
#import "AccessModelScopeEnum.h"
#import "QueryPhoneAddressUtil.h"
#import "ChannelCallApi.h"

@interface ChannelCallVC : BaseViewController<UITextFieldDelegate,
UITableViewDelegate,UITableViewDataSource,IFlyUtilDelegate,ChannelFilterDelegate,
QueryResult,TurnPrivateDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableview;

@end
