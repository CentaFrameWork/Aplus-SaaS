//
//  CheckTrustVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/23.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"


#define UNAUDITING      @"unAuditing"// 待审核
#define HAVEAUDITING    @"haveAuditing"// 已审核(审核通过／拒绝)

@protocol RefreshTrustProtocol <NSObject>

@optional
- (void)isRefreshData:(BOOL)isRefresh;
@end

/// 查看委托审核
@interface CheckTrustVC : BaseViewController

@property (nonatomic,copy) NSString *pushType;
@property (nonatomic,copy) NSString *propertyKeyId;// 房源KeyId
@property (nonatomic,copy) NSString *trustkeyId;// 委托KeyId
@property (nonatomic,copy) NSString *creatorPersonName;// 签署人名称
@property (nonatomic,copy) NSString *signDate;// 签署时间
@property (nonatomic,copy) NSString *signType;// 签署类型
@property (nonatomic,assign) BOOL isPlaying;// 是否正在播放

@property (nonatomic, weak) id<RefreshTrustProtocol> refreshDelegate;

@end
