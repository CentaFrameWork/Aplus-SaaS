//
//  AppendMessageViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/4.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#include "ApplyTransferPubEstViewController.h"
#include "MoreFollowListViewController.h"
#import "FollowTypeDefine.h"

@interface AppendMessageViewController : BaseViewController

@property (nonatomic, assign) PropertyFollowType appendMessageType;

@property (nonatomic, copy) NSString *propKeyId;   // 房源id
@property (nonatomic, weak) id <ApplyTransferEstDelegate> delegate;

@end
