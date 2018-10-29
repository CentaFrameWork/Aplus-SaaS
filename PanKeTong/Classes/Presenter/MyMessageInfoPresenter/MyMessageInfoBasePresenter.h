//
//  MyMessageInfoBasePresenter.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BasePresenter.h"
#import "APlusBaseApi.h"
#import "MessageApi.h"

@interface MyMessageInfoBasePresenter : BasePresenter

@property (assign, nonatomic) id selfView;

- (instancetype)initWithDelegate:(id)delegate;

/// 获得 请求api
- (APlusBaseApi *)getRequestApiMessageType:(NSString *)messageType
                          andContactsKeyId:(NSString *)contactsKeyId
                                andContent:(NSString *)content
                   andFollowConfirmPerCode:(NSString *)followConfirmPerCode;

@end
