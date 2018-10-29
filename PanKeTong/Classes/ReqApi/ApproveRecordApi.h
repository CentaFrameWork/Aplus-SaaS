//
//  ApproveRecordApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/1.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///通过拒绝委托
@interface ApproveRecordApi : APlusBaseApi

/*
 RegTrustsAuditStatus - 业主委托状态 (Nullable`1)(通过1 拒绝2)
 IsCredentials - 是否证件齐全 (Nullable`1)（是：true 不是：false）
 Reject - 拒绝理由 (String)
 KeyId - KeyId (Nullable`1)委托KeyID
 */


@property (nonatomic,copy) NSString *keyId;
@property (nonatomic,strong) NSNumber *regTrustsAuditStatus;
@property (nonatomic,copy) NSString *isCredentials;
@property (nonatomic,copy) NSString *reject;

@end
