//
//  APPConfigEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/4.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseEntity.h"

@interface APPLocationEntity : SubBaseEntity

@property (nonatomic, strong) NSNumber *relationId;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *showLocation;
@property (nonatomic, assign) NSInteger configId;
@property (nonatomic, strong) NSNumber *dispIndex;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, strong) NSNumber *jumpType;
@property (nonatomic, copy) NSString *jumpContent;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *iconFrame;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *mDescription;

@end

@interface APPConfigEntity : BaseEntity

@property (nonatomic, strong) NSArray *result;

@end
