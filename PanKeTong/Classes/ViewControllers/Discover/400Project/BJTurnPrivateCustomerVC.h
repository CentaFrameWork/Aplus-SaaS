//
//  BJTurnPrivateCustomerVC.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "AddCustomerSelectionTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerPriceTableViewCell.h"
#import "AgencySysParamUtil.h"
#import "CustomActionSheet.h"
#import "TurnCustomerLabelTableViewCell.h"
#import "TurnPrivateCustomerApi.h"
#import "TurnPrivateCustomerEntity.h"
#import "ValidBlackMobileApi.h"
#import "AddTelephoneCell.h"
//#import "BaseService.h"


@protocol BJTurnPrivateDelegate <NSObject>

- (void)turnPrivateDoneInBeijing;

@end

@interface BJTurnPrivateCustomerVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,
UIPickerViewDelegate,doneSelect,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)NSString *channel;
@property (nonatomic,strong)NSString *channelKeyId;
@property (nonatomic,strong)NSString *phoneNumber;
@property (nonatomic, copy) NSString *isMyPayChannelInquiry;

@property (nonatomic,strong)NSString *keyId;

@property (nonatomic,assign)id <BJTurnPrivateDelegate>delegate;


@end
