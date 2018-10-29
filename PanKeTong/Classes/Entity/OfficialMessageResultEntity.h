//
//  OfficialMessageResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseEntity.h"

#define DATABASE_ALREAY_OFFICIAL_MESSAGE_TABLE_NAME @"official_message"

@interface OfficialMessageResultEntity : BaseEntity

@property (nonatomic,assign)NSInteger infoId;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * infoContent;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,strong)NSString * updateTime;
@property (nonatomic,strong)NSString * companyCode;
@property (nonatomic,strong)NSString * staffNo;
@property (nonatomic,strong)NSString * pushPlatform;
@property (nonatomic,strong)NSString * pushClientVer;

//修改UI新增字段，是否已阅读
@property (nonatomic, assign) BOOL isRead;

@end
