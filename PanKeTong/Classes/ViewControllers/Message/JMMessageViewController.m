//
//  JMMessageViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/24.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMessageViewController.h"
#import "OfficialMessageListViewController.h"
#import "OtherMessageListViewController.h"
#import "MessageDetailViewController.h"

#import "JMMessageOfficialHeaderView.h"

#import "JMMessageViewCell.h"

#import "OfficialMessageEntity.h"
#import "OfficialMessageResultEntity.h"
#import "MessageEntity.h"
#import "MessageResultEntity.h"
#import "MyPrivateLetterEntity.h"
#import "MyPrivateLetterResultEntity.h"
#import "JMMessageUnreadModel.h"

#import "MessageApi.h"
#import "OfficialMessageApi.h"
#import "JMMessageUnreadApi.h"

#import "UIViewController+Category.h"
#import "CAShapeLayer+Category.h"
#import "UITableView+Category.h"
#import "UITabBar+badge.h"

#import <MJExtension/MJExtension.h>

@interface JMMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *houseCountImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *customCountImageView;
@property (weak, nonatomic) IBOutlet UILabel *customCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dealCountImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myMsgCountImageView;
@property (weak, nonatomic) IBOutlet UILabel *myMsgCountLabel;



@property (weak, nonatomic) IBOutlet UITableView *tableView;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customConViewLeftHouseConViewCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealConViewRightMyMsgConViewCon;


@property (nonatomic, strong) OfficialMessageEntity * officalMessageEntity;//官方
@property (nonatomic, strong) JMMessageUnreadModel * myEntity;//我的私信未读数量

@end

@implementation JMMessageViewController

- (instancetype)init{
    
    return [JMMessageViewController viewControllerFromStoryboard];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听是否有未读
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:UnreadNotification object:nil];
    
    [self loadMainView];
    [self loadNavigationBar];
    [self reloadViewStatus];
    
}

- (void)loadMainView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = YCOtherColorDivider;
    self.view.backgroundColor = RGBColor(244, 244, 244);
    
    CGFloat space = (APP_SCREEN_WIDTH - 4 * 64 - 2 * 24) / 3;
    
    self.customConViewLeftHouseConViewCon.constant = space;
    
    self.dealConViewRightMyMsgConViewCon.constant = space;
    
    //给功能按钮添加点击事件
    for (int i = 1001; i < 1005; i++) {
        
        UIView * view = [self.view viewWithTag:i];
        
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funcViewClickWithTgr:)];
        
        [view addGestureRecognizer:tgr];
    }
    
}

- (void)loadNavigationBar{
    
    if (self.showNavigationLeftItem) {
        
        [self setNavTitle:@"消息" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)]
          rightButtonItem:nil];
        
    }else{
        
        [self setNavTitle:@"消息" leftButtonItem:nil rightButtonItem:nil];
        
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.officalMessageEntity.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"JMMessageViewCell";
    
    JMMessageViewCell * messageCell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    messageCell.entity = self.officalMessageEntity.result[indexPath.row];
    
    return messageCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OfficialMessageResultEntity * entity = self.officalMessageEntity.result[indexPath.row];
    
    entity.isRead = YES;
    
    [SQLiteManager insertOrReplaceToTableName:DATABASE_ALREAY_OFFICIAL_MESSAGE_TABLE_NAME andObject:entity];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc]initWithNibName:@"MessageDetailViewController" bundle:nil];
    messageDetailVC.headerName = entity.title;
    
    messageDetailVC.timeString = [NSString formattingYMdHmsHTimeStr:entity.createTime];
    
    messageDetailVC.infoId = [NSString stringWithFormat:@"%@",@(entity.infoId)];
    
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 48;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JMMessageOfficialHeaderView * headerView = [JMMessageOfficialHeaderView viewFromXib];
    
    headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 48);
    
    return headerView;
    
}

#pragma mark - 数据请求
- (void)requestData{
    
    [self getOfficeMessage];
    
    [self getOtherMessage];
    
}

//获取官方消息
- (void)getOfficeMessage{
    OfficialMessageApi *officialMessageApi = [[OfficialMessageApi alloc] init];
    officialMessageApi.length = @"999";
    [_manager sendRequest:officialMessageApi];
    
}
//获取其他消息
- (void)getOtherMessage{
    
    //获取私信未读数量
    JMMessageUnreadApi * unreadApi = [[JMMessageUnreadApi alloc] init];
    
    [_manager sendRequest:unreadApi];

}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    if ([modelClass isEqual:[OfficialMessageEntity class]]){
        
        [self hiddenLoadingView];
        
        self.officalMessageEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        //处理数据，判断是否已经阅读
        for (OfficialMessageResultEntity * entity in self.officalMessageEntity.result) {
            
            NSDictionary * params = @{
                                      @"infoId" : @(entity.infoId),
                                      };
            
            OfficialMessageResultEntity * tmpEntity = [[SQLiteManager queryByParamsWithTableName:DATABASE_ALREAY_OFFICIAL_MESSAGE_TABLE_NAME andClass:[OfficialMessageResultEntity class] andParams:params] firstObject];
            
            entity.isRead = tmpEntity != nil;
            
        }
        
    }
    
    if ([modelClass isEqual:[JMMessageUnreadModel class]]){
        
        JMMessageUnreadModel * entity = [DataConvert convertDic:data toEntity:modelClass];
        
        self.myEntity = entity;
        
    }
    
    [self reloadViewStatus];
    
}

#pragma mark - private
- (void)reloadViewStatus{//刷新状态
    
    self.myMsgCountLabel.text = self.myEntity.count == 0 ? @"" : [NSString stringWithFormat:@"%ld", self.myEntity.count];
    
    self.myMsgCountImageView.hidden = self.myMsgCountLabel.text.length == 0;

    BOOL privateMsg = [[NSUserDefaults standardUserDefaults] boolForKey:PrivateMessageRemind];
    
    if (privateMsg) {
        
        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
        
    }else{
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
        
    }
    
    [self.tableView reloadData];
    
}

- (void)funcViewClickWithTgr:(UITapGestureRecognizer *)tgr{
    
    if (tgr.view.tag == 1001) {
        
        //房源消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:PropMessageRemind];
        
    }else if (tgr.view.tag == 1002){
        
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:CustomerMessageRemind];
    }else if (tgr.view.tag == 1003){
        //成交消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:DealMessageRemind];
        
    }else if (tgr.view.tag == 1004){
        //我的私信
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:PrivateMessageRemind];
        
    }
    
    OtherMessageListViewController *otherMegVC = [[OtherMessageListViewController alloc]initWithNibName:@"OtherMessageListViewController" bundle:nil];
    
    otherMegVC.messageType = tgr.view.tag - 999;
    
    [self.navigationController pushViewController:otherMegVC animated:YES];
    
}

#pragma mark - 系统协议
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationBarIsHasOffline:NO];
    
    [self requestData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setNavigationBarIsHasOffline:YES];
    
}

@end
