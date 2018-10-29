//
//  InquiryFollowAddApi.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

@interface InquiryFollowAddApi : APlusBaseApi

@property (nonatomic, copy) NSString *content; // - 反馈 (String)
@property (nonatomic, copy) NSString *custumerKeyId; // - 客户 (Nullable`1)
@property (nonatomic, copy) NSString *inquiryKeyId; // - 客源 (Nullable`1)
@property (nonatomic, copy) NSString *followTypeKeyId; // - 跟进类型 (Nullable`1)
@property (nonatomic, copy) NSString *followTypeCode; // - 跟进类型编码 (String)
@property (nonatomic, strong) NSArray *msgUserKeyIds;//提醒人keyIds;
@property (nonatomic, strong) NSArray *msgDeptKeyIds;//提醒部门keyIds;
@property (nonatomic, strong) NSArray *contactsName;//提醒人名称集合
@property (nonatomic, strong) NSArray *informDepartsName;//提醒部门名称集合
@property (nonatomic, copy) NSString *msgTime;// - 提醒时间 (Nullable`1)

@end
