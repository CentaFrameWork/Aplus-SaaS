//
//  AuditingRecordVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/23.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

///部门权限范围
enum TrustsAuditStatusEnum
{
    PendingAudit  = 0, //待审核
    AuditAdopt = 1, //审核通过
    AuditRefuse = 2, // 审核拒绝
};

///委托审核记录
@interface AuditingRecordVC : BaseViewController

@property (nonatomic,assign) int regTrustsAuditStatus;// (0-待审核  1-审核通过  2-审核拒绝)
@property (nonatomic,copy) NSString *trustAuditPersonName;// 审核人名称
@property (nonatomic,copy) NSString *trustAuditDate;// 审核日期
@property (nonatomic,copy) NSString *refuseReason;// 拒绝理由

@end
