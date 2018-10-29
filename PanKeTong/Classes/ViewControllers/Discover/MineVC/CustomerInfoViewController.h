//
//  CustomerInfoViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 15/9/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerInfoTableViewCell.h"
#import "CustomerFollowPreviewTableViewCell.h"
#import "SystemParamEntity.h"
#import "AgencySysParamUtil.h"
#import "CustomerContacts.h"
#import "CommonMethod.h"
#import "CustomerFollowViewController.h"
#import "UMSocialWechatHandler.h"
#import "CustomerEntity.h"

@interface CustomerInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,
 UIPickerViewDataSource, UIPickerViewDelegate, doneSelect>

@property (nonatomic, strong) CustomerEntity *customerEntity;

@end
