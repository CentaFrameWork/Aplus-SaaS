//
//  RCIMUserDataSource.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RCIMUserDataSource.h"
#import "StaffInfoEntity.h"


typedef void (^GetUserCompletion)(RCUserInfo *);

@implementation RCIMUserDataSource
{
    
    RequestManager *_manager;
    GetStaffMsgApi *_getStaffMsgApi;

    GetUserCompletion _completionBlock;  //获取消息完成的block
    
    NSString *_userId;  //对方userid
}

+ (RCIMUserDataSource *)shareUserDataSource
{
    
    static RCIMUserDataSource *instance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}


/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
#pragma mark - RCIMUserInfoFetcherDelegagte
- (void)getUserInfoWithUserId:(NSString *)userId
                  completion:(void (^)(RCUserInfo *))completion
{
    
    if ([userId hasPrefix:@"s_"]) {
        //聊天对象是同事，经纪人userId的命名规则：“s_citycode_staffno”
        
        //截掉前面的“s_”只留后面的citycode和staffno
        NSString *cityCodeAndStaffNo = [userId substringFromIndex:2];
        
        //下划线的位置，用来截取城市和员工编号
        NSInteger lineStrIndex = 0;
        
        for (int i = 0; i <cityCodeAndStaffNo.length; i ++) {
            
            NSString *subStr = [cityCodeAndStaffNo substringWithRange:NSMakeRange(i, 1)];
            
            if ([subStr isEqualToString:@"_"]) {
                
                lineStrIndex = i;
                
                break;
            }
        }
        
        NSString *cityCode = [cityCodeAndStaffNo substringWithRange:NSMakeRange(0, lineStrIndex)];     //经纪人所在城市
        NSString *staffNo = [cityCodeAndStaffNo substringFromIndex:lineStrIndex+1];    //经纪人编号


        _manager = [RequestManager initManagerWithDelegate:self];
        _getStaffMsgApi = [[GetStaffMsgApi alloc] init];
        _getStaffMsgApi.staffNo = staffNo;
        _getStaffMsgApi.cityCode = cityCode;
        [_manager sendRequest:_getStaffMsgApi];

        _completionBlock = completion;
        _userId = userId;
        
    }else if ([userId hasPrefix:@"u_"]){
        /**
         *  聊天对象是用户，名称显示规则：客户：userId
         */
        
        NSString *realUserId = [userId substringFromIndex:2];
        NSString *userName = [NSString stringWithFormat:@"客户:%@",realUserId];
        
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:userName
                                                        portrait:DefaultChatUserIcon];
        
        completion(userInfo);
        
    }else{
        
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:userId
                                                        portrait:DefaultChatUserIcon];
        
        completion(userInfo);
    }
}


#pragma mark - <ResponseDelegate>
- (void)respSuc:(id)data andRespClass:(id)cls{
    if ([cls isEqual:[StaffInfoEntity class]]) {

        StaffInfoEntity *staffInfoEntity = [DataConvert convertDic:data toEntity:cls];
        StaffInfoResultEntity *resultEntity = staffInfoEntity.result;

        RCUserInfo *staffInfo = [[RCUserInfo alloc]initWithUserId:_userId
                                                             name:resultEntity.cnName
                                                         portrait:resultEntity.agentUrl];

        _completionBlock(staffInfo);
    }


}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    RCUserInfo *staffInfo = [[RCUserInfo alloc]initWithUserId:_userId
                                                         name:_userId
                                                     portrait:nil];

    _completionBlock(staffInfo);

}



@end
