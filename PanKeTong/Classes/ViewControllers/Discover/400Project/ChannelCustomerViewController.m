//
//  ChannelCustomerViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/4.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#define RightBtnVoiceImageName          @"voiceSearch_icon"
#define RightBtnVoiceImageName          @"voiceSearch_icon"
#define RightDelSearchImageName         @"close_btn"
#define ItemClickActionTag              200

#import "ChannelCustomerViewController.h"
#import "BJTurnPrivateCustomerVC.h"
#import "ChannelCustomersTableViewCell.h"

#import "ChannelCustomerBJPresenter.h"
#import "ChannelCustomerTJPresenter.h"
#import "ChannelCustomerNJPresenter.h"
#import "ChannelCustomerSZPresenter.h"
#import "ChannelCustomerGZPresenter.h"
#import "ChannelCustomerAMPresenter.h"
#import "ChannelCustomerCQPresenter.h"
#import "ChannelCustomerCSPresenter.h"

#import "ChannelCustomerViewProtocol.h"

@interface ChannelCustomerViewController ()<BJTurnPrivateDelegate,ChannelCustomerViewProtocol>
{
    UITextField *_searchTextfield;      //顶部搜索textfield
    UIButton *_rightSearchBtn;          //搜索框右部按钮
    NSString *_searchKeyWord;           //顶部搜索关键字
    BOOL _isSearching;  //是否正在搜索状态
    
    ChannelCallApi *_channelCallApi;
    NSMutableArray *_tableViewSource;
    NSInteger _clickIndex;
    NSString *_publicAccountKeyId;
    
    ChannelFilterEntity *_channelFilterEntity;  //筛选结果
    
    QueryPhoneAddressUtil *_queryPhoneAddressUtil;
    NSMutableArray *_phoneAddress;
    
    ChannelCustomerBasePresenter *_channelCustomerPresenter;
}

@end

@implementation ChannelCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkShowViewPermission:CUSTOMER_PUBLIC_CHANNEL andHavePermissionBlock:^(NSString *permission) {
        _tableViewSource = [[NSMutableArray alloc]init];
        [self initPresenter];
        [self initView];
        [self initData];
    }];
}


- (void)initView
{
    
    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"筛选"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(goFilterVC)]];
    
    /**
     *  创建顶部搜索框
     */
    _searchTextfield = [self createTextfieldWithPlaceholder:@"原归属人或公共池"
                                            andHaveRightBtn:YES];
    _searchTextfield.delegate = self;
    
    /**
     *  创建搜索框右部按钮voiceSearch_icon、close_btn
     */
    _rightSearchBtn = [self createVoiceOrDeleteBtnWithImageName:RightBtnVoiceImageName
                                                    andSelector:@selector(clickVoiceSearch)];
    
    
    /**
     *  创建搜索框
     */
    [self createTopSearchBarViewWithTextField:_searchTextfield
                                  andRightBtn:_rightSearchBtn];
    
    
    [_mainTableview addHeaderWithTarget:self
                                 action:@selector(headerRefreshMethod)];
    [_mainTableview addFooterWithTarget:self
                                 action:@selector(footerRefreshMethod)];
    
    _mainTableview.tableFooterView = [[UIView alloc]init];
    
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    
}

- (void)initPresenter
{
    if ([CityCodeVersion isTianJin]) {
        _channelCustomerPresenter = [[ChannelCustomerTJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isBeiJing]){
        _channelCustomerPresenter = [[ChannelCustomerBJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isNanJing]){
        _channelCustomerPresenter = [[ChannelCustomerNJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isShenZhen]){
        _channelCustomerPresenter = [[ChannelCustomerSZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isGuangZhou]){
        _channelCustomerPresenter = [[ChannelCustomerGZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isAoMenHengQin]){
        _channelCustomerPresenter = [[ChannelCustomerAMPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChongQing]){
        _channelCustomerPresenter = [[ChannelCustomerCQPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChangSha]){
        _channelCustomerPresenter = [[ChannelCustomerCSPresenter alloc] initWithDelegate:self];
    }else{
        _channelCustomerPresenter = [[ChannelCustomerBasePresenter alloc] initWithDelegate:self];
    }
}

- (void)initData
{
    _channelFilterEntity = [[ChannelFilterEntity alloc]init];
    _phoneAddress = [[NSMutableArray alloc]init];
    
    _queryPhoneAddressUtil = [QueryPhoneAddressUtil shareQueryPhoneAddressUtil];
    _queryPhoneAddressUtil.delegate = self;
    [self request];
}

- (void)request
{
    [self showLoadingView:nil];

    NSString *curPageNum = @"1";
    if(_tableViewSource){
        curPageNum = [NSString stringWithFormat:@"%@",@(_tableViewSource.count / 10 + 1)];
    }
    
    if(_searchKeyWord == nil){
        _searchKeyWord = @"";
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:YearToMinFormat];
    
    NSString *startTime = [dateFormatter stringFromDate:_channelFilterEntity.startTime];
    NSString *endTime = [dateFormatter stringFromDate:_channelFilterEntity.endTime];
    if(!startTime){
        startTime = @"";
    }
    if(!endTime){
        endTime = @"";
    }
    
    NSString *departmentKeyId = _channelFilterEntity.department.resultKeyId ;
    NSString *personKeyId = _channelFilterEntity.person.resultKeyId;
    if(!departmentKeyId){
        departmentKeyId = @"";
    }
    if(!personKeyId){
        personKeyId = @"";
    }
    
    
    NSString *channelSource = @"";
    if(_channelFilterEntity.channelSource){
        NSUInteger count = _channelFilterEntity.channelSource.count;
        for (int n = 0; n < count; n++) {
            SelectItemDtoEntity *sysParam = _channelFilterEntity.channelSource[n];
            if(n > 0){
                channelSource = [NSString stringWithFormat:@"%@,%@",channelSource,sysParam.itemValue];
            }else{
                channelSource = sysParam.itemValue;
            }
        }
    }
    
    if(!_publicAccountKeyId)
    {
        _publicAccountKeyId = @"";
    }

    _channelCallApi = [[ChannelCallApi alloc] init];
    _channelCallApi.channelType = ChannelCustomer;
//    _channelCallApi.phoneLike = _searchKeyWord;
    _channelCallApi.channelSourceStr = channelSource;
    _channelCallApi.startDate = startTime;
    _channelCallApi.endDate = endTime;
    _channelCallApi.chiefDeptKeyId = departmentKeyId;
    _channelCallApi.chiefKeyId = personKeyId;
    _channelCallApi.publicAccountKeyId = _publicAccountKeyId;
    _channelCallApi.channelInquiryRange = @"";
    _channelCallApi.pageIndex = curPageNum;
    _channelCallApi.pageSize = @"10";
    _channelCallApi.sortField = @"";
    _channelCallApi.ascending = @"true";
    [_manager sendRequest:_channelCallApi];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    AutoCompleteTipViewController *searchVC = [[AutoCompleteTipViewController alloc]initWithNibName:@"AutoCompleteTipViewController"
                                                                                             bundle:nil];
    searchVC.searchType = TopTextSearchType;
    searchVC.isFromMainPage = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
}



- (void)goFilterVC
{
    ChannelCallFilterViewController *channelCallFilterViewController = [[ChannelCallFilterViewController alloc]initWithNibName:@"ChannelCallFilterViewController"
                                                                                                                        bundle:nil];
    channelCallFilterViewController.isShowStaff = NO;
    NSDictionary *dic = [_channelFilterEntity dictionaryFromModel];
    NSLog(@"%@",dic);
    if (_channelFilterEntity.startTime != nil || _channelFilterEntity.endTime != nil) {
        [dic setValue:_channelFilterEntity.startTime forKey:@"startTime"];
        [dic setValue:_channelFilterEntity.endTime forKey:@"endTime"];
    }
    channelCallFilterViewController.dataDic = dic;
//    channelCallFilterViewController.channelFilterEntity = _channelFilterEntity;
    channelCallFilterViewController.delegate = self;
    [self.navigationController pushViewController:channelCallFilterViewController
                                         animated:YES];
}

- (void)clickVoiceSearch
{
    //语音搜索
    
    AutoCompleteTipViewController *searchVC = [[AutoCompleteTipViewController alloc]initWithNibName:@"AutoCompleteTipViewController"
                                                                           bundle:nil];
    searchVC.searchType = TopVoidSearchType;
    searchVC.isFromMainPage = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
    
}

#pragma mark - AutoCompleteChiefOrPublicAccountDelegate
- (void)autoCompleteWithEntity:(RemindPersonDetailEntity *)entity
{
    if(!_channelFilterEntity.person)
    {
        _channelFilterEntity.person = [[RemindPersonDetailEntity alloc]init];
    }
    if(!_channelFilterEntity.department)
    {
        _channelFilterEntity.department = [[RemindPersonDetailEntity alloc]init];
    }

    _searchKeyWord = entity.resultName;
        //归属人
    if(entity.userOrDepart == 1){
        _channelFilterEntity.department.resultKeyId = entity.departmentKeyId;
        _channelFilterEntity.person.resultKeyId = entity.resultKeyId;
        _publicAccountKeyId = @"";
    }else{
        //公客池
        _publicAccountKeyId = entity.resultKeyId;
        _channelFilterEntity.department.resultKeyId = @"";
        _channelFilterEntity.person.resultKeyId = @"";
    }
    
    [self changeSearchBarRightBtnImageWithSearching:YES];
    
    [self headerRefreshMethod];
}

- (void)headerRefreshMethod
{
    [_phoneAddress removeAllObjects];
    [_tableViewSource removeAllObjects];
    [_mainTableview reloadData];
    [self request];
}

- (void)footerRefreshMethod
{
    [self request];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableViewSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableview deselectRowAtIndexPath:indexPath animated:YES];
    _clickIndex = indexPath.section;
    BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:
                                        @"拨打电话",@"转私客",@"查看明细", nil];
    byActionSheet.tag = ItemClickActionTag;
    
    [byActionSheet show];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"channelCustomerTableViewCell";
    
    ChannelCustomersTableViewCell *channelCustomersTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!channelCustomersTableViewCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ChannelCustomersTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        channelCustomersTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.section;
    ChannelCallModelEntity *channelCustomer = _tableViewSource[row];
    
    NSString *channelSource = @" ";
    if(channelCustomer.mchannelInquirySources && ![channelCustomer.mchannelInquirySources isEqualToString:@""])
    {
        channelSource = channelCustomer.mchannelInquirySources;
    }
    double timeDouble = [CommonMethod tryTimeNumberWith:channelCustomer.mcreateTime];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[channelCustomer.mcreateTime substringToIndex:4] integerValue]];

    PhoneAddressInfo *phoneInfo;
    if(_phoneAddress.count > row){
        phoneInfo = _phoneAddress[row];
    }
    NSString *address = @"";
    if(phoneInfo){
        address = phoneInfo.city;
    }
    
    channelCustomersTableViewCell.channelPhone.text = channelCustomer.mphone;
    channelCustomersTableViewCell.channelSource.text = channelSource;
    channelCustomersTableViewCell.agentInfo.text = [NSString stringWithFormat:@"%@  %@",channelCustomer.mchannelInquiryChief,channelCustomer.mchannelInquiryChiefDept];
    channelCustomersTableViewCell.departmentOfAgent.text = channelCustomer.mpublicAccount;
    channelCustomersTableViewCell.createTime.text = time;
    
    channelCustomersTableViewCell.phoneAddress.text = address;
    
    return channelCustomersTableViewCell;
}

#pragma mark - ActionSheetDelegate
- (void)actionSheetView:(BYActionSheetView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
{
    NSInteger tag = alertView.tag;
    if(tag == ItemClickActionTag){
        
        ChannelCallModelEntity *channelCustomer = _tableViewSource[_clickIndex];
        switch (buttonIndex) {
            case 0:
            {
                [self callPhone:channelCustomer.mphone];
            }
                break;
            case 1:
            {
                // 跳转到转私客
                [_channelCustomerPresenter toTurnPrivateCustomerVC];
            }
                break;
            case 2:
            {
                
                ChannelDetailViewController *channelDetailViewController = [[ChannelDetailViewController alloc]initWithNibName:@"ChannelDetailViewController" bundle:nil];
                channelDetailViewController.phoneNum = channelCustomer.mphone;
                channelDetailViewController.keyId = channelCustomer.mkeyId;
                [self.navigationController pushViewController:channelDetailViewController
                                                     animated:YES];
            }
                break;
                
            default:
                break;
        }

    }
}

- (void)callPhone:(NSString *)phoneNum
{
    NSString *tip = @"暂无联系方式！";
    if(phoneNum)
    {
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
    else
    {
        showMsg(tip);
    }
}


/**
 *  切换搜索框右部按钮状态和触发事件（搜索、未搜索）
 */
- (void)changeSearchBarRightBtnImageWithSearching:(BOOL)isSearchIng
{
    
    _searchTextfield.text = _searchKeyWord;
    
    if (isSearchIng) {
        
        
        [_rightSearchBtn removeTarget:self
                               action:@selector(clickVoiceSearch)
                     forControlEvents:UIControlEventTouchUpInside];
        [_rightSearchBtn addTarget:self
                            action:@selector(clearSearchTextContent)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_rightSearchBtn setImage:[UIImage imageNamed:RightDelSearchImageName]
                         forState:UIControlStateNormal];
        
    }else{
        
        [_rightSearchBtn removeTarget:self
                               action:@selector(clearSearchTextContent)
                     forControlEvents:UIControlEventTouchUpInside];
        [_rightSearchBtn addTarget:self
                            action:@selector(clickVoiceSearch)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_rightSearchBtn setImage:[UIImage imageNamed:RightBtnVoiceImageName]
                         forState:UIControlStateNormal];
        
    }
    
    _isSearching = !isSearchIng;
}


/**
 *  点击清除搜索内容按钮
 */
- (void)clearSearchTextContent
{
    
    _searchTextfield.text = @"";
    _searchKeyWord = @"";
    _publicAccountKeyId = @"";
    
    _channelFilterEntity.department.resultKeyId = @"";
    _channelFilterEntity.person.resultKeyId = @"";
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    
    [_mainTableview headerBeginRefreshing];
}

#pragma mark - ChannelCustomerViewProtocol
- (void)goTurnPrivateCustomer
{
    ChannelCallModelEntity *channelCustomer = _tableViewSource[_clickIndex];
    // 座机手机是否有区分
    if ([_channelCustomerPresenter haveDistinguishLandlineAndMobile])
    {
        BJTurnPrivateCustomerVC *turnPrivateCustomerViewController = [[BJTurnPrivateCustomerVC alloc]initWithNibName:
                                                                      @"BJTurnPrivateCustomerVC" bundle:nil];
        turnPrivateCustomerViewController.channel = channelCustomer.mchannelInquirySources;
        turnPrivateCustomerViewController.channelKeyId = channelCustomer.mchannelSourceKeyId;
        turnPrivateCustomerViewController.phoneNumber = channelCustomer.mphone;
        turnPrivateCustomerViewController.keyId = channelCustomer.mkeyId;
        turnPrivateCustomerViewController.delegate = self;
        [self.navigationController pushViewController:turnPrivateCustomerViewController
                                             animated:YES];
    }
    else
    {
        TurnPrivateCustomerViewController *turnPrivateCustomerViewController = [[TurnPrivateCustomerViewController alloc]initWithNibName:
                                                                                @"TurnPrivateCustomerViewController" bundle:nil];
        
        
        turnPrivateCustomerViewController.channel = channelCustomer.mchannelInquirySources;
        turnPrivateCustomerViewController.channelKeyId = channelCustomer.mchannelSourceKeyId;
        turnPrivateCustomerViewController.phoneNumber = channelCustomer.mphone;
        turnPrivateCustomerViewController.keyId = channelCustomer.mkeyId;
        turnPrivateCustomerViewController.delegate = self;
        [self.navigationController pushViewController:turnPrivateCustomerViewController
                                             animated:YES];
        
    }
}

#pragma mark - ChannelFilterDelegate
- (void)channelFilterResult:(ChannelFilterEntity *)result
{
    _channelFilterEntity = result;
    [self headerRefreshMethod];
}

#pragma mark －BJTurnPrivateDelegate
- (void)turnPrivateDoneInBeijing
{
    [self headerRefreshMethod];

}


#pragma mark - QueryResultDelegate
- (void)queryPhoneAddressResult:(NSArray *)result
{
    [self endRefreshWithTableView:_mainTableview];
    
    [_phoneAddress addObjectsFromArray:result];
    
    [_mainTableview reloadData];
    [self hiddenLoadingView];
}

- (void)turnDone
{
    [self headerRefreshMethod];
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self endRefreshWithTableView:_mainTableview];

    if([modelClass isEqual:[ChannelCallEntity class]])
    {
        ChannelCallEntity *channelCallEntity = [DataConvert convertDic:data toEntity:modelClass];;

        NSString *phoneStrings = [QueryPhoneAddressUtil extractPhoneFromChannelCall:channelCallEntity];
//        [_queryPhoneAddressUtil requestQueryPhoneAddressWithPhones:phoneStrings];

        [_tableViewSource addObjectsFromArray:channelCallEntity.mresult];

        if(channelCallEntity.mresult.count < 10){
            _mainTableview.footerHidden = YES;
        }else{
            _mainTableview.footerHidden = NO;
        }

        if (channelCallEntity.mresult.count == 0) {

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableview
                                  andShow:YES];
        }else{

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableview
                                  andShow:NO];
        }
    }


    [_mainTableview reloadData];
    [self hiddenLoadingView];

}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableview];
}

@end
