//
//  JMPrivateChatViewController.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@protocol JMPrivateChatViewControllerRefreshDelegate <NSObject>

- (void)reloadData;

@end

@interface JMPrivateChatViewController : BaseViewController

@property (nonatomic, strong) NSString * titleName;

@property (nonatomic, strong) NSString * userImgUrl;

@property (nonatomic, strong) NSString * keyId;

@property (nonatomic, strong) NSString * messagerKeyId;

@property (nonatomic, assign) id <JMPrivateChatViewControllerRefreshDelegate> myDelegate;

@end
