//
//  WJDealListController.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJDealListController.h"
#import "DealDetailController.h"

//#import "WJDealListCell.h"
#import "DealCell.h"

#import "WJAllDealModel.h"

#import "UITableView+Category.h"


@interface WJDealListController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray * _dataSource;
}

@end

@implementation WJDealListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
    // Do any additional setup after loading the view.
}


- (void)initData {
    
    
    _dataSource = [[NSMutableArray alloc] init];
    [self headerRefreshMethod];
}


#pragma mark - 建立视图
- (void)initView
{
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    
    [self setNavTitle:@"成交记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    //    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    [self.view addSubview:_mainTableView];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
- (void)headerRefreshMethod
{
    [_dataSource removeAllObjects];
    [_mainTableView reloadData];
    [self requestData];
    [self showLoadingView:nil];
}

- (void)footerRefreshMethod
{
    [self requestData];
}

- (void)requestData {
    
    NSString *string = [NSString stringWithFormat:@"%@?PropertyKeyId=%@&StartCreateTime=%@&EndCreateTime=%@&PageIndex=%@&PageSize=%@&SortField=%@&Ascending=%@&IsMobileRequest=%@",WJDealListAPI,_propKeyId,@"",@"",[NSString stringWithFormat:@"%@",@(_dataSource.count/10+1)],@"10",@"",@"",@(true)];
    
    [AFUtils GET:string controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        NSLog(@"successfuldict===%@",successfuldict);
        [self endRefreshWithTableView:_mainTableView];
        
        NSInteger count = [[successfuldict objectForKey:@"RecordCount"] integerValue];
        
        for (NSDictionary *mainDic in successfuldict[@"Transactions"]) {
            WJAllDealModel * model = [[WJAllDealModel alloc] initDic:mainDic];
            [_dataSource addObject:model];
        }
        if ((_dataSource.count/10 + 1) > 1) {
            NSArray *arr = successfuldict[@"Transactions"];
            if (arr.count < 10) {
                
                _mainTableView.mj_footer.hidden = YES;
                
            }else {
                _mainTableView.mj_footer.hidden = NO;
            }
            
        }
        
        if (_dataSource.count == count){
            
            _mainTableView.mj_footer.hidden = YES;
            
        }
        
        [_mainTableView reloadData];
        
        
    } failureDict:^(NSDictionary *failuredict) {
        NSLog(@"failuredict===%@",failuredict);
    } failureError:^(NSError *failureerror) {
        NSLog(@"failureerror===%@",failureerror);
    }];
    
    
}



#pragma mark - tableView代理事件
/**
 * tableView的分区数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/**
 * tableView分区里的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

/**
 * tableViewCell的相关属性
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"DealCell";
    
    DealCell *cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    cell.wjModel = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DealDetailController *vc = [[DealDetailController alloc] init];
    
    vc.model = _dataSource[indexPath.row];
    vc.titleString =@"成交详情";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - private
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
