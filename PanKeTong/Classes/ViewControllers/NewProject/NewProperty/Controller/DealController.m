//
//  DealController.m
//  PanKeTong
//
//  Created by Admin on 2018/3/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealController.h"
#import "DealCell.h"
#import "WJAllDealScreenController.h"
#import "WJAllDealModel.h"
#import "DealDetailController.h"

#import "UITableView+Category.h"

//判断字段时候为空的情况
#define IfNullToString(x)  ([(x) isEqual:[NSNull null]]||(x)==nil||[(x) isEqualToString:@"(null)"])?@"":TEXTString(x)
#define TEXTString(x) [NSString stringWithFormat:@"%@",x]  //转换为字符串
@interface DealController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _dataSource;
   
}

@property (nonatomic, copy) NSString *PropertyCategory;//左导列表
@property (nonatomic, copy) NSString *EstateNames;//楼盘KeyId
@property (nonatomic, copy) NSString *BuildingNames;//栋座单元
@property (nonatomic, copy) NSString *StartTime;//开始时间
@property (nonatomic, copy) NSString *EndTime;// 结束时间
@property (nonatomic, copy) NSString *TransactionType;//租售类型
@property (nonatomic, copy) NSString *TransactionUserName;//成交人
@property (nonatomic, copy) NSString *ContractType;// 成交进度
@property (nonatomic, copy) NSString *PerformanceUserName;//业绩分配人
@property (nonatomic, copy) NSString *PageIndex;//当前页码
@property (nonatomic, copy) NSString *PageSize;//页容量（每页多少条）
@property (nonatomic, copy) NSString *SortField;//排序字段名称
@property (nonatomic, copy) NSString *Ascending;//排序方向
//@property (nonatomic, assign) BOOL IsMobileRequest;//是否是手机端请求

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;//参数字典

@property (nonatomic, strong) ZYDealScreen * dealScreen;//缓存搜索对象


@end

@implementation DealController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self initDataContainerAndData];
    [self initView];
   
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    //新增权限判定
    if(_isMyDeal){
        
        
        [self checkShowViewPermission:PROPERTY_MY_TRANSACTION andHavePermissionBlock:^(NSString *permission) {
            
             [self initData];
        }];
        
    }else {
        
        [self checkShowViewPermission:PROPERTY_ALL_TRANSACTION andHavePermissionBlock:^(NSString *permission) {
            
             [self initData];
        }];
    }
    
    
    
}
- (void)initData {
    _dataSource = [[NSMutableArray alloc] init];
    [self headerRefreshMethod];
}


- (void)initView {
    NSString *titleStr;
    if(_isMyDeal){
        titleStr = @"我的成交";
    }else {
        titleStr = @"全部成交";
    }
    [self setNavTitle:titleStr
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"icon_jm_nav_back_light_gray"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"筛选"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(DealScreen)]];
    
    [self.view addSubview:self.myTableView];
    
    if (@available(iOS 11.0, *)) {
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

- (void)headerRefreshMethod
{
    [_dataSource removeAllObjects];
    [_myTableView reloadData];
    [self requestData];
    [self showLoadingView:nil];
}


- (void)footerRefreshMethod
{
    [self requestData];
}

#pragma mark - 初始化数据容器和数据
- (void)initDataContainerAndData
{
    _PropertyCategory = @"";
    _EstateNames = @"";
    _BuildingNames = @"";
    _StartTime = @"";
    _EndTime = @"";
    _TransactionType = @"";
    _TransactionUserName = @"";
    _ContractType = @"";
    _PerformanceUserName = @"";
    
}


- (void)requestData {
    if (_isMyDeal) {
        _PropertyCategory = @"13";
    }else {
        _PropertyCategory = @"14";
    }
    
    NSInteger pageSize = 20;
    
    _parameterDic = (NSMutableDictionary *)@{@"PropertyCategory" : _PropertyCategory,//左导列表
                                             @"EstateNames" : _EstateNames ? : @"",//楼盘KeyId
                                             @"BuildingNames" : _BuildingNames ? : @"",//栋座单元
                                             @"StartTime" : _StartTime ? : @"",//开始时间
                                             @"EndTime" : _EndTime ? : @"",// 结束时间
                                             @"TransactionType" : _TransactionType ? : @"",//租售类型
                                             @"TransactionUserName" : _TransactionUserName ? : @"",//成交人
                                             @"ContractType" : _ContractType ? : @"",// 成交进度
                                             @"PerformanceUserName" : _PerformanceUserName ? : @"",//业绩分配人
                                             @"PageIndex" : [NSString stringWithFormat:@"%@",@(_dataSource.count/pageSize+1)],//当前页码
                                             @"PageSize" : @(pageSize),//页容量（每页多少条）
                                             @"SortField" : @"",//排序字段名称
                                             @"Ascending" : @"",//排序方向
                                             @"IsMobileRequest" : @(true),//是否是手机端请求
                                             };
    
    //陈行修改112bug
    NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in [_parameterDic allKeys]) {
        
        NSString * value = [NSString stringWithFormat:@"%@", [_parameterDic objectForKey:key]];
        
        value = [value isEqualToString:@"请选择"] ? @"" : value;
        
        [tmpDict setObject:value forKey:key];
        
    }
    
    _parameterDic = tmpDict;
    
    NSLog(@"_parameterDic===%@",_parameterDic);
    
    
    [AFUtils GET:WJAllDealAPI parameters:_parameterDic controller:self successfulDict:^(NSDictionary *successfuldict) {
        NSLog(@"successfuldict===%@",successfuldict);
        [self endRefreshWithTableView:_myTableView];
        
        NSInteger count = [[successfuldict objectForKey:@"RecordCount"] integerValue];
        
        for (NSDictionary *mainDic in successfuldict[@"Transactions"]) {
            WJAllDealModel * model = [[WJAllDealModel alloc] initDic:mainDic];
            
            [_dataSource addObject:model];
            
        }
        
        _myTableView.mj_footer.hidden = _dataSource.count == count;
        
        [_myTableView reloadData];
    } failureDict:^(NSDictionary *failuredict) {
        NSLog(@"failuredict===%@",failuredict);
    } failureError:^(NSError *failureerror) {
        NSLog(@"failureerror===%@",failureerror);
    }];
    
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return _dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"DealCell";
    
    DealCell *cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    cell.wjModel = _dataSource[indexPath.row];
    //陈行修改104bug
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DealDetailController *vc = [[DealDetailController alloc] init];
    
    vc.model = _dataSource[indexPath.row];
    vc.titleString = [@"成交" stringByAppendingString:@"详情"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT- APP_NAV_HEIGHT - BOTTOM_SAFE_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    
    return _myTableView;
    
}


- (void)DealScreen {
    WJAllDealScreenController *myVC = [[WJAllDealScreenController alloc] init];
    myVC.isMyDeal = self.isMyDeal;
    [myVC setDealScreen:self.dealScreen];
    
    __block typeof(self) weakSelf = self;
    
    [myVC setEnsureDealScreenBlock:^(NSDictionary *dict, ZYDealScreen *dealScreen) {
        
        _PropertyCategory = IfNullToString(dict[@"PropertyCategory"]);
        _StartTime = IfNullToString(dict[@"StartTime"]);
        _EstateNames = IfNullToString(dict[@"EstateNames"]);
        _BuildingNames =IfNullToString(dict[@"BuildingNames"]);
        _EndTime = IfNullToString(dict[@"EndTime"]);
        _TransactionType = IfNullToString(dict[@"TransactionType"]);
        _TransactionUserName = IfNullToString(dict[@"TransactionUserName"]);
        _ContractType = IfNullToString(dict[@"ContractType"]);
        _PerformanceUserName = IfNullToString(dict[@"PerformanceUserName"]);
        
        weakSelf.dealScreen = dealScreen;
        
        //下拉刷新 加载数据
//        [weakSelf headerRefreshMethod];
        
    }];
    
    [self.navigationController pushViewController:myVC animated:YES];
}


@end
