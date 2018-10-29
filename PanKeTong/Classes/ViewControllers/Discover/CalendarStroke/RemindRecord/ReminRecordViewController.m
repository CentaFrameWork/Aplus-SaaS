//
//  ReminRecordViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "ReminRecordViewController.h"
#import "ReminRecordCell.h"
#import "NewReminRecordViewController.h"
#import "ReminScreeningViewController.h"
#import "AlertApi.h"
#import "NSDate+Format.h"
#import "AlertEventEntity.h"
#import "SubAlertEventEntity.h"

@interface ReminRecordViewController ()<UITableViewDelegate,UITableViewDataSource,AddAlertDelegate>
{
    __weak IBOutlet UIView *_firstUseView;  //初次使用的view
    
    __weak IBOutlet UITableView *_mainTableView;
    
    AlertApi *_alertApi;   //请求实体
    AlertEventEntity *_alertEventEntity; //请求回来实体
    NSMutableArray * _dataSource;   //数据实体
    
    AlertApi * _alertScreeningApi;     //筛选实体
}

@end

@implementation ReminRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}

-(void)initView
{
    _firstUseView.hidden = YES;
    [self setNavTitle:@"提醒记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    _mainTableView.tableFooterView = [[UIView alloc]init];
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
//    [_mainTableView addFooterWithTarget:self
//                                 action:@selector(footerRefreshMethod)];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
    
    UIButton *addNewBtn = [self customBarItemButton:@"   新增"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(addMoreMethod:)];
    
    UIButton *screenningButton = [self customBarItemButton:@"筛选   "
                                           backgroundImage:nil
                                                foreground:nil
                                                       sel:@selector(filtFollowMethod:)];
    
    
    UIBarButtonItem *addNewBarItem = [[UIBarButtonItem alloc]initWithCustomView:addNewBtn];
    UIBarButtonItem *filtPropBarItem = [[UIBarButtonItem alloc]initWithCustomView:screenningButton];
    
    self.navigationItem.rightBarButtonItems = @[addNewBarItem,
                                                filtPropBarItem];
}

-(void)initData
{
    _dataSource = [[NSMutableArray alloc] init];
    _alertApi = [[AlertApi alloc] init];
    [self headerRefreshMethod];
}

- (void)headerRefreshMethod
{
    [_dataSource removeAllObjects];
    [_mainTableView reloadData];
    _alertScreeningApi = nil;
    [self requestData];
    [self showLoadingView:nil];
}

- (void)footerRefreshMethod
{
    [self requestData];
}

-(void)requestData
{
    _alertApi.timeFrom = _alertScreeningApi.timeFrom?_alertScreeningApi.timeFrom:[NSDate stringWithSimpleDate:[NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:[NSDate date]]];
    _alertApi.timeTo = _alertScreeningApi.timeTo?_alertScreeningApi.timeTo:[CommonMethod formatDateStrFromDate:[NSDate date]];
    _alertApi.employeeKeyId = _alertScreeningApi.employeeKeyId?_alertScreeningApi.employeeKeyId:@"";
    _alertApi.deptKeyId = @"";
    _alertApi.remark = _alertScreeningApi.remark?_alertScreeningApi.remark:@"";
    _alertApi.pageIndex = [NSString stringWithFormat:@"%@",@(_dataSource.count/10+1)];
    _alertApi.pageSize = @"10";
    _alertApi.sortField = @"";
    _alertApi.ascending = @"true";
    [_manager sendRequest:_alertApi];
}

- (IBAction)addReminRecordClick:(id)sender {
    NewReminRecordViewController *newReminRecordVC = [[NewReminRecordViewController alloc]
                                                      initWithNibName:@"NewReminRecordViewController"
                                                      bundle:nil];
    newReminRecordVC.delegate = self;
    [self.navigationController pushViewController:newReminRecordVC animated:YES];
}


#pragma mark 导航栏新增方法
-(void)addMoreMethod:(UIButton *)addBtn
{
    NewReminRecordViewController *newReminRecordVC = [[NewReminRecordViewController alloc]
                                                         initWithNibName:@"NewReminRecordViewController"
                                                         bundle:nil];
    newReminRecordVC.delegate = self;
    [self.navigationController pushViewController:newReminRecordVC animated:YES];
    
}

#pragma mark - 新增提醒成功，刷新列表
-(void)addAlertSuccess
{
    [self headerRefreshMethod];
}

#pragma mark 导航栏筛选方法
-(void)filtFollowMethod:(UIButton *)btn
{
    
    WS(weakSelf);
//    TakeLookScreeningViewController * takeLookScreeningVC = [[TakeLookScreeningViewController alloc] init];
//    takeLookScreeningVC.takeSeeScreeningEntity = _takeSeeScreening;
//    takeLookScreeningVC.block = ^(TakeSeeApi * takeSee)
//    {
//        //筛选点击确定进行筛选
//        _takeSeeScreening = takeSee;
//        [_dataSource removeAllObjects];
//        [weakSelf showLoadingView:nil];
//        [_mainTableView reloadData];
//        [weakSelf requestData];
//    };
    
//    [self.navigationController pushViewController:takeLookScreeningVC animated:YES];
    
    ReminScreeningViewController * alertScreeningVC = [[ReminScreeningViewController alloc] init];
    alertScreeningVC.alertScreeningEntity = _alertScreeningApi;
    alertScreeningVC.block = ^(AlertApi *alertApi)
    {
      //筛选点击确定进行筛选
        _alertScreeningApi = alertApi;
        [_dataSource removeAllObjects];
        [weakSelf showLoadingView:nil];
        [_mainTableView reloadData];
        [weakSelf requestData];
    };
    [self.navigationController pushViewController:alertScreeningVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubAlertEventEntity *subAlertEntity = [_dataSource objectAtIndex:indexPath.row];
    
    NSString * alertListDetail = [NSString stringWithFormat:@"提醒人：%@  \n提醒时间：%@ \n提醒内容：%@",
                                  subAlertEntity.employeeName,
                                  [CommonMethod getFormatDateStrFromTime:subAlertEntity.alertEventTimes DateFormat:YearToMinFormat],
                                  subAlertEntity.remark];
    
    return [alertListDetail getStringHeight:[UIFont fontWithName:FontName size:13.0] width:APP_SCREEN_WIDTH - 34 size:13.0] + 40.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReminRecordCell *cell = [ReminRecordCell cellWithTableView:tableView];
    [cell setReminRecordDetailWithListEntity:_dataSource
                                andIndexPath:indexPath];
    
    return cell;
}

#pragma mark - ResponseDelegate
- (void)dealData:(id)data andClass:(id)modelClass
{
    [self endRefreshWithTableView:_mainTableView];
    if ([modelClass isEqual:[AlertEventEntity class]]) {
        _alertEventEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_dataSource addObjectsFromArray:_alertEventEntity.alertEvents];
        _firstUseView.hidden = YES;
        
        if ([_alertEventEntity.alertEvents count] > 0) {
            //有提醒记录
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
            
        }else{
            if (_alertScreeningApi) {
                
                [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                    andOnView:_mainTableView
                                      andShow:NO];
            }else{
                _firstUseView.hidden = NO;
            }
            
        }
        
        if(_alertEventEntity.alertEvents.count < 10){
//            _mainTableView.footerHidden = YES;
            _mainTableView.mj_footer.hidden = YES;
        }else{
//            _mainTableView.footerHidden = NO;
            _mainTableView.mj_footer.hidden = NO;
        }
        
        
    }
    [_mainTableView reloadData];
    
}


-(void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];
}

@end
