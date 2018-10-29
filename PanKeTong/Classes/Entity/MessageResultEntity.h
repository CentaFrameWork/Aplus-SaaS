//
//  MessageResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface MessageResultEntity : SubBaseEntity

@property (nonatomic,strong)NSString * informationType;
@property (nonatomic,strong)NSString * informationTypeE;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * informationCategory;
@property (nonatomic,strong)NSString * keyId;//消息KeyID
@property (nonatomic,copy) NSString *sourceObjectKeyId;//房源／客源/成交keyID
@end
