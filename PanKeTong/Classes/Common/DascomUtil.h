//
//  DascomUtil.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgencyUserPermisstionUtil.h"
//#import "DascomService.h"
#import "DascomDefine.h"
#import "VirtualConfigEntity.h"
#import "DascomSendCallNumberApi.h"
#import "RequestManager.h"


typedef void (^DascomResponseFinishedBlock)(void);


@protocol DascomCallProtocol <NSObject>

- (void)addCallPhoneView:(UIView *)callView;
- (void)changedPhoneNumber:(NSString *)newPhoneNumber;
- (void)resultFail;

@end

/// 虚拟号Util
@interface DascomUtil : NSObject<ResponseDelegate>

@property (nonatomic, copy) NSString *fromeVC;
@property (nonatomic,assign) BOOL haveHint;
@property (nonatomic,assign) id <DascomCallProtocol> delegate;




+ (DascomUtil *)shareDascomUtil;

+ (void)setMsisdn:(NSString *)msisdn;
+ (NSString *)getMsisdn;

/**
 * 获取手机号码
 */
- (void)requestMsisdn:(DascomResponseFinishedBlock)sss;

/**
 *  拨打虚拟号
 *
 *  @param callNumber 被叫号码
 *  @param propertyId 房源ID
 *  @param phoneID    业主ID
 *  @param empID      员工id
 *  @param deptID     部门id
 */
- (void)callVirtualPhone:(NSString *)callNumber
             andProperty:(NSString *)propertyId
              andPhoneID:(NSString *)phoneID
                andEmpID:(NSString *)empID
               andDeptID:(NSString *)deptID
           andPropertyNo:(NSString *)propertyNo;

- (void)callVirtualPhone:(NSString *)callNumber
             andProperty:(NSString *)propertyId
              andPhoneID:(NSString *)phoneID
                andEmpID:(NSString *)empID
               andDeptID:(NSString *)deptID
             andDelegate:(id<DascomCallProtocol>)delegate;

/**
 * 获取虚拟号配置信息
 */
+ (void)requestConfig;

/**
 *  是否使用虚拟号
 */
+ (BOOL)isVirtualCall;

/**
 *  获取总共可拨打次数
 */
+ (NSInteger)getCallLimit;

/**
 *  修改报备手机号
 */
- (void)requestChangePhoneNumber:(NSString *)phoneNumber;

@end
