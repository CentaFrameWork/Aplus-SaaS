//
//  OfficialMessageListViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//


#import "OfficialMessageListViewController.h"
#import "MessageDetailViewController.h"
#import "CommonMethod.h"

#import "OfficalMessageTableViewCell.h"
//#import "MessageService.h"
#import "OfficialMessageEntity.h"
#import "OfficialMessageResultEntity.h"
#import "OfficialMessageApi.h"

@interface OfficialMessageListViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    
    __weak IBOutlet UITableView *_mainTableView;
    
    
//    MessageService * _messageService;

    NSMutableArray * _dataArray;
    
}
@end

@implementation OfficialMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self initNavTitleView];
    [self createRefreshViewMethod];
//    [_mainTableView headerBeginRefreshing];
    [_mainTableView.mj_header beginRefreshing];
    _mainTableView.tableFooterView=[[UIView alloc]init];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    _messageService.delegate=nil;

}
-(void)initData
{
    _dataArray=[NSMutableArray arrayWithCapacity:0];
}
-(void)initNavTitleView
{
    [self setNavTitle:@"官方消息"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - MJRefreshDelegate

-(void)createRefreshViewMethod
{
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
//    [_mainTableView addFooterWithTarget:self
//                                 action:@selector(footerRefreshMethod)];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
    
}
-(void)headerRefreshMethod
{
    [self getmessageWithStartIndex:0];
}
-(void)footerRefreshMethod
{
    [self getmessageWithStartIndex:[_dataArray count]];
}
-(void)getmessageWithStartIndex:(NSInteger)count
{
//    _messageService=[MessageService shareMessageService];
    if (count==0)
    {
        [_dataArray removeAllObjects];
    }
    OfficialMessageApi *officialMessageApi = [[OfficialMessageApi alloc] init];
    officialMessageApi.length = @"10";
    officialMessageApi.startIndex = [NSString stringWithFormat:@"%@",@(count)];
    [_manager sendRequest:officialMessageApi];

//    _messageService.delegate=self;
//    [_messageService getOfficialMessageWithStartIndex:[NSString stringWithFormat:@"%@",@(count)]];

}
#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count!=0)
    {
         OfficialMessageResultEntity * entity=_dataArray[indexPath.row];
        CGFloat hight=[entity.infoContent getStringHeight:[UIFont fontWithName:@"Helvetica"  size:14.0]
                                                    width:APP_SCREEN_WIDTH-35.0
                                                     size:14.0];
        
        if (hight<18.0)
        {
            hight=18.0;
        }
        if (hight>60.0)
        {
            hight=60.0;
        }
        return hight+52;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier=@"officalMesCell";
    OfficalMessageTableViewCell * messageCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!messageCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"OfficalMessageTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        
        messageCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    if (_dataArray.count!=0)
    {
        OfficialMessageResultEntity * entity=_dataArray[indexPath.row];
         messageCell.infomationLabel.text=entity.infoContent;
        messageCell.headerNameLabel.text=entity.title;
        double timeDouble = [CommonMethod getTimeNumberWith:entity.updateTime];
        NSString * dateString = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[entity.updateTime substringToIndex:4] integerValue]];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
        CGSize size = [dateString boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        messageCell.timeLabelWidthConstraint.constant=size.width+2;
        messageCell.timeLabel.text=dateString;
    }
   
    return messageCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    OfficialMessageResultEntity * entity=_dataArray[indexPath.row];
    
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc]initWithNibName:@"MessageDetailViewController"   bundle:nil];
    messageDetailVC.headerName=entity.title;
    double timeDouble = [CommonMethod getTimeNumberWith:entity.updateTime];
    messageDetailVC.timeString=[CommonMethod dateConcretelyTime:timeDouble andYearNum:[[entity.updateTime substringToIndex:4] integerValue]];

    messageDetailVC.infoId=[NSString stringWithFormat:@"%@",@(entity.infoId)];
    [self.navigationController pushViewController:messageDetailVC
                                         animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
-(void)dealloc
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self endRefreshWithTableView:_mainTableView];

    if ([modelClass isEqual:[OfficialMessageEntity class]])
    {
        OfficialMessageEntity * entity=[DataConvert convertDic:data toEntity:modelClass];
        if (entity.result.count!=0)
        {

            [self hiddenLoadingView];

            [_dataArray addObjectsFromArray:entity.result];


            if (_dataArray.count==entity.total)
            {
//                _mainTableView.footerHidden = YES;
                _mainTableView.mj_footer.hidden = YES;
            }
            else
            {
//                _mainTableView.footerHidden=NO;
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

}

//-(void)didReceiveResponse:(id)data
//{
//    [self endRefreshWithTableView:_mainTableView];
//
//    if ([data isKindOfClass:[OfficialMessageEntity class]])
//    {
//        OfficialMessageEntity * entity=(OfficialMessageEntity*)data;
//        if (entity.result.count!=0)
//        {
//
//            [self hiddenLoadingView];
//
//            [_dataArray addObjectsFromArray:entity.result];
//
//
//            if (_dataArray.count==entity.total)
//            {
//                _mainTableView.footerHidden = YES;
//            }
//            else
//            {
//                _mainTableView.footerHidden=NO;
//            }
//
//            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
//                                andOnView:_mainTableView
//                                  andShow:NO];
//        }
//        else
//        {
//
//            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
//                                andOnView:_mainTableView
//                                  andShow:YES];
//        }
//
//    }
//
//    [_mainTableView reloadData];
//
//}
//-(void)didFailedReceiveResponseWithError:(Error *)error
//{
//    [self endRefreshWithTableView:_mainTableView];
//    [self hiddenLoadingView];
//    if (_dataArray.count==0)
//    {
//        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
//                            andOnView:_mainTableView
//                              andShow:YES];
//    }
//    else
//    {
//        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
//                            andOnView:_mainTableView
//                              andShow:NO];
//    }
//    [self handleError:error];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
