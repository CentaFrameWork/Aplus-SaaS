//
//  MyLiangHuaBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "MyQuantificationEntity.h"
#import "GetQuantificationEntitiy.h"

@interface MyLiangHuaBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 获得数据源
- (void)getDataSource:(id)quantificationData;

/// 获得新增房源
- (NSString *)getNewPropertysString;

/// 新增独家
- (NSString *)getNewOnlyTrustsString;

/// 新增实勘
- (NSString *)getNewRealsString;

/// 新增客源
- (NSString *)getNewInquirysString;

/// 新增客源跟进
- (NSString *)getNewInquiryFollowsString;

/// 新增钥匙
- (NSString *)getNewKeysString;

/// 新增房源跟进
- (NSString *)getNewPropertyFollowsString;

/// 新增带看
- (NSString *)getNewTakeSeesString;

/// 新增独家/新增签约
- (NSString *)getAddOnlyTrustName;
@end
