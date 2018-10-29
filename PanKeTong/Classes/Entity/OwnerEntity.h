//
//  OwnerEntity.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

@interface OwnerEntity : SubBaseEntity

@property (nonatomic, copy)NSString *keyId; // 对象keyid (Nullable`1)
@property (nonatomic, copy)NSString *trustorName;// 委托人姓名 (String)
@property (nonatomic, copy)NSString *trustorType;// 委托人类型 (String)
@property (nonatomic, copy)NSString *mobile;// 联系方式 (String)
@property (nonatomic, copy)NSString *tel;// 联系方式 (String)
@property (nonatomic, copy)NSString *remark;// 备注 (String)
@property (nonatomic, copy)NSString *lastCallTime;// 上次通话时间 (Nullable`1)
@property (nonatomic, copy)NSString *maxCallerTimespan;// 最长通话时间 (String)
@property (nonatomic, copy)NSString *callCount;// 接通次数 (Nullable`1)
@property (nonatomic, copy)NSString *noCallerCount;// 未接通次数 (Nullable`1)
@property (nonatomic, copy)NSString *shortCount;// 短号数量 (Nullable`1)
@property (nonatomic, copy)NSString *longCount;// 长号数量 (Nullable`1)
@property (nonatomic, copy)NSString *shortCallMobile ;// 虚拟短号手机 (String)
@property (nonatomic, copy)NSString *shortCallTel;// 虚拟短号座机 (String)
@property (nonatomic, copy)NSString *longCallMobile;// 虚拟长号手机 (String)
@property (nonatomic, copy)NSString *longCallTel;// 虚拟长号座机 (String)

@end
