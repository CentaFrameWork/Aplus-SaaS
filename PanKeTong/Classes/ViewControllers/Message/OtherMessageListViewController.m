//
//  OtherMessageListViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//
#import "UIScrollView+MJRefresh.h"
#import "OtherMessageListViewController.h"
#import "MessageDetailViewController.h"
#import "AllRoundDetailViewController.h"

#import "JMPrivateChatViewController.h"


#import "OtherMessageTableViewCell.h"
#import "MyMessageListTableViewCell.h"
#import "JMEstateMessageCell.h"

#import "MessageEntity.h"
#import "MessageResultEntity.h"
//#import "MessageService.h"
#import "MessageApi.h"
#import "MyPrivateLetterEntity.h"
#import "MyPrivateLetterResultEntity.h"

#import "UITableView+Category.h"



@interface OtherMessageListViewController ()<UITableViewDelegate, UITableViewDataSource, JMPrivateChatViewControllerRefreshDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    
//    MessageService * _messageService;
    NSInteger _startIndex;
    NSMutableArray * _dataArray;
    NSString * _informationCategory;        //消息枚举值
    

}
@end

@implementation OtherMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@",self.unReadMessageKeyIdArr);

    //注册接收未读消息私信提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshMethod) name:UnreadNotification object:nil];

    
    [self initData];
    [self initNavTitleView];
    [self loadMainView];
    [self createRefreshViewMethod];
    [self headerRefreshMethod];
}

- (void)loadMainView{
    
    _mainTableView.separatorColor = YCOtherColorDivider;
    
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UnreadNotification object:nil];
}

#pragma mark-<RefreshDelegate>
- (void)reloadData{
    //从下一界面返回时刷新数据
    [self headerRefreshMethod];


}

- (void)initData
{
    _dataArray=[NSMutableArray arrayWithCapacity:0];
}
- (void)initNavTitleView
{
    
    NSArray * array = @[@"房源消息",@"客源消息",@"成交消息",@"私信"];
    
    self.titleString = array[self.messageType - 2];
    
    [self setNavTitle:self.titleString
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}
- (void)back
{
   
    if ([self.title isEqualToString:@"我的私信"]) {
        //私信消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:PrivateMessageRemind];
    }else if ([self.title isEqualToString:@"房源消息"]){
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:PropMessageRemind];
    }else if ([self.title isEqualToString:@"客源消息"]){
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO]
                                       forKey:CustomerMessageRemind];

    }

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - MJRefreshDelegate

- (void)createRefreshViewMethod
{
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
}
- (void)headerRefreshMethod
{
    _startIndex=1;
    if (self.messageType==5)
    {
        
        [self myselfMessage:_startIndex];
    }
    else
    {
        [self getmessageWithStartIndex:_startIndex];
    }



}
- (void)footerRefreshMethod
{
    _startIndex++;
    if (self.messageType==5)
    {
        [self myselfMessage:_startIndex];
    }
    else
    {
        [self getmessageWithStartIndex:_startIndex];
    }

}
//我的私信列表
- (void)myselfMessage:(NSInteger)count
{
//    _messageService=[MessageService shareMessageService];
    if (count==1)
    {
        [_dataArray removeAllObjects];
    }
    MessageApi *messageApi = [[MessageApi alloc] init];
    messageApi.messageType = PrivateMessageList;
    messageApi.pageIndex = [NSString stringWithFormat:@"%@",@(count)];
    [_manager sendRequest:messageApi];
    [self showLoadingView:nil];

}
//除了我的私信以外的消息
- (void)getmessageWithStartIndex:(NSInteger)count
{
//    _messageService=[MessageService shareMessageService];
//    _messageService.delegate=self;
    if (count==1)
    {
        [_dataArray removeAllObjects];
    }
    switch (self.messageType)
    {
        case 2:
            //房源消息
            _informationCategory=@"PROPERTY";
            break;
        case 3:
            //客源消息
            _informationCategory=@"INQUIRY";
            break;
        case 4:
            //成交消息
            _informationCategory=@"CONCLUDE";
            break;
        default:
            break;
    }
    MessageApi *messageApi = [[MessageApi alloc] init];
    messageApi.messageType = OtherMessage;
    messageApi.informationCategory = _informationCategory;
    messageApi.pageIndex = [NSString stringWithFormat:@"%@",@(count)];
    [_manager sendRequest:messageApi];
    [self showLoadingView:nil];

}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.messageType == 2){
        
        static NSString * cellIdentifier = @"JMEstateMessageCell";
        
        JMEstateMessageCell * messageCell = [tableView tableViewCellByNibWithIdentifier:cellIdentifier];
        
        MessageResultEntity * entity=_dataArray[indexPath.row];
        messageCell.messageNameLabel.text=entity.informationType;
        messageCell.messageInfoLabel.text = entity.content;
        
        messageCell.timeLabel.text = [NSString formattingYMdHmHTimeStr:entity.createTime];
        
        messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return messageCell;
        
    } else if (self.messageType == 5){
        
        static NSString * myMessageIdentifier = @"MyMessageListTableViewCell";

        MyMessageListTableViewCell * myMessageCell = [tableView tableViewCellByNibWithIdentifier:myMessageIdentifier];
        
        MyPrivateLetterResultEntity *myEntity = _dataArray[indexPath.row];
        
        myMessageCell.nameLabel.text = myEntity.secondMessagerName;
        
        myMessageCell.timeLabel.text = [NSString formattingYMdHmHTimeStr:myEntity.lastMsgTime] ;
        
        myMessageCell.messageLabel.text = myEntity.lastMsgContent;
        myMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * notReadCount = [NSString stringWithFormat:@"%@", myEntity.notReadCount];
        
        notReadCount = ![notReadCount isEqualToString:@"0"] ? notReadCount : @"";
        
        myMessageCell.unReadCountLabel.text = notReadCount;
        
        CGFloat width = [notReadCount widthWithLabelFont:[UIFont systemFontOfSize:11 weight:UIFontWeightMedium]] + 8;
        
        width = width < 16 ? 16 : width;
        
        myMessageCell.unReadCountLabelWidthCon.constant = notReadCount.length == 0 ? 0 : width;
        
        return myMessageCell;
    } else {
        
        static NSString * otherCellIdentifier = @"OtherMessageTableViewCell";
        
        OtherMessageTableViewCell * othermessageCell = [tableView tableViewCellByNibWithIdentifier:otherCellIdentifier];
        
        MessageResultEntity * entity=_dataArray[indexPath.row];
        othermessageCell.messageInfoLable.text = entity.content;
        
        othermessageCell.timeLabel.text = [NSString formattingYMdHmHTimeStr:entity.createTime];
        othermessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return othermessageCell;
    }
    
    return [[UITableViewCell alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIFont * font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    if (self.messageType == 2){
        
        font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        
        MessageResultEntity * entity=_dataArray[indexPath.row];
        
        CGFloat height = [entity.content heightWithLabelFont:font withLabelWidth:APP_SCREEN_WIDTH - 24];
        
        height = height < 18 ? 18.0 : height;
        
        return height + 17 + 14 + 24 + 8;
        
    }else if(self.messageType == 5){
        
        return 60;
        
    }else{
        
        MessageResultEntity * entity = _dataArray[indexPath.row];
        
        CGFloat height = [entity.content heightWithLabelFont:font withLabelWidth:APP_SCREEN_WIDTH - 24];
        
        height = height < 18 ? 18.0 : height;
        
        return height + 60 - 17;
        
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.messageType==5)
    {
        MyPrivateLetterResultEntity * entity = _dataArray[indexPath.row];
//        MyMessageInfoViewController *myMessageInfoVC = [[MyMessageInfoViewController alloc]initWithNibName:@"MyMessageInfoViewController"      bundle:nil];
        JMPrivateChatViewController * myMessageInfoVC = [[JMPrivateChatViewController alloc] init];
        myMessageInfoVC.myDelegate = self;
        myMessageInfoVC.titleName=entity.secondMessagerName;
        myMessageInfoVC.userImgUrl=entity.secondMessagerImageUrl;
        myMessageInfoVC.keyId=entity.keyId;
        myMessageInfoVC.messagerKeyId=entity.secondMessagerKeyId;
        [self.navigationController pushViewController:myMessageInfoVC
                                             animated:YES];
    }
   
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self endRefreshWithTableView:_mainTableView];
    if ([modelClass isEqual:[MessageEntity class]]) {
        
        MessageEntity * entity=[DataConvert convertDic:data toEntity:modelClass];
        
        if (entity.result.count!=0 )//&& entity.tag==Tag_OtherMessage
        {
            [self hiddenLoadingView];

            [_dataArray addObjectsFromArray:entity.result];


            if (_dataArray.count==entity.recordCount)
            {
                _mainTableView.mj_footer.hidden = YES;
            }
            else
            {
                _mainTableView.mj_footer.hidden = NO;
            }

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }
        else
        {

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
        }
    }

    if ([modelClass isEqual:[MyPrivateLetterEntity class]])
    {
        MyPrivateLetterEntity * entity=[DataConvert convertDic:data toEntity:modelClass];;
        if (entity.messages.count!=0)//&&entity.tag==Tag_MyMessage
        {
            [self hiddenLoadingView];

            [_dataArray addObjectsFromArray:entity.messages];


            if (_dataArray.count==entity.recordCount)
            {
                _mainTableView.mj_footer.hidden = YES;
            }
            else
            {
                _mainTableView.mj_footer.hidden = NO;
            }

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
            
        } else {

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
        }
        
    }
    
    [_mainTableView reloadData];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
    [self hiddenLoadingView];
    if (_dataArray.count==0)
    {

        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:YES];
    }
    else
    {
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:NO];
    }
    [_mainTableView reloadData];

}


@end
