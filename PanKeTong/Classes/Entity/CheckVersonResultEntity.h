//
//  CheckVersonResultEntity.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface CheckVersonResultEntity : SubBaseEntity

@property (nonatomic,strong) NSString *platform;        //平台
@property (nonatomic,strong) NSString *clientVer;       //版本
@property (nonatomic,strong) NSString *channer;         //渠道
@property (nonatomic,assign) NSInteger forceUpdate;     //强制更新（1：强制更新，0：不强制更新）
@property (nonatomic,strong) NSString *updateUrl;       //下载地址
@property (nonatomic,strong) NSString *updateContent;   //更新内容
@property (nonatomic,strong) NSString *createTime;      //创建时间

@end
