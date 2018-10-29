//
//  PropertyDetailVC.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseViewController.h"
#import "PropertysModelEntty.h"
#import "PropPageDetailEntity.h"

@protocol EditRefreshDelegate <NSObject>

@optional
- (void)editRefresh:(PropPageDetailEntity *)entity;

@end

typedef void(^CollectBtnClickBlock)(BOOL isSelect);

/// 房源详情
@interface PropertyDetailVC : BaseViewController

@property (nonatomic, strong) PropertysModelEntty * propModelEntity;

@property (nonatomic, copy) NSString *propKeyId;
@property (nonatomic, copy) NSString *propTrustType;
@property (nonatomic, copy) NSString *propEstateName;       // 房源楼盘名称
@property (nonatomic, copy) NSString *propBuildingName;     // 栋座名称
@property (nonatomic, copy) NSString *propHouseNo;          // 房号
@property (nonatomic, copy) NSString *propImgUrl;           // 房源图片地址
@property (nonatomic, copy) NSString *propertyStatus;       // 房源状态
@property (nonatomic, assign) BOOL isFollowRecord;     // 是否是委托房源

@property (nonatomic, assign) id <EditRefreshDelegate> myDelegate;
@property (nonatomic, copy) CollectBtnClickBlock block;     // 收藏按钮点击事件回调


@end
