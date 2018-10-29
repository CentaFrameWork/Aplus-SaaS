//
//  PublishEstDetailPageMsgEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface PublishEstDetailPageMsgEntity : AgencyBaseEntity

@property (nonatomic, copy) NSString *estateName;
@property (nonatomic, copy) NSString *buildingName;
@property (nonatomic, copy) NSString *houseNo;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *saleUnitPrice;
@property (nonatomic, copy) NSString *rentPrice;
@property (nonatomic, copy) NSString *square;
@property (nonatomic, copy) NSString *squareUse;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *roomType;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *houseDirection;
@property (nonatomic, copy) NSString *propertyRightNature;
@property (nonatomic, copy) NSString *propertySourceName;
@property (nonatomic, copy) NSString *propertySituation;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *districtName;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *trustTypeName;
@property (nonatomic, copy) NSString *propertyCardDate;
@property (nonatomic, copy) NSString *propertyStatus;

@end
