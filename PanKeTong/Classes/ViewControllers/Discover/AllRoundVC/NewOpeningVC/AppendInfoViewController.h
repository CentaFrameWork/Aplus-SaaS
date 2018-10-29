//
//  AppendInfoViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "FollowTypeDefine.h"
//为了实现代理
#import "ApplyTransferPubEstViewController.h"

@interface AppendInfoViewController : BaseViewController

@property (nonatomic, assign)PropertyFollowType appendMessageType;
@property (nonatomic, strong)NSString *propertyKeyId;
@property (nonatomic,assign)id <ApplyTransferEstDelegate>delegate;

@end
