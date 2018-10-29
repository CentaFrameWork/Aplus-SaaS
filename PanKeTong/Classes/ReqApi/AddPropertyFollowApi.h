//
//  AddPropertyFollowApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"

/// 添加跟进
@interface AddPropertyFollowApi : APlusBaseApi

@property (nonatomic, copy) NSString *followType;                     // 跟进类型枚举值 ;
@property (nonatomic, strong)NSArray *contactsName;                  // 联系人名称集合;
@property (nonatomic, strong)NSArray *informDepartsName;             // 要通知部门名称;
@property (nonatomic, copy)NSString *followContent;                  // 跟进内容;
@property (nonatomic, copy)NSString *targetPropertyStatusKeyId;      // 目标房源状态KeyId ;
@property (nonatomic, copy)NSString *trustorTypeKeyId;               // 委托人类型KeyId;
@property (nonatomic, copy)NSString *trustorName;                    // 委托人姓名;
@property (nonatomic, copy)NSString *trustorGenderKeyId;             // 委托人性别;
@property (nonatomic, copy)NSString *mobile;                         // 委托人手机;
@property (nonatomic, strong)NSArray *msgUserKeyIds;                 // 跟进站内信对应人;
@property (nonatomic, strong)NSArray *msgDeptKeyIds;                 // 跟进站内信对应部门 ;
@property (nonatomic, copy)NSString *keyId;                          // KeyId;
@property (nonatomic, copy)NSString *msgTime;

@end
