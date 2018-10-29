//
//  AppendInfoBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/9.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AppendInfoBasePresenter.h"
#import "AddPropertyFollowApi.h"

@implementation AppendInfoBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}

- (void)getContactsInfoAndDepartInfo:(NSArray *)personArr
{
    _contactsNameArr = [[NSMutableArray alloc]init];
    _contactsKeyIdArr = [[NSMutableArray alloc]init];
    
    _informDepartsNameArr = [[NSMutableArray alloc]init];
    _informDepartsKeyIdArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < personArr.count; i++) {
        
        RemindPersonDetailEntity *remindPersonEntity = [personArr objectAtIndex:i];
        
        if ([remindPersonEntity.departmentKeyId isEqualToString:
             remindPersonEntity.resultKeyId]) {
            
            //部门
            [_informDepartsNameArr addObject:remindPersonEntity.resultName];
            [_informDepartsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }else{
            
            //人员
            [_contactsNameArr addObject:remindPersonEntity.resultName];
            [_contactsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }
    }
    

}

- (APlusBaseApi *)getRequestApi:(NSArray *)personArr
               andPropertyKeyId:(NSString *)propertyKeyId
           andAppendMessageType:(NSInteger)appendMessageType
               andFollowContent:(NSString *)followContent
                     andMsgTime:(NSString *)msgTime
{
    [self getContactsInfoAndDepartInfo:personArr];
    
    NSString *followTypeStr = [[NSString alloc] init];
    if (appendMessageType == PropertyFollowTypeInfoAdd) {
        followTypeStr = [NSString stringWithFormat:@"%ld",(long)appendMessageType];
    }else{
        followTypeStr = [NSString stringWithFormat:@"%ld",(long)appendMessageType];
    }
    
    AddPropertyFollowApi *addPropertyFollowApi = [[AddPropertyFollowApi alloc] init];
    addPropertyFollowApi.followType = followTypeStr;
    addPropertyFollowApi.contactsName = self.contactsNameArr;
    addPropertyFollowApi.informDepartsName = self.informDepartsNameArr;
    addPropertyFollowApi.followContent = followContent;//
    addPropertyFollowApi.targetPropertyStatusKeyId = @"";
    addPropertyFollowApi.trustorTypeKeyId = @"";
    addPropertyFollowApi.trustorName = @"";
    addPropertyFollowApi.trustorGenderKeyId = @"";
    addPropertyFollowApi.mobile = @"";
    addPropertyFollowApi.keyId = propertyKeyId;
    addPropertyFollowApi.msgUserKeyIds = self.contactsKeyIdArr;
    addPropertyFollowApi.msgDeptKeyIds = self.informDepartsKeyIdArr;
    addPropertyFollowApi.msgTime = msgTime ? msgTime : @"";
    
    return addPropertyFollowApi;
}

/// 是否含有提醒时间功能
- (BOOL)haveReminderTimeFunction
{
    return YES;
}

/// 是否含有提醒人
- (BOOL)haveRemindPeople
{
    return YES;
}

/// 是否含有快捷输入模块
- (BOOL)haveQuickInputModule
{
    return NO;
}

/// 提醒人是否屏蔽自己
- (BOOL)isExceptMe
{
    return NO;
}
@end
