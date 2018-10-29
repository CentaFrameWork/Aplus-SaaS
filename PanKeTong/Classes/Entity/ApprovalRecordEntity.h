//
//  ApprovalRecordEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AgencyBaseEntity.h"

@interface ApprovalRecordEntity : AgencyBaseEntity

@property (nonatomic,copy)NSString *approvalStatus;//审核状态
@property (nonatomic,copy)NSString *auditorName;//审核人名称
@property (nonatomic,copy)NSString *time;//审核时间
@property (nonatomic,copy)NSString *refuseReason; // 拒绝理由


@end
