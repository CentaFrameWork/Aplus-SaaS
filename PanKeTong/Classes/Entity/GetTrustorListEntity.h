//
//  GetTrustorListEntity.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface GetTrustorListEntity : AgencyBaseEntity


/// <summary>
/// 业主信息列表
/// </summary>
@property (nonatomic,strong) NSArray *trustors;

@end
