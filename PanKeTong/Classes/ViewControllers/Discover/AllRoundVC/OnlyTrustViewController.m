//
//  OnlyTrustViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "OnlyTrustViewController.h"
#import "CityCodeVersion.h"

@interface OnlyTrustViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *_tableViewDataSource;
    
//    OnlyTrustService *_onlyTrustService;
    OnlyTrustApi *_onlyTrustApi;

}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation OnlyTrustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavTitle];
    [self initData];
    
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];

    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
  


}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    _onlyTrustService.delegate = nil;
//}

- (void)headerRefreshMethod
{
    [_tableViewDataSource removeAllObjects];
    [self requestData];
}

-(void)initData
{
    _tableViewDataSource = [[NSMutableArray alloc]init];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self showLoadingView:nil];
    
    [self requestData];
}

- (void)requestData
{
    _onlyTrustApi = [[OnlyTrustApi alloc] init];
    _onlyTrustApi.keyId = self.keyId;
    [_manager sendRequest:_onlyTrustApi];
}

- (void)initNavTitle
{
    [self setNavTitle:_titleName
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"onlyTrust";
    
    OnlyTrustTableViewCell *onlyTrustTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!onlyTrustTableViewCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"OnlyTrustTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        onlyTrustTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if(_tableViewDataSource.count > 0)
    {
        NSInteger rowIndex = indexPath.row;
        PropOnlyTrustEntity *propOnlyTrust = (PropOnlyTrustEntity *)_tableViewDataSource[rowIndex];
        onlyTrustTableViewCell.propOnlyTrustEntity = propOnlyTrust;
    }
    
    return onlyTrustTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    [self back];
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self hiddenLoadingView];

    if([modelClass isEqual:[PropOnlyTrustListEntity class]]){
        PropOnlyTrustListEntity *propOnlyTrustListEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_tableViewDataSource addObjectsFromArray:propOnlyTrustListEntity.propOnlyTrusts];
    }

    if(_tableViewDataSource.count <= 0){

        UIAlertView *noResultAlert = [[UIAlertView alloc]initWithTitle:@"暂无数据!"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"确定", nil];
        [noResultAlert show];
    }

    [self endRefreshWithTableView:_mainTableView];
    [_mainTableView reloadData];


}
//- (void)didReceiveResponse:(id)data
//{
//    [self hiddenLoadingView];
//    
//    if([data isKindOfClass:[PropOnlyTrustListEntity class]]){
//        PropOnlyTrustListEntity *propOnlyTrustListEntity = (PropOnlyTrustListEntity *)data;
//        [_tableViewDataSource addObjectsFromArray:propOnlyTrustListEntity.propOnlyTrusts];
//    }
//    
//    if(_tableViewDataSource.count <= 0){
//        
//        UIAlertView *noResultAlert = [[UIAlertView alloc]initWithTitle:@"暂无数据!"
//                                                               message:nil
//                                                              delegate:self
//                                                     cancelButtonTitle:nil
//                                                     otherButtonTitles:@"确定", nil];
//        [noResultAlert show];
//    }
//    
//    [self endRefreshWithTableView:_mainTableView];
//    [_mainTableView reloadData];
//}

//- (void)didFailedReceiveResponseWithError:(Error *)error
//{
//    [self hiddenLoadingView];
//    [self handleError:error];
//}


@end
