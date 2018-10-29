//
//  PublishEstDetailEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PublishEstDetailEntity : SubBaseEntity

@property (nonatomic,strong) NSString *trustType;
@property (nonatomic,strong) NSString *trustTypeName;
@property (nonatomic,strong) NSString *estateName;
@property (nonatomic,strong) NSString *buildingName;
@property (nonatomic,strong) NSString *houseNo;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *keyId;

@end
