//
//  ModifyPwdViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "ModifyPwdTableViewCell.h"
#import "agencyBaseEntity.h"

@interface ModifyPwdViewController : BaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
