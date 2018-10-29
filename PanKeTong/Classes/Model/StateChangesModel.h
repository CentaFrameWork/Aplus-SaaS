//
//  StateChangesModel.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateChangesModel : NSObject
/*
 {
 D: ║     "IsFollow": false,
 D: ║     "IsClearKey": true,
 D: ║     "IsClearTrust": true,
 D: ║     "FollowType": 3,
 D: ║     "KeyId": "f881b0db-0135-cb49-25ce-08d56fbe5fcc", // 从上页传
 D: ║     "TargetPropertyStatusKeyId": "238871cd-786e-4aea-b0a1-fa8c69a19b10",   // 写死的两个状态
 D: ║     "FollowContent": "测试跟进123456",
 D: ║     "MsgDeptKeyIds": [],
 D: ║     "InformDepartsName": [],
 D: ║     "MsgUserKeyIds": [],
 D: ║     "ContactsName": []
 D: ║ }
 */
@property (nonatomic, assign)BOOL isClearFollw;
@property (nonatomic, assign)BOOL isClearKey;
@property (nonatomic, assign)BOOL isClearTrust;
@property (nonatomic, assign)int followType;
@property (nonatomic, strong)NSString *keyId;
@property (nonatomic, strong)NSString *targetPropertyStatusKeyId;
@property (nonatomic, strong)NSString *followContent;
@property (nonatomic, strong)NSArray *msgDeptKeyIds;
@property (nonatomic, strong)NSArray *informDepartsName;
@property (nonatomic, strong)NSArray *msgUserKeyIds;
@property (nonatomic, strong)NSArray *contactsName;

+ (NSDictionary *)dictWithModel:(StateChangesModel *)model;

@end
