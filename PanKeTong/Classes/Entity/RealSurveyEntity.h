//
//  RealSurveyEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface RealSurveyEntity : SubBaseEntity

/// <summary>
/// 实勘人
/// </summary>
@property (nonatomic,strong) NSString *realSurveyPerson;
/// <summary>
/// 实堪时间
/// </summary>
@property (nonatomic,strong) NSString *realSurveyTime;
/// <summary>
/// 实堪状态
/// </summary>
@property (nonatomic,strong) NSString *auditStatus;
/// <summary>
/// 实堪图数量
/// </summary>
@property (nonatomic,strong) NSString *photoCount;
/// <summary>
/// 实堪id
/// </summary>
@property (nonatomic,strong) NSString *keyId;

/// 是否有视频
@property (nonatomic,strong) NSString *isVideo;

@end
