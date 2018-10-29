//
//  PublishCusDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PublishCusDetailEntity : SubBaseEntity

@property (nonatomic,strong) NSString *inquiryTradeType;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *districts;
@property (nonatomic,strong) NSString *targetEstateName;
@property (nonatomic,strong) NSString *roomType;
@property (nonatomic,strong) NSString *keyId;

@end
