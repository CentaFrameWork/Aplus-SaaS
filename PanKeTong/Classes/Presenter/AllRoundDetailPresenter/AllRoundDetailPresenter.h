//
//  AllRoundDetailPresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/24.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "PropTrustorsInfoEntity.h"
#import "PropTrustorsInfoForShenZhenEntity.h"
#import "CheckPermissionInstantiation.h"
#import "DascomUtil.h"
#import "PropPageDetailEntity.h"
#import "CheckRealSurveyEntity.h"
#import "EditHouseVO.h"

@class BYActionSheetView;

@interface AllRoundDetailPresenter : BasePresenter

@property (retain,nonatomic) id<CheckPermissionProtocol> permissionDelegate;

@property (strong, nonatomic) PropTrustorsInfoEntity *trustorEntity;

@property (nonatomic, copy) NSString *propKeyId;

@property (assign, nonatomic) id  selfView;
@property (strong, nonatomic) PropPageDetailEntity *propDetailEntity;

- (instancetype)initWithDelegate:(id)delegate;

/// 获得数据源
- (void)getDataSource:(NSDictionary *)trustorDic;

/// 是否可以直接查看房号
- (BOOL)isAllHouseNum;

//是否显示拼接的房源字段
- (BOOL)isShowPinPropertyTitle;

/// 是否需要查看实勘保护期
- (BOOL)isCheckRealProtected;

/// 是否需要检查房源状态
- (BOOL)isCheckPropertyStatus;

// 拨打联系人提示语
- (NSString *)callTrustorsMsgSelectIndex:(NSInteger)selectIndex;

// 是否使用虚拟号
- (BOOL)isCallVirtualPhone;

/// 使用虚拟号拨打电话
- (void)callVirtualPhoneSelectIndex:(NSInteger)selectIndex
                           andMobil:(NSString *)mobile
                       andPropKeyId:(NSString *)propKeyId
                      andPropertyNo:(NSString *)propertyNo;

/// 是否使用得实达康
- (BOOL)isUseDascom;

/// 是否可以显示联系人 (查看联系人剩余次数)
- (NSString *)showTrustorsErrorMsg;

/// 获取联系人列表对话框的姓名数组
- (NSArray *)getTrustorsName;

/// 获得拨打次数
- (NSInteger)getCallLimit;

/// 获得应拨打的电话
- (NSString *)getCallNumSelectIndex:(NSInteger)selectIndex;

// 右上角"更多"
- (NSArray *)rightNavTitleArr:(NSString *)isCollection;

/// 是否有权限查看联系人列表
- (BOOL)canViewTrustors:(NSString *)deptPerm;

/// 是否有查看通话记录权限
- (BOOL)haveCallRecordPermission;

/// 是否有查看房源跟进权限
- (BOOL)canViewFollowList:(NSString *)deptPerm;

/// 添加实勘权限
- (BOOL)canAddUploadrealSurvey:(NSString *)deptPerm;

/// 查看实勘权限
- (BOOL)canViewUploadrealSurvey:(NSString *)deptPerm;

/// 是否有查看钥匙
- (BOOL)canViewPropKey:(NSString *)deptPerm;

/// 是否含有装修情况、实用面积、建筑面积、房屋用途
- (BOOL)haveSquareOrSquareUseOrDecorationSituationOrPropertyUsage;

///  含有装修情况、实用面积、建筑面积、房屋用途时所增加的高度
- (float)haveSquareOrSquareUseOrDecorationSituationOrPropertyUsageAddHight;

/// 签约/独家
- (NSString *)getOnlyTrustString;

/// 点击发布房源时是否需要验证房源面积
- (EditHouseVO *)needCheckHouseSquare:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证房源价格(租价, 售价)
- (EditHouseVO *)needCheckHousePrice:(PropPageDetailEntity *)propDetailEntity
                        andTrustType:(NSString *)trustType
             andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证房屋朝向
- (EditHouseVO *)needCheckHouseDirection:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证产权性质
- (EditHouseVO *)needCheckHousePropertyRight:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证房屋用途
- (EditHouseVO *)needCheckHousePropertyType:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证楼层
- (EditHouseVO *)needCheckHouseFloor:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证实勘
- (EditHouseVO *)needCheckHouseRealSurvey:(CheckRealSurveyEntity *)checkRealSurveyEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 点击发布房源时是否需要验证户型/房型
- (EditHouseVO *)needCheckHouseRoomType:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity;

/// 获得跟进pagesize
- (NSString *)getPageSize;

// 获取房源详情的详情字段
- (NSArray *)getDetailLeftArrayWithTrustType:(NSInteger)trustType;

//获取房源详情的详情数据
- (NSArray *)getDetailRightArrayWithEntity:(PropPageDetailEntity *)entity;


@end
