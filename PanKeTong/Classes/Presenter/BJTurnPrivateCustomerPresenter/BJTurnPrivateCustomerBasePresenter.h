//
//  BJTurnPrivateCustomerBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"

@interface BJTurnPrivateCustomerBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 检查座机
- (NSString *)checkTelephoneAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString;

/// 获得座机电话
- (NSString *)getTelephoneNumWithAreaCode:(NSString *)areaCodeString andTel:(NSString *)telString andExtension:(NSString *)extensionString andPhoneNum:(NSString *)phoneNum;

/// 最大座机电话位数
- (NSInteger)getTelMaxCount;

/// 最小座机电话位数
- (NSInteger)getTelMinCount;
@end
