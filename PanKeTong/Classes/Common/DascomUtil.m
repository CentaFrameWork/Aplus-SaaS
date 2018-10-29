//
//  DascomUtil.m
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "DascomUtil.h"
#import "DascomChangePhoneNumberApi.h"
#import "DascomGetNumbeApi.h"
#import "DascomGetPhoneEntity.h"
#import "DascomGetPhoneDicBodyEntity.h"
#import "DascomReceiveNumberEntity.h"

@implementation DascomUtil
{
    NSString *_phoneNumber;
    DascomGetNumbeApi *_dascomGetNumbeApi;
    DascomResponseFinishedBlock _dascomRequestFinishedBlock;
}

static DascomUtil *dascomUtil;
static RequestManager *manager;

+ (DascomUtil *)shareDascomUtil
{
    @synchronized (self) {
        
        if (dascomUtil== nil) {
            
            dascomUtil= [[self alloc] init];
            manager = [RequestManager initManagerWithDelegate:dascomUtil];

        }
    }
    

    return dascomUtil;
}

+ (void)setMsisdn:(NSString *)msisdn
{
    [CommonMethod setUserdefaultWithValue:msisdn forKey:Msisdn];
}

+ (NSString *)getMsisdn
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sisdn = [userDefault valueForKey:Msisdn];
    return sisdn;
}


/*
 *  获取手机号码
 */
- (void)requestMsisdn:(DascomResponseFinishedBlock)sss
{
    _dascomRequestFinishedBlock = sss;
    NSString *userId = [AgencyUserPermisstionUtil getIdentify].userNo;

    _dascomGetNumbeApi = [DascomGetNumbeApi new];
    _dascomGetNumbeApi.empNo = userId;
    [manager sendRequest:_dascomGetNumbeApi];
}

/**
 *  拨打虚拟号
 *
 *  @param callNumber 被叫号码
 *  @param propertyId 房源ID
 *  @param phoneID    业主ID
 */
- (void)callVirtualPhone:(NSString *)callNumber
             andProperty:(NSString *)propertyId
              andPhoneID:(NSString *)phoneID
                andEmpID:(NSString *)empID
               andDeptID:(NSString *)deptID
           andPropertyNo:(NSString *)propertyNo
{
    self.haveHint = false;
    [self requestSendCallNumber:callNumber
                    andProperty:propertyId
                     andPhoneID:phoneID
                       andEmpID:empID
                      andDeptID:deptID
                  andPropertyNo:propertyNo];
}

- (void)callVirtualPhone:(NSString *)callNumber
             andProperty:(NSString *)propertyId
              andPhoneID:(NSString *)phoneID
                andEmpID:(NSString *)empID
               andDeptID:(NSString *)deptID
             andDelegate:(id<DascomCallProtocol>)delegate
{
    self.haveHint = true;
    self.delegate = delegate;
    [self requestSendCallNumber:callNumber
                    andProperty:propertyId
                     andPhoneID:phoneID
                       andEmpID:empID
                      andDeptID:deptID
                  andPropertyNo:nil];
}

- (void)requestSendCallNumber:(NSString *)callNumber
                  andProperty:(NSString *)propertyId
                   andPhoneID:(NSString *)phoneID
                     andEmpID:(NSString *)empID
                    andDeptID:(NSString *)deptID
                andPropertyNo:(NSString *)propertyNo
{
    NSString *userId = [AgencyUserPermisstionUtil getIdentify].userNo;
    
    DascomSendCallNumberApi *sendCallNumberapi = [DascomSendCallNumberApi new];
    sendCallNumberapi.empNo = userId?userId:@"";
    sendCallNumberapi.callNumber = callNumber?callNumber:@"";
    sendCallNumberapi.propertyId = propertyId?propertyId:@"";
    sendCallNumberapi.phoneID = phoneID?phoneID:@"";
    sendCallNumberapi.empID = empID?empID:@"";
    sendCallNumberapi.deptID = deptID?deptID:@"";
    sendCallNumberapi.propertyNo = propertyNo;
    [manager sendRequest:sendCallNumberapi];
}

- (void)callPhone
{
    // 拨打前有提示
    if(self.haveHint){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[[BaseApiDomainUtil getApiDomain] getDascomNumber]];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",callNumber];
//        //            NSLog(@"str======%@",str);
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        if([self delegate]){
            [[self delegate] addCallPhoneView:callWebview];
        }
    }else{
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",[[BaseApiDomainUtil getApiDomain] getDascomNumber]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }

}

// 虚拟号配置获取
+ (void)requestConfig
{
    NSURL *url = [NSURL URLWithString:[[BaseApiDomainUtil getApiDomain] getVirtualCallUrl]];
//    NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
    
    VirtualConfigEntity *virtualConfigEntity = [MTLJSONAdapter modelOfClass:[VirtualConfigEntity class]
                                                     fromJSONDictionary:dic
                                                                  error:nil];
    
    NSNumber *virtualCallNum = [[NSNumber alloc]initWithInteger:virtualConfigEntity.virtualCall];
    [CommonMethod setUserdefaultWithValue:virtualCallNum forKey:@"virtualCall"];
    NSNumber *callLimitNum = [[NSNumber alloc]initWithInteger:virtualConfigEntity.callLimit];
    [CommonMethod setUserdefaultWithValue:callLimitNum forKey:@"callLimit"];

}

+ (BOOL)isVirtualCall
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *virtualCall = [userDefault valueForKey:@"virtualCall"];
    
    NSNumber *virtual = [[NSNumber alloc]initWithInt:1];
    NSNumber *real = [[NSNumber alloc]initWithInt:0];
    
    if([virtualCall isEqualToNumber:virtual]){
        return YES;
    }else if([virtualCall isEqualToNumber:real])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSInteger)getCallLimit
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *callLimit = [userDefault valueForKey:@"callLimit"];
    
    return [callLimit integerValue];
}

- (void)requestChangePhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    NSString *userId = [AgencyUserPermisstionUtil getIdentify].userNo;
    
    DascomChangePhoneNumberApi *changePhoneNumberApi = [DascomChangePhoneNumberApi new];
    changePhoneNumberApi.empNo = userId;
    changePhoneNumberApi.phoneNumber = phoneNumber;
    [manager sendRequest:changePhoneNumberApi sucBlock:^(id result) {
        
        DascomGetPhoneDicBodyEntity *dascomGetPhoneDicBodyEntity = [DataConvert convertDic:result toEntity:[DascomGetPhoneDicBodyEntity class]];

        if([dascomGetPhoneDicBodyEntity.mHeader.mResultCode isEqualToString:RESPONSE_SUC])
        {
            if([self delegate]){
                [DascomUtil setMsisdn:_phoneNumber];
                [[self delegate] changedPhoneNumber:_phoneNumber];
            }
        }
        else
        {
            [[self delegate] resultFail];
            showMsg(dascomGetPhoneDicBodyEntity.mHeader.mDiagnostic);
        }
        
    } failBlock:^(NSError *error) {
        
        [[self delegate] resultFail];
    }];
    

}




#pragma mark-ResponseDelegate

- (void)respSuc:(id)data andRespClass:(id)cls
{
    if ([cls isEqual:[DascomGetPhoneEntity class]])
    {
        NSDictionary *dic = (NSDictionary *)data;
        id bodyEntity = [dic objectForKey:@"body"];
        
        if ([bodyEntity isKindOfClass:[NSDictionary class]])
        {
            DascomGetPhoneDicBodyEntity *dascomGetPhoneEntity = [DataConvert convertDic:data toEntity:[DascomGetPhoneDicBodyEntity class]];
            
            [DascomUtil setMsisdn:@""];
            
            NSString *msg = [NSString stringWithFormat:@"未能获取员工报备号码，原因:%@于号盾系统", dascomGetPhoneEntity.mHeader.mDiagnostic];
            
            if (![_fromeVC isEqualToString:@"login"])
            {
                showMsg(msg);
            }
        }
        else
        {
            DascomGetPhoneEntity *dascomGetPhoneEntity = [DataConvert convertDic:data toEntity:[DascomGetPhoneEntity class]];
            if([dascomGetPhoneEntity.mHeader.mResultCode isEqualToString:RESPONSE_SUC])
            {
                DascomGetPhoneBodyEntity *body = (DascomGetPhoneBodyEntity *)dascomGetPhoneEntity.mBody[0];
                [DascomUtil setMsisdn:body.mMsisdn];
                
                _dascomRequestFinishedBlock();
            }else
            {
                if (![_fromeVC isEqualToString:@"login"])
                {
                    NSString *diagnostic = dascomGetPhoneEntity.mHeader.mDiagnostic;
                    
                    if ([diagnostic isEqualToString:@"员工编号不存在"])
                    {
                        diagnostic = [NSString stringWithFormat:@"未能获取员工报备号码，原因:%@于号盾系统",diagnostic];
                    }
                    
                    showMsg(diagnostic);
                }
            }
        }
        
    }
    else if([cls isEqual:[DascomReceiveNumberEntity class]])
    {
        DascomReceiveNumberEntity *dascomReceiveNumberEntity = [DataConvert convertDic:data toEntity:cls];
        
        if([dascomReceiveNumberEntity.mHeader.mResultCode isEqualToString:RESPONSE_SUC])
        {
            [self callPhone];
        }
        else
        {
            NSString *diagnostic = dascomReceiveNumberEntity.mHeader.mDiagnostic;
            
            if ([diagnostic isEqualToString:@"员工编号不存在"])
            {
                diagnostic = [NSString stringWithFormat:@"未能获取员工报备号码，原因:%@于号盾系统",diagnostic];
            }
            
            showMsg(diagnostic);
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    if ([self.delegate respondsToSelector:@selector(resultFail)]) {
        [self.delegate resultFail];
    }
}


@end
