//
//  DealIploadImageController.h
//  PanKeTong
//
//  Created by Admin on 2018/3/26.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "WJDealListModel.h"
#define  JM_refreshDeal @"refreshDeal"
@interface DealIploadImageController : BaseViewController
@property (nonatomic,strong) WJDealListModel *model;

@property (nonatomic,strong) NSNumber* number;
@end
