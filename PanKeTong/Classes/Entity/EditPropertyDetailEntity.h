//
//  EditPropertyDetailEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface EditPropertyDetailEntity : AgencyBaseEntity

@property (nonatomic,copy)NSString *salePrice;/// 售价
@property (nonatomic,copy)NSString *rentPrice;/// 租价
@property (nonatomic,copy)NSString *houseDirectionKeyId;/// 朝向
@property (nonatomic,copy)NSString *propertyRightNatureKeyId;/// 产权性质KeyId
@property (nonatomic,copy)NSString *square;/// 面积
@property (nonatomic,copy)NSString *squareUse;/// 实用面积
@property (nonatomic,copy)NSString *propertyChiefKeyId;/// 房源所属人KeyId
@property (nonatomic,copy)NSString *propertyChiefDepartmentKeyId;/// 房源所属部门KeyId
@property (nonatomic,strong)NSNumber *propertyStatusCategory;/// 房源状态四大分类枚举：1-有效，2-暂缓，3-预定，4-无效
@property (nonatomic,copy)NSString *propertyUsageKeyId;/// 物业用途
@property (nonatomic,strong)NSNumber *isLockSquare;/// 是否锁定面积


@end
