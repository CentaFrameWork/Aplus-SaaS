//
//  TurnPrivateCustomerViewController.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/25.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
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
#import "AgencyUserPermisstionUtil.h"

@protocol TurnPrivateDelegate <NSObject>

- (void)turnDone;

@end

@interface TurnPrivateCustomerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *channelKeyId;
@property (nonatomic,strong) NSString *phoneNumber;

@property (nonatomic,strong) NSString *keyId;

@property (nonatomic,assign)id <TurnPrivateDelegate> delegate;


@end
