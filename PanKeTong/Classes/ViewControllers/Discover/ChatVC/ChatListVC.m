//
//  ChatListViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ChatListVC.h"
#import "ChatListCell.h"
#import "ChatDetailViewController.h"

#import <RongIMKit/RongIMKit.h>


@interface ChatListVC ()<UITableViewDataSource,UITableViewDelegate,
RCIMReceiveMessageDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    
    NSMutableArray *_chatListArray;
    
    RCIMClient *_userChatMessage;//用户消息体
    RCIM *_rcimMessage;
    
    //用户头像、名字的缓存
    DataBaseOperation *_dataBaseOperation;
}

@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"聊天"
	   leftButtonItem:[self customBarItemButton:nil
								backgroundImage:nil
									 foreground:@"backBtnImg"
											sel:@selector(back)]
      rightButtonItem:nil];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //监听收到消息代理
    _rcimMessage = [RCIM sharedRCIM];
    [_rcimMessage setReceiveMessageDelegate:self];
    
    //刷新消息列表，保持列表中的消息为最新
    [self getRCChatList];
    
    [_mainTableView reloadData];
	
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"聊天列表"];
	
}

- (UIButton *)customBarItemButton:(NSString *)title backgroundImage:(NSString *)bgImg foreground:(NSString *)fgImg sel:(SEL)sel {
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [customBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [customBtn setBackgroundColor:[UIColor clearColor]];
    customBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (bgImg) {
        UIImage *image = [UIImage imageNamed:bgImg];
        [customBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (fgImg && MODEL_VERSION >= 7.0) {
        [customBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    [customBtn setImage:[UIImage imageNamed:fgImg] forState:UIControlStateNormal];
    
    if (title) {
        
        [customBtn setTitle:title forState:UIControlStateNormal];
    }
    
    [customBtn.titleLabel setFont:font];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (sel) {
        [customBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customBtn;
}

- (void)initData
{
    
    _chatListArray = [[NSMutableArray alloc]init];
    
}

- (void)getRCChatList
{
    
    //获取私聊列表
    [_chatListArray removeAllObjects];
    
    //用户消息体
    _userChatMessage = [RCIMClient sharedRCIMClient];
    _chatListArray = [[NSMutableArray alloc]initWithArray:
                      [_userChatMessage getConversationList:@[@(ConversationType_PRIVATE)]]];
    
    if (_chatListArray.count == 0) {
        
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:YES];
    }else{
        
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:NO];
    }
}

#pragma mark - 收到消息监听
/**
 接收消息到消息后执行。
 
 @param message 接收到的消息。
 @param left    剩余消息数.
 */

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(UITableView *) weakTableView = _mainTableView;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf getRCChatList];
        [weakTableView reloadData];
        
    });
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chatListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"ChatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:cellString
                                             owner:self
                                           options:nil] lastObject];
    }
    
    [cell.userHeadImgView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.userHeadImgView setClipsToBounds:YES];
    [cell.userHeadImgView setImage:[UIImage imageNamed:@"staffHead_icon"]];
    
    //消息体获取消息列表数据
    RCConversationModel *chatDataModel = [_chatListArray objectAtIndex:indexPath.row];
    /*
     *如果有用户缓存，读取缓存中的用户名
     *
     */
    NSMutableDictionary *dataUserDic = [_dataBaseOperation queryUserMessageWithUserId:chatDataModel.targetId];
    
    if (dataUserDic && dataUserDic.allKeys.count != 0) {
        
        cell.userNameLabel.text = [dataUserDic objectForKey:@"userName"];
        [CommonMethod setImageWithImageView:cell.userHeadImgView
                                andImageUrl:[dataUserDic objectForKey:@"userIcon"]
                    andPlaceholderImageName:@"staffHead_icon"];
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        
        [_userChatMessage getUserInfo:chatDataModel.targetId
                              success:^(RCUserInfo *userInfo) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      cell.userNameLabel.text = userInfo.name;
                                      [CommonMethod setImageWithImageView:cell.userHeadImgView
                                                              andImageUrl:userInfo.portraitUri
                                                  andPlaceholderImageName:@"staffHead_icon"];
                                      //缓存用户信息
                                      [weakSelf cacheUserMessageWithUserInfo:userInfo];
                                  });
                              }
                                error:^(RCErrorCode status) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        cell.userNameLabel.text = @"置业顾问";
                                        
                                        [cell.userHeadImgView setImage:[UIImage imageNamed:@"staffHead_icon"]];
                                    });
                                    
                                }];
    }
    
    //获取此用户的未读消息的数量
    
    int badgeNum = [_userChatMessage getUnreadCount:ConversationType_PRIVATE
                                           targetId:chatDataModel.targetId];
    NSString *badgeStr ;
    
    if (badgeNum > 99) {
        
        badgeStr = @"99+";
    }else{
        
        badgeStr = [NSString stringWithFormat:@"%d",badgeNum];
    }
    
    cell.badgeNumLabel.hidden = YES;
    
    if (badgeNum != 0) {
        
        cell.badgeNumLabel.hidden = NO;
        cell.badgeNumLabel.text = badgeStr;
        
        CGFloat badgeStrWidth = [badgeStr getStringWidth:[UIFont systemFontOfSize:14.0]
                                                  Height:18
                                                    size:14.0];
        cell.badgeLabelLeftFrame.constant = 53-badgeStrWidth;
        cell.badgeLabelWidth.constant = badgeStrWidth+10;
    }
    
    //计算最新消息时间
    cell.userChatTimeLabel.text = [self calculateMessageTimeWithSendInterval:chatDataModel.sentTime
                                                          andReceiveInterval:chatDataModel.receivedTime];
    
    /*
     *需要判断消息类型：RCTextMessage、RCImageMessage
     *
     */
    if ([chatDataModel.lastestMessage isMemberOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *chatMessage = (RCTextMessage *)chatDataModel.lastestMessage;
        cell.userChatContentLabel.text = chatMessage.content;
    }else if ([chatDataModel.lastestMessage isMemberOfClass:[RCImageMessage class]]){
        
        cell.userChatContentLabel.text = @"[图片]";
    }else{
        
        cell.userChatContentLabel.text = @"";
    }
    
    return cell;
    
}

/*
 *  第一次获取用户信息，缓存到本地
 */
- (void)cacheUserMessageWithUserInfo:(RCUserInfo *)userInfo
{
    
    [_dataBaseOperation insertUserTargetId:userInfo.userId
                             andTargetName:userInfo.name
                               andUserIcon:userInfo.portraitUri];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消息体获取消息列表数据
    RCConversationModel *chatModel = [_chatListArray objectAtIndex:indexPath.row];
    ChatDetailViewController *chatDetailVC = [[ChatDetailViewController alloc]init];
    
    // 如果有用户缓存，读取缓存中的用户名
    RCUserInfo *selectUserInfo = [[RCUserInfo alloc]init];
    NSMutableDictionary *dataUserDic = [_dataBaseOperation queryUserMessageWithUserId:chatModel.targetId];
    
    if (dataUserDic && dataUserDic.allKeys.count != 0)
    {
        selectUserInfo.name = [dataUserDic objectForKey:@"userName"];
        selectUserInfo.userId = [dataUserDic objectForKey:@"userId"];
        selectUserInfo.portraitUri = [dataUserDic objectForKey:@"userIcon"];
        
        chatDetailVC.conversationType = chatModel.conversationType;
        chatDetailVC.targetId = [dataUserDic objectForKey:@"userId"];
        chatDetailVC.userName = [dataUserDic objectForKey:@"userName"];
        chatDetailVC.selectUserInfo = selectUserInfo;
    }
    else
    {
        chatDetailVC.conversationType = chatModel.conversationType;
        chatDetailVC.targetId = chatModel.targetId;
        chatDetailVC.userName = @"置业顾问";
    }
    
    [self.navigationController pushViewController:chatDetailVC
                                         animated:YES];
}

//解决header和footer空白行的问题
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0) {
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RCConversationModel *deleteConversation = [_chatListArray objectAtIndex:indexPath.row];
    BOOL isDeleteSuccess = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                                                    targetId:deleteConversation.targetId];
    BOOL isClearMsgSuccess = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE
                                                                 targetId:deleteConversation.targetId];
    
    //删除聊天缓存
    [_dataBaseOperation deleteUserCacheMessageWithUserId:deleteConversation.targetId];
    
    //刷新消息列表，保持列表中的消息为最新
    [self getRCChatList];
    
    if (isDeleteSuccess || isClearMsgSuccess) {
        
        [_mainTableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }else{
        
        return;
    }
    
    
}

#pragma mark - 计算消息接受和发送的时间
- (NSString *)calculateMessageTimeWithSendInterval:(NSTimeInterval)sendInterval
                               andReceiveInterval:(NSTimeInterval)receiveInterval
{
    long currentMessageInterval;
    
    //通过发送时间和接收时间来比较哪个是最新的消息时间
    
    if (sendInterval > receiveInterval) {
        
        //发送的时间是最新的
        currentMessageInterval = sendInterval/1000;
    }else{
        
        //接受的时间是最新的
        currentMessageInterval = receiveInterval/1000;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //最新的消息时间
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:currentMessageInterval];
    
    //解决当前系统时间和北京时间相差8小时的问题
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    //接收或发送的消息时间(转换为当前时区)
    NSInteger messageInterval = [timeZone secondsFromGMTForDate: messageDate];
    NSDate *localMessageDate = [messageDate dateByAddingTimeInterval:messageInterval];
    
    //当前时间去掉时差问题
    NSDate *nowDate = [NSDate date];
    NSInteger nowInterval = [timeZone secondsFromGMTForDate:nowDate];
    NSDate *localNowDate = [nowDate dateByAddingTimeInterval:nowInterval];
    
    //明天零点时间
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrowDate = [localNowDate dateByAddingTimeInterval:secondsPerDay];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *zeroDateStr = [dateFormatter stringFromDate:tomorrowDate];
    [dateFormatter setDateFormat:CompleteFormat];
    NSDate *zeroDate = [dateFormatter dateFromString:zeroDateStr];
    
    
    //消息时间和明天零点时间比较,计算时间或天数
    NSTimeInterval interval = [zeroDate timeIntervalSinceDate:localMessageDate];
    double resultDay = interval / 60.0 / 60.0 / 24.0;
    
    NSString *resultMessageDateStr;
    
    /*
     *  时间计算规则：
     *           当日直接显示时间；
     *           前一天显示：昨天；
     *           从当日起往前的一周，显示星期几；
     *           超过当日起往前的一周，显示年月日；
     *
     *
     */
    if (resultDay > 0 && resultDay < 1) {
        
        //当日直接显示时间
        [dateFormatter setDateFormat:@"HH:mm"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
    }else if (resultDay >= 1 && resultDay < 2){
        
        //前一天显示：昨天
        resultMessageDateStr = @"昨天";
    }else if (resultDay >= 2 && resultDay < 7){
        
        //从当日起往前的一周，显示星期几
        [dateFormatter setDateFormat:DateAndTimeFormat];
        NSString *messageDateStr = [dateFormatter stringFromDate:localMessageDate];
        resultMessageDateStr = [messageDateStr weekDayFormDate];
    }else if (resultDay >= 7){
        
        //超过当日起往前的一周，显示年月日
        [dateFormatter setDateFormat:@"YY/MM/dd"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
    }else{
        
        //默认
        [dateFormatter setDateFormat:@"YY/MM/dd"];
        resultMessageDateStr = [dateFormatter stringFromDate:localMessageDate];
    }
    
    return resultMessageDateStr;
    
}


@end
