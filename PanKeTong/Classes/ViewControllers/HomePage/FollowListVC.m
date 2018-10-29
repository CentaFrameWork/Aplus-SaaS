//
//  FollowListViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/18.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "FollowListVC.h"
#import "TimeScreenViewController.h"
#import "FollowSearchViewController.h"
#import "FilterEntity.h"
#import "PropLeftFollowApi.h"
#import "HQAllRoundDetailVC.h"
#import "PropLeftFollowItemEntity.h"
#import "PropLeftFollowEntity.h"

@interface FollowListVC ()<FollowSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    PropLeftFollowApi *_propLeftFollowApi;
    DataBaseOperation * _dataBase;
    DepartmentInfoResultEntity *_departmentInfoEntity;
    TimeScreenViewController *timeScreenVC;
    
    UITextField *_searchTextfield;
    UIButton *_rightSearchBtn;          // 搜索框右部按钮
    
    NSMutableArray *_tableViewSource;   // 表数据
    NSString *_personKeyId;             // 跟进人id
    NSString *_followDeptKeyId;         // 跟进人部门
    NSString *_keyword;                 // 跟进内容
    NSString *_startTime;               // 开始时间
    NSString *_endTime;                 // 结束时间
    NSString *_department;              // 选择部门
    
    BOOL _isSearching;                  // 是否正在搜索状态
    BOOL _isNative;
}
@property (nonatomic, strong)  UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray<NSDictionary*> *sourceArr;   // 表数据

@end

@implementation FollowListVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	_isNative = YES;
    NSTimeInterval timeInterval = -30 * 24 * 60 * 60;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    NSDate *endDate = [NSDate date];
    _startTime = [NSDate stringWithSimpleDate:startDate];
    _endTime = [NSDate stringWithSimpleDate:endDate];
	
    WS(weakSelf);
    [self checkShowViewPermission:MENU_PROPERTY_FOLLOW
           andHavePermissionBlock:^(NSString *permission) {
        
        _tableViewSource = [[NSMutableArray alloc]init];
        
        [weakSelf initView];
        [weakSelf initData];
        [weakSelf headerRefreshMethod];
    }];
}

#pragma mark - init

- (void)initView {
    
    
    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"筛选"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(goFilterVC)]];
    
    // 创建顶部搜索框
    _searchTextfield = [self createTextfieldWithPlaceholder:@"请输入业务员、跟进内容"
                                            andHaveRightBtn:YES];
    _searchTextfield.delegate = self;
    
     // 创建搜索框右部按钮voiceSearch_icon、close_btn
    _rightSearchBtn = [self createVoiceOrDeleteBtnWithImageName:@"top_right_04"
                                                    andSelector:@selector(clickVoiceSearch)];
    
    // 创建搜索框
    [self createTopSearchBarViewWithTextField:_searchTextfield
                                  andRightBtn:_rightSearchBtn];

    
   
    [self.view addSubview:self.mainTableView];
    
}

/**
 *  切换搜索框右部按钮状态和触发事件（搜索、未搜索）
 */
- (void)changeSearchBarRightBtnImageWithSearching:(BOOL)isSearching
{
    if (isSearching)
    {
        
        [_rightSearchBtn removeTarget:self
                               action:@selector(clickVoiceSearch)
                     forControlEvents:UIControlEventTouchUpInside];
        [_rightSearchBtn addTarget:self
                            action:@selector(clearSearchTextContent)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_rightSearchBtn setImage:[UIImage imageNamed:@"deleteCir"]
                         forState:UIControlStateNormal];
        
    }
    else
    {
        
        [_rightSearchBtn removeTarget:self
                               action:@selector(clearSearchTextContent)
                     forControlEvents:UIControlEventTouchUpInside];
        [_rightSearchBtn addTarget:self
                            action:@selector(clickVoiceSearch)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_rightSearchBtn setImage:[UIImage imageNamed:@"top_right_04"]
                         forState:UIControlStateNormal];
        
    }
    
    _isSearching = !isSearching;
}



- (void)initData
{
    _propLeftFollowApi = [PropLeftFollowApi new];
    
    // 默认查找本部的数据
    _dataBase = [DataBaseOperation sharedataBaseOperation];
    _departmentInfoEntity = [_dataBase selectAgencyUserInfo];
    
    // 默认为本部
    _followDeptKeyId = _departmentInfoEntity.identify.departId;
}

- (void)headerRefreshMethod
{
    [_tableViewSource removeAllObjects];
    [_mainTableView reloadData];
    [self requestData];
    [self showLoadingView:nil];  
}

- (void)footerRefreshMethod
{
    [self requestData];
}

- (void)requestData
{
    NSString *curPageNum = @"1";
    if(_tableViewSource)
    {
        curPageNum = [NSString stringWithFormat:@"%@",@(_tableViewSource.count/10+1)];
    }
    
    _propLeftFollowApi.followTypeKeyId = @"";
    _propLeftFollowApi.propertyKeyId = @"";
    _propLeftFollowApi.followTimeFrom = _startTime;
    _propLeftFollowApi.followTimeTo = _endTime ? _endTime : [CommonMethod formatDateStrFromDate:[NSDate date]];
    _propLeftFollowApi.keyword = _keyword ? _keyword : @"";
    _propLeftFollowApi.followPersonKeyId = _personKeyId ? _personKeyId : @"";
    _propLeftFollowApi.followDeptKeyId = _followDeptKeyId ? _followDeptKeyId : @"";
    _propLeftFollowApi.pageIndex = curPageNum;
    _propLeftFollowApi.pageSize = @"10";
    _propLeftFollowApi.sortField = @"";
    [_manager sendRequest:_propLeftFollowApi];
    
    [self showLoadingView:nil];
}


#pragma mark -进入房源详情

- (void)enterPropDetailViewController:(NSInteger)indexRow {
    
    
    
}

#pragma mark - FollowSearchDelegate

- (void)searchResultWithItem:(RemindPersonDetailEntity *)remindItem
{
    _personKeyId = remindItem.resultKeyId;
    
    if (_personKeyId)
    {
        _keyword = @"";
        _searchTextfield.text = remindItem.resultName;
        _followDeptKeyId = remindItem.departmentKeyId;
    }
    else
    {
        _keyword = remindItem.resultName;
        _searchTextfield.text = remindItem.resultName;
    }
   
    [self changeSearchBarRightBtnImageWithSearching:YES];
    [self headerRefreshMethod];
}

#pragma mark - *****搜索页面跳转******

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    FollowSearchViewController *followSearchVC = [[FollowSearchViewController alloc]
                                                  initWithNibName:@"FollowSearchViewController"
                                                  bundle:nil];
    followSearchVC.searchType = TopTextSearchType;
    
    if (!_isNative)
    {
        _followDeptKeyId = nil;
    }
    
    followSearchVC.followDeptKeyId = _followDeptKeyId;
    followSearchVC.delegate = self;
    [self. navigationController pushViewController:followSearchVC animated:YES];
    
    return NO;
}

- (void)goFilterVC
{
    WS(weakSelf);
	timeScreenVC = [[TimeScreenViewController alloc] initWithNibName:@"TimeScreenViewController"
                                                              bundle:nil];
	
    timeScreenVC.block = ^(NSString *startTime,NSString *endTime,NSString *followDeptKeyId,BOOL isNative){
        // 清空搜索框里面的内容

        if ([_startTime isEqualToString:startTime] && [_endTime isEqualToString:endTime] && isNative == _isNative)
        {
        
            return ;
        }
        
        if (isNative != _isNative)
        {
            _isNative = isNative;
            [weakSelf emptyData];
            [weakSelf changeSearchBarRightBtnImageWithSearching:NO];
             _followDeptKeyId = followDeptKeyId;
        }

        //筛选点击确定进行筛选
        _startTime = startTime;
        _endTime = endTime;
		_isNative = isNative;
		
        [weakSelf headerRefreshMethod];
    };
	
	timeScreenVC.startTime = _startTime;
	timeScreenVC.endTime = _endTime;
	timeScreenVC.isNative = _isNative;
    
    [self.navigationController pushViewController:timeScreenVC animated:YES];
}

/**
 *  语音搜索
 */
- (void)clickVoiceSearch
{
    FollowSearchViewController *followSearchVC = [[FollowSearchViewController alloc]
                                                  initWithNibName:@"FollowSearchViewController"
                                                  bundle:nil];
    followSearchVC.searchType = TopVoidSearchType;
    followSearchVC.followDeptKeyId = _followDeptKeyId;
    followSearchVC.delegate = self;
    [self. navigationController pushViewController:followSearchVC animated:YES];
}

/**
 *  点击清除搜索内容按钮
 */
- (void)clearSearchTextContent
{
    [self emptyData];
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    [self headerRefreshMethod];
}


#pragma mark - ******tableview*******


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sourceArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = _sourceArr[section][@"content"];
    
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followListCell" forIndexPath:indexPath];
    
    cell.propLeftFollowItemEntity = _sourceArr[indexPath.section][@"content"][indexPath.row];
    cell.timeType  = _sourceArr[indexPath.section][@"title"];
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    
    if (!headView) {
        
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headView"];
        headView.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    headView.textLabel.text = _sourceArr[section][@"title"];

    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PropLeftFollowItemEntity *followItem = _sourceArr[indexPath.section][@"content"][indexPath.row];
    CGFloat height = [followItem.followContent getStringHeight:[UIFont systemFontOfSize:14] width:APP_SCREEN_WIDTH-82 size:14.0];
    
    return 57 + ceilf(height);
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    PropLeftFollowItemEntity *followItem = _tableViewSource[indexPath.row];
    
    
    PropertyDetailVC *allRoundDetailVC = [[PropertyDetailVC alloc] init];
    allRoundDetailVC.isFollowRecord = YES;
    allRoundDetailVC.propKeyId = followItem.propertyKeyId;
    [self.navigationController pushViewController:allRoundDetailVC animated:YES];
}

/**
 *  页面销毁或点击清除搜索内容按钮
 */
- (void)emptyData
{
    _personKeyId = nil;
    _keyword = nil;
    NSTimeInterval timeInterval = -30 * 24 * 60 * 60;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    NSDate *endDate = [NSDate date];
    _startTime = [NSDate stringWithSimpleDate:startDate];
    _endTime = [NSDate stringWithSimpleDate:endDate];
    _department = nil;
        
    if (_followDeptKeyId.length > 1)
    {
        // 当前选择的为全部
        _departmentInfoEntity = [_dataBase selectAgencyUserInfo];
        
        NSString *thisDeptKeyId = _departmentInfoEntity.identify.departId;
        
        if (!_isNative)
        {
            _followDeptKeyId = nil;
        }
        
        if (![_followDeptKeyId isEqualToString:thisDeptKeyId])
        {
            _followDeptKeyId = nil;
        }
    }
    
    _searchTextfield.text = @"";
}


#pragma mark - ResponseDelegate
- (void)dealData:(id)data andClass:(id)modelClass {
    
    [self endRefreshWithTableView:_mainTableView];
    
    if([modelClass isEqual:[PropLeftFollowEntity class]]) {
        
        PropLeftFollowEntity *propLeftFollowEntity = [DataConvert convertDic:data
                                                                    toEntity:modelClass];
        
        [_tableViewSource addObjectsFromArray:propLeftFollowEntity.propFollows];
        
        [self setGroupArray];
        
        if (_tableViewSource.count == 0) {
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
        }else{
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }
        
        if(propLeftFollowEntity.propFollows.count < 10){

            _mainTableView.mj_footer.hidden = YES;
       
        }else{

            _mainTableView.mj_footer.hidden = NO;
        }
    }
    
    [_mainTableView reloadData];


}

- (void)setGroupArray {
    
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSMutableArray *todayMut = [NSMutableArray array];
    NSMutableArray *otherMut = [NSMutableArray array];
    [_tableViewSource enumerateObjectsUsingBlock:^(PropLeftFollowItemEntity*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    
        NSArray *arr = [obj.followTime componentsSeparatedByString:@"T"];
       
        NSDate *date = [formater dateFromString:arr[0]];
        
        if ([cal isDateInToday:date]) {
            
            [todayMut addObject:obj];
            
        }else{
            
            [otherMut addObject:obj];
        }
        
    }];
    
     _sourceArr = [NSMutableArray array];
    
    if (todayMut.count) {
        
        [_sourceArr addObject:@{@"title":@"今天",@"content":todayMut}];
    }
    
    if (otherMut.count) {
        
        [_sourceArr addObject:@{@"title":@"以前",@"content":otherMut}];
    }
    
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight-APP_NAV_HEIGHT) style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = 0;
        _mainTableView.sectionHeaderHeight = 44;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
        
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
        

        [_mainTableView registerNib:[UINib nibWithNibName:@"FollowListTableViewCell"
                                                   bundle:nil] forCellReuseIdentifier:@"followListCell"];


        
    }
    
    return _mainTableView;
    
}


@end
