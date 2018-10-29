//
//  stateChangesViewController.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/3.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "BaseViewController.h"
#import "FollowTypeDefine.h"

//为了实现代理
#import "ApplyTransferPubEstViewController.h"

@interface StateChangesViewController : BaseViewController

@property (nonatomic, assign)PropertyFollowType appendMessageType;
@property (nonatomic, strong)NSString *propertyKeyId;
@property (nonatomic,assign)id <ApplyTransferEstDelegate>delegate;
@property (nonatomic, strong)NSString *propKeyId;       // 房源id
@property (nonatomic, assign)BOOL propertyStatus;  // 房源状态
@property (nonatomic, copy) void(^refreshData)();   // 刷新数据回调

@end
