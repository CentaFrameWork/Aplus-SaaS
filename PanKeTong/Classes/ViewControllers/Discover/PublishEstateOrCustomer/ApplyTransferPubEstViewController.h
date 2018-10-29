//
//  ApplyTransferPubEstViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@protocol ApplyTransferEstDelegate <NSObject>

/**
 *  申请转盘成功
 */
- (void)transferEstSuccess;

@end

@interface ApplyTransferPubEstViewController : BaseViewController

@property (nonatomic, copy) NSString *propEstKeyId;                     // 申请转盘的KeyId
@property (nonatomic, assign) id <ApplyTransferEstDelegate> delegate;
@property (nonatomic, copy) NSString *propertyStatus;                  // 当前房源状态

@end
