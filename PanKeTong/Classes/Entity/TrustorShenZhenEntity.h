//
//  TrustorShenZhenEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/20.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface TrustorShenZhenEntity : SubBaseEntity

@property (nonatomic,copy) NSString *trustorName;             //- 委托人姓名 (String)
@property (nonatomic,copy) NSString *trustorType;             //- 委托人类型 (String)
@property (nonatomic,copy) NSString *mobile;                  //- 联系方式 (String)
@property (nonatomic,copy) NSString *tel;                     //- 联系方式 (String)
@property (nonatomic,copy) NSString *remark;                  //- 备注 (String)
@property (nonatomic,copy) NSString *lastCallTime;            //- 上次通话时间 (Nullable`1)
@property (nonatomic,copy) NSString *maxCallerTimespan;       //- 最长通话时间 (String)
@property (nonatomic,strong) NSNumber *callCount;               //- 接通次数 (Nullable`1)
@property (nonatomic,strong) NSNumber *noCallerCount;           //- 未接通次数 (Nullable`1)
@property (nonatomic,strong) NSNumber *shortCount;              //- 短号数量 (Nullable`1)
@property (nonatomic,strong) NSNumber *longCount;               //- 长号数量 (Nullable`1)
@property (nonatomic,copy) NSString *shortCallMobile;         //- 虚拟短号手机 (String)
@property (nonatomic,copy) NSString *shortCallTel;            //- 虚拟短号座机 (String)
@property (nonatomic,copy) NSString *longCallMobile;          //- 虚拟长号手机 (String)
@property (nonatomic,copy) NSString *longCallTel;             //- 虚拟长号座机 (String)
@property (nonatomic, copy)NSString *keyId;                     //联系人id
@end
