//
//  MessageApi.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "MessageApi.h"
#import "MessageEntity.h"
#import "MyPrivateLetterEntity.h"
#import "MyMessageInfoDetailEntity.h"
#import "SendMessageEntity.h"


@implementation MessageApi
- (NSDictionary *)getBody
{
    if ([self.messageType isEqualToString:PropertyMessage] || [self.messageType isEqualToString:InquiryMessage] || [self.messageType isEqualToString:ConcludeMessage]) {
        //房源／客源／成交消息
        return @{
                 @"InformationCategory":self.messageType,
                 @"PageIndex":@"1",
                 @"PageSize":@"1",
                 @"SortField":@"",
                 @"Ascending":@"true"
                 };
    }else if ([self.messageType isEqualToString:PrivateMessage]){
        //我的私信
        return @{
                 @"SecondMessagerName":@"",
                 @"PageIndex":@"1",
                 @"PageSize":@"1",
                 @"SortField":@"",
                 @"Ascending":@"true"

                 };

    }else if ([self.messageType isEqualToString:PrivateMessageList]){
        //我的私信列表
        return @{
                 @"SecondMessagerName":@"",
                 @"PageIndex":_pageIndex?_pageIndex:@"1",
                 @"PageSize":@"10",
                 @"SortField":@"",
                 @"Ascending":@"true",
                 };

    }else if ([self.messageType isEqualToString:PrivateMessageDetail]){
        //我的私信详情
        return @{
                 @"MessageKeyId":_messageKeyId?_messageKeyId:@"",
                 @"PageIndex":@"1",
                 @"PageSize":_pageSize?_pageSize:@"10",
                 @"SortField":@"",
                 @"Ascending":@"true"
                 };


    }else if ([self.messageType isEqualToString:SendMessageTJ]){
        //天津发送私信
        return @{
                 @"ContactsKeyId":_contactsKeyId?_contactsKeyId:@"",
                 @"Content":_content?_content:@"",
                 };

    }else if ([self.messageType isEqualToString:SendMessageBJOrSZ]){
        //北京深圳发送私信
        return @{
                 @"ContactsKeyId":_contactsKeyId?_contactsKeyId:@"",
                 @"Content":_content?_content:@"",
                 @"FollowConfirmPerCode":_followConfirmPerCode?_followConfirmPerCode:@"",
                 };
        
    }

    //除了官方之外的消息
    return @{
             @"InformationCategory":_informationCategory?_informationCategory:@"",
             @"PageIndex":_pageIndex?_pageIndex:@"1",
             @"PageSize":@"10",
             @"SortField":@"",
             @"Ascending":@"true"
             };
}


- (NSString *)getPath
{
    if ([CommonMethod isRequestNewApiAddress]) {
        if ([self.messageType isEqualToString:PropertyMessage] || [self.messageType isEqualToString:InquiryMessage] || [self.messageType isEqualToString:ConcludeMessage]) {
            //房源／客源／成交消息
            return @"center/system-message";
        }else if ([self.messageType isEqualToString:PrivateMessage] || [self.messageType isEqualToString:PrivateMessageList]){
            //我的私信/私信列表
            return @"center/my-messages";

        }else if ([self.messageType isEqualToString:PrivateMessageDetail]){
            //我的私信详情
            return @"center/my-message";


        }else if ([self.messageType isEqualToString:SendMessageTJ] || [self.messageType isEqualToString:SendMessageBJOrSZ]){
            //发送私信
            return @"center/send-message";
        }
        
        //除了官方之外的消息
        return @"center/system-message";
    }


    if ([self.messageType isEqualToString:PropertyMessage] || [self.messageType isEqualToString:InquiryMessage] || [self.messageType isEqualToString:ConcludeMessage])
    {
        //房源／客源／成交消息
        return @"WebApiCenter/system-message";
    }
    else if ([self.messageType isEqualToString:PrivateMessage] || [self.messageType isEqualToString:PrivateMessageList])
    {
        //我的私信/私信列表
        return @"WebApiCenter/get_messages";
    }
    else if ([self.messageType isEqualToString:PrivateMessageDetail])
    {
        //我的私信详情
        return @"WebApiCenter/get_message_detail";
    }
    else if ([self.messageType isEqualToString:SendMessageTJ] || [self.messageType isEqualToString:SendMessageBJOrSZ])
    {
        //发送私信
        return @"WebApiCenter/message_sending";
    }

    //除了官方之外的消息
    return @"WebApiCenter/system-message";
}

- (Class)getRespClass
{
    if ([self.messageType isEqualToString:PropertyMessage]||[self.messageType isEqualToString:InquiryMessage]
        ||[self.messageType isEqualToString:ConcludeMessage]||[self.messageType isEqualToString:OtherMessage])
    {
        //房源／客源／成交消息/其他消息
        return [MessageEntity class];
    }
    else if ([self.messageType isEqualToString:PrivateMessage] || [self.messageType isEqualToString:PrivateMessageList]){
        //我的私信/私信列表
        return [MyPrivateLetterEntity class];

    }
    else if ([self.messageType isEqualToString:PrivateMessageDetail]){
        //我的私信详情
        return [MyMessageInfoDetailEntity class];
    }
    else if ([self.messageType isEqualToString:SendMessageTJ] || [self.messageType isEqualToString:SendMessageBJOrSZ]){
        //发送私信
        return [SendMessageEntity class];
    }

    return nil;

}

- (int)getRequestMethod {
    
    if ([self.messageType isEqualToString:SendMessageTJ] || [self.messageType isEqualToString:SendMessageBJOrSZ]) {
        return RequestMethodPOST;
    }
    
//    if ([self.messageType isEqualToString:PropertyMessage] || [self.messageType isEqualToString:InquiryMessage] || [self.messageType isEqualToString:ConcludeMessage]) {
//        //房源／客源／成交消息
        return RequestMethodGET;
//    }else{
//
//        return RequestMethodPOST;
//    }
}

@end
