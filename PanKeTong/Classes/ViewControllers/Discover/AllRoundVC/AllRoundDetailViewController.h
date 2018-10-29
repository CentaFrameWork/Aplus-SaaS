//
//  AllRoundDetailViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
//#import "PropKeyListViewController.h"
#import "OnlyTrustViewController.h"
#import "RealListViewController.h"
#import "DascomUtil.h"
#import "PropTrustorsInfoEntity.h"
#import "CustomActionSheet.h"
#import "CallRealPhoneLimitUtil.h"
#import "PropPageDetailEntity.h"
#import "PropKeyViewController.h"

@class PropertysModelEntty;

@protocol EditRefreshDelegate <NSObject>

- (void)editRefresh:(PropPageDetailEntity *)entity;

@end

@interface AllRoundDetailViewController : BaseViewController<DascomCallProtocol,UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *takeSeeCount;         // 带看次数
@property (nonatomic, copy) NSString *propKeyId;
@property (nonatomic, copy) NSString *propTrustType;        // 委托类型（出售=1、出租=2、租售=3）
@property (nonatomic, copy) NSString *propNameStr;          // 房源名称
@property (nonatomic, copy) NSString *propBuildingName;     // 栋座名称
@property (nonatomic, copy) NSString *propHouseNo;          // 房号
@property (nonatomic, copy) NSString *propImgUrl;           // 房源图片地址
@property (nonatomic, copy) NSString *propertyStatus;       // 房源状态
@property (nonatomic, assign) BOOL isHasRegisterTrusts;     // 是否是委托房源

@property (nonatomic, strong) PropertysModelEntty *propModelEntity;

@property (nonatomic, assign) id <EditRefreshDelegate> myDelegate;

@end
