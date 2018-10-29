//
//  CustomerInfoBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/10.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CustomerInfoBasePresenter.h"

@implementation CustomerInfoBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

/// 是否可以新增客源跟进
- (BOOL)canAddCustomerFollow
{
    return NO;
}

/// 是否可以拨打电话
- (BOOL)canCallPhoneWithCustomerDetailEntity:(CustomerDetailEntity *)customerDetailEntity
{
    return YES;
}

@end
