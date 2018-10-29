//
//  GesturePwdManageViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/3/31.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "ArrowSignTextCell.h"
#import "AutoLockTimeSpanSettingsViewController.h"

@interface GesturePwdManageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
