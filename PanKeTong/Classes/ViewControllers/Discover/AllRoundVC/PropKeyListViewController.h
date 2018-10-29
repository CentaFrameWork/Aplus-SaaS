//
//  PropKeyListViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "KeysTableViewCell.h"

@interface PropKeyListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *keyId;

@end
