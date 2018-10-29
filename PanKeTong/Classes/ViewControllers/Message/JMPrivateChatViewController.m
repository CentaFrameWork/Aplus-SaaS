//
//  JMPrivateChatViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMPrivateChatViewController.h"

#import "JMPrivateChatViewCell.h"

#import "MyMessageInfoDetailResultEntity.h"
#import "MyMessageInfoBasePresenter.h"
#import "MyMessageInfoDetailEntity.h"
#import "SendMessageEntity.h"
#import "MessageApi.h"
#import "JMMessage.h"

#import "UIViewController+Category.h"
#import "UITableView+Category.h"
#import "UIView+Extension.h"

@interface JMPrivateChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet UIView *inputConView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputConViewBottomCon;


@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) MyMessageInfoBasePresenter *myMessageInfoPresenter;

@property (nonatomic, assign) NSInteger startCount;

@property (nonatomic, assign) BOOL isSend;

@end

@implementation JMPrivateChatViewController

- (instancetype)init{
    
    return [JMPrivateChatViewController viewControllerFromStoryboard];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册接收未读消息私信提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshMethod) name:UnreadNotification object:nil];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    self.startCount = 10;
    
    self.isSend = NO;
    
    self.myMessageInfoPresenter = [[MyMessageInfoBasePresenter alloc] initWithDelegate:self];
    
    [self.sendBtn setLayerCornerRadius:YCLayerCornerRadius];
    
    self.inputTextField.delegate = self;
    
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = YCThemeColorBackground;
    
    self.chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)loadNavigationBar{
    
    [self setNavTitle:self.titleName leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

#pragma mark - private
- (void)back{
    
    [self.inputTextField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//发送信息的请求
- (void)sendMessage{
    
    if (self.inputTextField.text.length == 0) {
        
        return;
        
    }
    
    [self showLoadingView:nil];
    
    NSString *confirmPermissionCode = [self getConfirmPermissionCode];
    
    APlusBaseApi * api = [self.myMessageInfoPresenter getRequestApiMessageType:SendMessageBJOrSZ andContactsKeyId:self.messagerKeyId andContent:self.inputTextField.text andFollowConfirmPerCode:confirmPermissionCode];
    
    [_manager sendRequest:api];
    
    self.inputTextField.text = @"";
}
- (NSString *)getConfirmPermissionCode{
    
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_MYDEPARTMENT]) {
        
        return PROPERTY_FOLLOW_CONFIRM_MYDEPARTMENT;
        
    }else if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_ALL]){
        
        return PROPERTY_FOLLOW_CONFIRM_ALL;
        
    }else if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_MYSELF]){
        
        return PROPERTY_FOLLOW_CONFIRM_MYSELF;
        
    }else if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_NONE]){
        
        return PROPERTY_FOLLOW_CONFIRM_NONE;
        
    }else{
        //若是没有以上四个权限
        return PROPERTY_FOLLOW_CONFIRM_NONE;
    }
}


#pragma mark - btnClick
- (IBAction)sendButtonClick:(UIButton *)sender {
    
    [self sendMessage];
    
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"JMPrivateChatViewCell";
    
    JMPrivateChatViewCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.message = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMMessage * message = self.dataArray[indexPath.row];
    
    if (indexPath.row == self.dataArray.count - 1) {
        
        return message.rowHeight + 12;
        
    }
    
    return message.rowHeight;
    
}

//滑动屏幕
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 退出键盘
    [self.view endEditing:YES];
}

#pragma mark - MJRefreshDelegate
- (void)createRefreshViewMethod{
    
    self.chatTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
}

- (void)headerRefreshMethod{
    
    self.startCount += 10;
    
    [self getMessageDetailWith:self.startCount];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendMessage];
    
    return YES;
}
- (void)keyboardWillChangeFrame:(NSNotification *)note{

    // 键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - APP_SCREEN_HEIGHT;

    // 执行动画

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration+0.1];
    
    if (transformY == 0) {
        
//        self.view.y = APP_NAV_HEIGHT;
        
        self.inputConViewBottomCon.constant = 0;
        
    }else{
        
//        self.view.y = transformY + APP_NAV_HEIGHT + BOTTOM_SAFE_HEIGHT;
        
        self.inputConViewBottomCon.constant = -transformY - BOTTOM_SAFE_HEIGHT;
        
    }
    
    if (self.dataArray.count > 0){
        
        __block typeof(self) weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        });
        
    }

    [UIView commitAnimations];
    //滑动到最底下的一条消息不做动画

}


#pragma mark - Request
//获取详情消息
- (void)getMessageDetailWith:(NSInteger)count{
    
    [self showLoadingView:nil];
    
    MessageApi *messageApi = [[MessageApi alloc] init];
    messageApi.messageType = PrivateMessageDetail;
    messageApi.messageKeyId = self.keyId;
    messageApi.pageSize = [NSString stringWithFormat:@"%@",@(count)];
    [_manager sendRequest:messageApi];
}
#pragma mark- <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    [self endRefreshWithTableView:self.chatTableView];
    
    NSInteger alreadyHave = self.dataArray.count;
    
    if ([modelClass isEqual:[MyMessageInfoDetailEntity class]]) {
        
        MyMessageInfoDetailEntity * entity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (entity.result.count != 0){
            
            [self hiddenLoadingView];
            
            [self.dataArray removeAllObjects];
            
            NSArray * tmpArr = [[entity.result reverseObjectEnumerator] allObjects];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            
            for (MyMessageInfoDetailResultEntity * entity in tmpArr) {
                
                JMMessageText * message = [[JMMessageText alloc] init];
                
                message.accountId = entity.senderNo;
                
                message.accountNickName = entity.senderName;
                
                message.accountImageUrl = entity.senderPhotoPath;
                
                message.time = entity.msgTime;
                
                message.isMe = [entity.senderNo isEqualToString:[CommonMethod getUserdefaultWithKey:UserStaffNumber]];
                
                message.text = entity.msgContent;
                
                //处理日期问题
                JMMessageText * preMsg = [self.dataArray lastObject];
                
                if (preMsg != nil) {
                    
                    NSDate * preDate = [dateFormatter dateFromString:preMsg.time];
                    
                    NSDate * currDate = [dateFormatter dateFromString:message.time];
                    
                    NSTimeInterval timeInterval = [currDate timeIntervalSinceDate:preDate];
                    
                    message.isHiddenTime = timeInterval <= 60 * 5;
                    
                }
                
                [self.dataArray addObject:message];
                
                
                
            }
            
            if (self.dataArray.count == entity.recordCount){
                
                self.chatTableView.mj_header.hidden = YES;
                
            } else {
                
                self.chatTableView.mj_header.hidden = NO;
            }
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:self.chatTableView andShow:NO];
            
        } else {
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:self.chatTableView andShow:YES];
            
        }
        
    } else if ([modelClass isEqual:[SendMessageEntity class]]) {
        
        SendMessageEntity * sendEntity=[DataConvert convertDic:data toEntity:modelClass];
        
        if (sendEntity.flag) {
            
            [self getMessageDetailWith:_startCount];
        }
        
    }
    
    [self.chatTableView reloadData];
    
    __block typeof(self) weakSelf = self;
    
    if (weakSelf.chatTableView.mj_header.isRefreshing){
        
        if (weakSelf.dataArray.count > 0){
            
            //下拉的时候加载更多并滑动到当前出现的位置
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count - alreadyHave inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    } else {
        if (self.isSend) {
            //发送一条消息时 滑动到最底下的一条消息不做动画
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } else {
            //第一次进入 滑动到最底下的一条消息不做动画
            if (weakSelf.dataArray.count != 0){
                
                [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
            }
            self.isSend = YES;
        }
        
    }
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    
    [self endRefreshWithTableView:self.chatTableView];
    
    [self hiddenLoadingView];
    
    if (self.dataArray.count==0){
        
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:self.chatTableView andShow:YES];
        
    } else {
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:self.chatTableView andShow:NO];
    }
    
}

#pragma mark - getter
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    
    return _dataArray;
    
}

#pragma mark - 系统协议
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self getMessageDetailWith:self.startCount];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.myDelegate reloadData];
    
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UnreadNotification object:nil];
    
}

@end
