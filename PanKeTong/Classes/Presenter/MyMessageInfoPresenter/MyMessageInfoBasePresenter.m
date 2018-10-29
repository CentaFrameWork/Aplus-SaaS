//
//  MyMessageInfoBasePresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/5/11.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MyMessageInfoBasePresenter.h"

@implementation MyMessageInfoBasePresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _selfView = delegate;
    }
    return self;
}


/// 获得 请求api
- (APlusBaseApi *)getRequestApiMessageType:(NSString *)messageType
                          andContactsKeyId:(NSString *)contactsKeyId
                                andContent:(NSString *)content
                   andFollowConfirmPerCode:(NSString *)followConfirmPerCode
{
    MessageApi *messageApi = [[MessageApi alloc] init];
    messageApi.messageType = SendMessageBJOrSZ;
    messageApi.contactsKeyId = contactsKeyId;
    messageApi.content = content;
    messageApi.followConfirmPerCode = followConfirmPerCode;
    
    return messageApi;
}

@end
