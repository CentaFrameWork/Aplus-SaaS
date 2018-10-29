//
//  PropTrustorsInfoForShenZhenEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/20.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"
#import "TrustorShenZhenEntity.h"

@interface PropTrustorsInfoForShenZhenEntity : AgencyBaseEntity

@property (nonatomic,assign) BOOL canBrowse;                    //- 是否可以查看,剩余查看业主联系方式次数不足时不能查看业主联系信息，返回的业主信息列表为空列表 (Boolean)
@property (nonatomic,strong) NSString *noCallMessage;           //- 免扰信息 (String)
@property (nonatomic,strong) NSNumber *usedBrowseCount;         //- 今日当前用户：已查看业主联系方式次数 (Int32)
@property (nonatomic,strong) NSNumber *remainingBrowseCount;    //- 今日当前用户：剩余查看业主联系方式次数 (Int32)
@property (nonatomic,strong) NSNumber *totalBrowseCount;        //- 今日当前用户：查看业主联系方式次数配额 (Int32)
@property (nonatomic,strong) NSString *telephoneExchange;       //- 接入总机号 (String)
@property (nonatomic,strong) NSArray *trustors;                 //- 联系人列表


/// <summary>
/// 开关虚拟拨号(专属移动端)
/// </summary>
@property (nonatomic, copy)NSString *virtualCall;

/// <summary>
/// 虚拟拨号关闭下，可拨打业主电话数
/// </summary>
@property (nonatomic, copy)NSString *callLimit;
@end
