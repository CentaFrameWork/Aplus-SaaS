//
//  PropTrustorsInfo.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "TrustorEntity.h"

@interface PropTrustorsInfo : AgencyBaseEntity

// <summary>
/// 是否可以查看,剩余查看业主联系方式次数不足时不能查看业主联系信息，返回的业主信息列表为空列表
/// </summary>
@property (nonatomic,assign) BOOL canBrowse;

/// <summary>
/// 免扰信息
/// </summary>
@property (nonatomic,strong) NSString *noCallMessage;

/// <summary>
/// 今日当前用户：已查看业主联系方式次数
/// </summary>
@property (nonatomic,assign) NSInteger usedBrowseCount;

/// <summary>
/// 今日当前用户：剩余查看业主联系方式次数
/// </summary>
@property (nonatomic,assign) NSInteger remainingBrowseCount;

/// <summary>
/// 今日当前用户：查看业主联系方式次数配额
/// </summary>
@property (nonatomic,assign) NSInteger totalBrowseCount;

/// <summary>
/// 业主信息列表
/// </summary>
@property (nonatomic,assign) NSArray *trustors;

@end
