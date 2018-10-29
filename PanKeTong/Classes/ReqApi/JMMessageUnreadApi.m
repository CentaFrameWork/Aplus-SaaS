//
//  JMMessageUnreadApi.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMessageUnreadApi.h"

#import "JMMessageUnreadModel.h"

@implementation JMMessageUnreadApi

- (NSString *)getPath{
    
    return @"/center/unread-messages-count";
    
}

- (NSDictionary *)getBody{
    
    return @{};
    
}

- (int)getRequestMethod{
    
    return RequestMethodGET;
    
}

- (Class)getRespClass{
    
    return [JMMessageUnreadModel class];
    
}

@end
