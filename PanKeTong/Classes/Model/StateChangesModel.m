//
//  StateChangesModel.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "StateChangesModel.h"

@implementation StateChangesModel

+ (NSDictionary *)dictWithModel:(StateChangesModel *)model {
    
    /*
     BOOL isClearFollw;
     BOOL isClearKey;
     BOOL isClearTrust;
     int followType;
     NSString *keyId;
     NSString *targetPropertyStatusKeyId;
     NSString *followContent;
     NSArray *msgDeptKeyIds;
     NSArray *informDepartsName;
     NSArray *msgUserKeyIds;
     NSArray *contactsName;
     */
    
    NSDictionary *dict;
    dict = @{
             @"IsClearFollw":@(model.isClearFollw),
             @"IsClearKey":@(model.isClearKey),
             @"IsClearTrust":@(model.isClearTrust),
             @"FollowType":@(model.followType),
             @"KeyId":model.keyId == nil?@"":model.keyId,
             @"TargetPropertyStatusKeyId":model.targetPropertyStatusKeyId == nil?@"":model.targetPropertyStatusKeyId,
             @"FollowContent":model.followContent == nil?@"":model.followContent,
             @"MsgDeptKeyIds":model.msgDeptKeyIds == nil?@[]:model.msgDeptKeyIds,
             @"InformDepartsName":model.informDepartsName == nil?@[]:model.informDepartsName,
             @"MsgUserKeyIds":model.msgUserKeyIds == nil?@[]:model.msgUserKeyIds,
             @"ContactsName":model.contactsName == nil?@[]:model.contactsName
             };
    
    return dict;
}

@end
