//
//  AllRoundListBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "CheckPermissionInstantiation.h"
#import "AllRoundListViewProtocol.h"

@interface AllRoundListBasePresenter : BasePresenter

@property (assign, nonatomic) id<AllRoundListViewProtocol> selfView;

- (instancetype)initWithDelegate:(id<AllRoundListViewProtocol>)delegate;

@property (retain,nonatomic) id<CheckPermissionProtocol> permissionDelegate;

/// 获得filter标签
- (NSArray *)getTagTextArray;

/// 是否含有委托已审
- (BOOL)haveTrustsApproved;

///是否含有证件齐全
- (BOOL)haveCompleteDoc;

///是否含有委托房源
- (BOOL)haveTrustProperty;

/// 是否含有右下角排序按钮
- (BOOL)haveSortButton;

/// 是否需要查看实勘保护期
- (BOOL)isCheckRealProtected;

/// 上传实勘时是否需要检查房源状态
- (BOOL)isCheckPropertyStatus;

/// 添加实勘权限
- (BOOL)canAddUploadrealSurvey:(NSString *)deptPerm;

// 查看实勘权限
- (BOOL)canViewUploadrealSurvey:(NSString *)deptPerm;

/// 是否可以搜索房号
- (BOOL)canSearchHouseNo;

/// 获得标签标示
- (NSString *)getTagString;

/// 含有编辑房源功能
- (BOOL)haveEditFunction;

/// 是否含有面积单位(㎡之类)
- (BOOL)haveAreaUnit;

/// 是否含有价格单位(万/m之类)
- (BOOL)havePriceUnit;

/// 进入房源详情页
- (void)goAllRoundDetailVC;

/// 是否使用通用详情页面
- (BOOL)isCurrencyDataView;

/// 是否有上传视频
- (BOOL)isHaveUploadVideo;

@end
