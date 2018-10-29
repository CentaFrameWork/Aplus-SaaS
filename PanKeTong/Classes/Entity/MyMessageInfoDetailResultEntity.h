//
//  MyMessageInfoDetailResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/12/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface MyMessageInfoDetailResultEntity : SubBaseEntity

@property (nonatomic,strong)NSString * keyId;
@property (nonatomic,strong)NSString * messageKeyId;
@property (nonatomic,strong)NSString * senderKeyId;
@property (nonatomic,strong)NSString * senderNo;
@property (nonatomic,strong)NSString * senderName;
@property (nonatomic,strong)NSString * senderPhotoPath;
@property (nonatomic,strong)NSString * msgContent;
@property (nonatomic,strong)NSString * msgTime;
@property (nonatomic,assign)NSInteger messageType;
@property (nonatomic,strong)NSString * secondMessagerName;
@property (nonatomic,strong)NSString * secondMessagerPhotoPath;
@property (nonatomic,strong)NSString * secondEmployeeNo;
@property (nonatomic,strong)NSString * propertyKeyId;
@property (nonatomic,strong)NSString * inquiryKeyId;

@end
