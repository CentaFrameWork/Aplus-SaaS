//
//  PropKeyListViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/2.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropKeyListViewController.h"
#import "PropKeysApi.h"
#import "PropKeysEntity.h"
#import "PropKeyListEntity.h"

#import "PropKeyListBasePresenter.h"


@interface PropKeyListViewController ()<PropKeyListViewProtocol>
{
    PropKeysApi *_proKeysApi;
    
    NSMutableArray *_tableDataSource;
    
    NSString * _phoneNum;
    PropKeyListBasePresenter *_propKeyListPresenter;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableVIew;

@end

@implementation PropKeyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPresenter];
    [self initNavTitle];
    [self initData];
    
//    [_mainTableVIew addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];

    _mainTableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)headerRefreshMethod
{
    [_tableDataSource removeAllObjects];
    [self requestData];
}

- (void)initPresenter
{
   
        _propKeyListPresenter = [[PropKeyListBasePresenter alloc] initWithDelegate:self];
    
}

- (void)initData
{
    _proKeysApi = [PropKeysApi new];
    
    _tableDataSource = [[NSMutableArray alloc]init];
    self.mainTableVIew.dataSource = self;
    self.mainTableVIew.delegate = self;
    
    [self showLoadingView:nil];
    
    [self requestData];
}

- (void)requestData
{
    _proKeysApi.keyId = self.keyId;
    [_manager sendRequest:_proKeysApi];
}

- (void)initNavTitle
{
     [self setNavTitle:@"钥匙"
        leftButtonItem:[self customBarItemButton:nil
                                 backgroundImage:nil
                                      foreground:@"backBtnImg"
                                             sel:@selector(back)]
       rightButtonItem:nil];
}


#pragma mark - TableViewSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropKeysEntity *propKey = (PropKeysEntity *)_tableDataSource[indexPath.row];
    return [_propKeyListPresenter getheightForRowWithEntity:propKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"keysCell";
    
    KeysTableViewCell *keysTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!keysTableViewCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"KeysTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        keysTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if(_tableDataSource.count > 0)
    {
        NSInteger rowIndex = indexPath.row;
        PropKeysEntity *propKey = (PropKeysEntity *)_tableDataSource[rowIndex];
        keysTableViewCell.propKeysEntity = propKey;
        
        if ([_propKeyListPresenter isNewStyle])
        {
            keysTableViewCell.expertOfkeys.text = propKey.propertyKeyNo;
        }
        else
        {
            keysTableViewCell.expertOfkeys.text = propKey.propKeyStatus;
            keysTableViewCell.countOfKeys.text = [NSString stringWithFormat:@"%ld", (long)propKey.keyCount ];
        }
        
        keysTableViewCell.employeeName.text = propKey.receiver;
        keysTableViewCell.dateTime.text = propKey.receivedTime;
        keysTableViewCell.statusOfkeys.text = propKey.type;
        
        if ([_propKeyListPresenter haveContactNumber])
        {
            keysTableViewCell.specificLocation.text = [_propKeyListPresenter getKeyLocation:propKey];
            [keysTableViewCell.phoneNumberButton setTitle:[_propKeyListPresenter getLinkPhone:propKey] forState:UIControlStateNormal];
           
            keysTableViewCell.specificLocation.hidden = NO;
            keysTableViewCell.phoneNumberButton.hidden = NO;
        }
    }
    
    return keysTableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    [self back];
}

#pragma mark - ResponseDelegate

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if([modelClass isEqual:[PropKeyListEntity class]]){
        
        PropKeyListEntity *propKeyListEntity = [DataConvert convertDic:data toEntity:modelClass];;
        
        [_tableDataSource addObjectsFromArray:propKeyListEntity.keyList];
    }
    
    if(_tableDataSource.count <= 0){
        
        UIAlertView *noResultAlert = [[UIAlertView alloc]initWithTitle:@"暂无数据!"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"确定", nil];
        [noResultAlert show];
    }
    
    [self endRefreshWithTableView:_mainTableVIew];
    [_mainTableVIew reloadData];
}

@end
