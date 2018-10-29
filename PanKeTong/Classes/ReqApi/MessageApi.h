//
//  MessageApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/4.
//  Copyright © 2016年 李慧娟. All rights reserved.
//

#import "APlusBaseApi.h"
#define OtherMessage  @"OtherMessage"//除了官方以外的消息
#define PropertyMessage @"PROPERTY"//房源消息
#define InquiryMessage @"INQUIRY"//客源消息
#define ConcludeMessage @"CONCLUDE"//成交消息
#define PrivateMessage @"PRIVATE"//我的私信
#define PrivateMessageList @"PRIVATELIST"//我的私信列表
#define PrivateMessageDetail @"PRIVATELISTDETAIL"//我的私信详情
#define SendMessageTJ @"SENDMESSGTJ"//天津发送私信
#define SendMessageBJOrSZ @"SENDMESSGAGEBJORSZ"//北京深圳发送私信

///获取官方之外的消息、房源消息、客源消息、成交消息
@interface MessageApi : APlusBaseApi

@property (nonatomic,copy)NSString *messageType;

/*
 除了官方以外的消息
 type?type:@"",@"InformationCategory",
 count?count:@"1",@"PageIndex",
 @"10",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */
@property (nonatomic,copy)NSString *informationCategory;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,copy)NSString *pageSize;



/*
 获得一条房源消息
 @"PROPERTY",@"InformationCategory",
 @"1",@"PageIndex",
 @"1",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",

 */


/*
 获得一条客源消息
 @"INQUIRY",@"InformationCategory",
 @"1",@"PageIndex",
 @"1",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */

/*
 获得一条成交消息
 @"CONCLUDE",@"InformationCategory",
 @"1",@"PageIndex",
 @"1",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */

/*
 获取一条我的私信
 @"",@"SecondMessagerName",
 @"1",@"PageIndex",
 @"1",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */


/*
 我的私信列表
 @"",@"SecondMessagerName",
 pageindex?pageindex:@"1",@"PageIndex",
 @"10",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */

/*
 我的私信详情
 keyId?keyId:@"",@"MessageKeyId",
 @"1",@"PageIndex",
 pageSize?pageSize:@"10",@"PageSize",
 @"",@"SortField",
 @"true",@"Ascending",
 */
@property (nonatomic,copy)NSString *messageKeyId;


/*
 发送私信(天津)
 contactsKeyId?contactsKeyId:@"",@"ContactsKeyId",
 content?content:@"",@"Content",
 */
@property (nonatomic,copy)NSString *contactsKeyId;
@property (nonatomic,copy)NSString *content;



/*
 发送私信（深圳、北京）
 contactsKeyId?contactsKeyId:@"",@"ContactsKeyId",
 content?content:@"",@"Content",
 followConfirmPerCode?followConfirmPerCode:@"",@"FollowConfirmPerCode",
 */
@property (nonatomic,copy)NSString *followConfirmPerCode;

@end
