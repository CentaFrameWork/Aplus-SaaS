//
//  HQAllRoundDetailVC.h
//  CalenderDemo
//
//  Created by 李慧娟 on 16/11/23.
//  Copyright © 2016年 ZHY. All rights reserved.
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


@interface HQAllRoundDetailVC : BaseViewController<DascomCallProtocol,UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,UIAlertViewDelegate>

@property (nonatomic,copy)NSString *propKeyId;
@property (nonatomic,copy)NSString *propTrustType;       //委托类型（出售=1、出租=2、租售=3）
@property (nonatomic,copy)NSString *propNameStr;         //房源名称
@property (nonatomic,copy) NSString *propBuildingName;    //栋座名称
@property (nonatomic,copy) NSString *propHouseNo;         //房号

@property (nonatomic,copy) NSString *propImgUrl;          //房源图片地址

@property (nonatomic,copy) NSString *propertyStatus;      //房源状态

@property (strong,nonatomic)PropertysModelEntty *propModelEntity;

@property (nonatomic, copy)NSString *isMacau;


@end
