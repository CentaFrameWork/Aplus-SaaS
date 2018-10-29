//
//  MyMessageResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/12/1.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface MyMessageResultEntity : SubBaseEntity

@property (nonatomic,strong)NSString * keyId;
@property (nonatomic,strong)NSString * lastMsgContent;
@property (nonatomic,strong)NSString * lastMsgTime;
@property (nonatomic,strong)NSString * notReadCount;
@property (nonatomic,strong)NSString * secondMessagerImageUrl;
@property (nonatomic,strong)NSString * secondMessagerKeyId;
@property (nonatomic,strong)NSString * secondMessagerName;
@property (nonatomic,strong)NSString * waitReply;


@end
