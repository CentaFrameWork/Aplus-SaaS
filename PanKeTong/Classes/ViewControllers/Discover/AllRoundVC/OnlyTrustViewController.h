//
//  OnlyTrustViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "OnlyTrustTableViewCell.h"
//#import "OnlyTrustService.h"
#import "PropOnlyTrustListEntity.h"
#import "OnlyTrustApi.h"

@interface OnlyTrustViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *keyId;
@property (nonatomic, copy) NSString *titleName;

@end
