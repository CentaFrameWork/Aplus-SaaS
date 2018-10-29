//
//  CustomerInfoBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"

#import "CustomerDetailEntity.h"

@interface CustomerInfoBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 是否可以新增客源跟进
- (BOOL)canAddCustomerFollow;

/// 是否可以拨打电话
- (BOOL)canCallPhoneWithCustomerDetailEntity:(CustomerDetailEntity *)customerDetailEntity;

@end
