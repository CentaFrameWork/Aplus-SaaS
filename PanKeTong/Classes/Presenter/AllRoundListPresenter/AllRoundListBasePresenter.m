//
//  AllRoundListBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AllRoundListBasePresenter.h"
#import "CheckPermissionInstantiation.h"

@implementation AllRoundListBasePresenter


- (instancetype)initWithDelegate:(id<AllRoundListViewProtocol>)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
        self.permissionDelegate = [[CheckPermissionInstantiation alloc] init];
    }
    return self;
}

/// 获得filter标签
- (NSArray *)getTagTextArray
{
    if([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_AREA_MANAGER_RECOMMEND]){
        return [NSArray arrayWithObjects:@"不限",@"推荐房源",@"新上房源", nil];
    }else{
        return [NSArray arrayWithObjects:@"不限",@"新上房源", nil];
    }
}

/// 是否含有委托已审
- (BOOL)haveTrustsApproved
{
    return NO;
}

///是否含有证件齐全
- (BOOL)haveCompleteDoc{
    return NO;
}

///是否含有委托房源
- (BOOL)haveTrustProperty
{
    return NO;
}

/// 是否含有右下角排序按钮
- (BOOL)haveSortButton
{
    return NO;
}

/// 是否需要验证实勘保护期
- (BOOL)isCheckRealProtected
{
    return YES;
}

/// 上传实勘时是否需要检查房源状态
- (BOOL)isCheckPropertyStatus
{
    return NO;
}

/// 添加实勘权限
- (BOOL)canAddUploadrealSurvey:(NSString *)deptPerm
{
    return [_permissionDelegate haveAddUploadrealSurveyPerm:deptPerm];
}

/// 查看实勘权限
- (BOOL)canViewUploadrealSurvey:(NSString *)deptPerm
{
    return [_permissionDelegate haveUploadrealSurveyPerm:deptPerm];
}

/// 是否可以搜索房号
- (BOOL)canSearchHouseNo
{
    return NO;
}

/// 获得标签标示
- (NSString *)getTagString
{
    return @"独";
}

/// 含有编辑房源功能
- (BOOL)haveEditFunction
{
    return NO;
}

/// 是否含面积单位(㎡之类)
- (BOOL)haveAreaUnit
{
    return NO;
}

/// 是否含有价格单位(万/m之类)
- (BOOL)havePriceUnit
{
    return NO;
}

/// 进入房源详情页
- (void)goAllRoundDetailVC
{
    [self.selfView goAllRoundDetailViewController];
}

/// 是否使用通用详情页面
- (BOOL)isCurrencyDataView
{
    return YES;
}

/// 是否有上传视频
- (BOOL)isHaveUploadVideo
{
    return NO;
}

@end
