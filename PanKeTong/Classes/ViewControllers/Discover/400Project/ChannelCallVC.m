//
//  ChannelCallViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/5.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#define RightBtnVoiceImageName          @"voiceSearch_icon"
#define RightBtnVoiceImageName          @"voiceSearch_icon"
#define RightDelSearchImageName         @"close_btn"
#define ItemClickActionTag              200
#define SearchTag                       3013

#import "BJTurnPrivateCustomerVC.h"
#import "ChannelCallVC.h"

@interface ChannelCallVC () <BJTurnPrivateDelegate>
{
    UITextField *_searchTextfield;      //顶部搜索textfield
    UIButton *_rightSearchBtn;          //搜索框右部按钮
    NSString *_searchKeyWord;           //顶部搜索关键字
    IFlyUtil *iflyUtil;
    
    NSInteger _clickIndex;
    
    NSMutableArray *_tableViewSource;
    NSMutableArray *_phoneAddress;
    
    ChannelCallApi *_channelCallApi;
    QueryPhoneAddressUtil *_queryPhoneAddressUtil;
    
    ChannelFilterEntity *_channelFilterEntity;//筛选结果
    NSInteger _sumLength;//搜索框输入的总长度
    NSMutableString *_searchText;
    
}

@end

@implementation ChannelCallVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self checkShowViewPermission:CUSTOMER_ALL_CHANNEL andHavePermissionBlock:^(NSString *permission) {
        _tableViewSource = [[NSMutableArray alloc]init];
        
        [self initView];
        [self initData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initView
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
    _sumLength = 0;
    _searchText = [NSMutableString string];
    _searchTextfield = [self createTextfieldWithPlaceholder:@"请输入电话"
                                            andHaveRightBtn:YES];
    
//    [_searchTextfield setBorderStyle:UITextBorderStyleNone];
    
    _searchTextfield.returnKeyType = UIReturnKeySearch;
    _searchTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    _searchTextfield.delegate = self;
    _searchTextfield.tag = SearchTag;
    
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
    
    
//    [_mainTableview addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
//    [_mainTableview addFooterWithTarget:self
//                                 action:@selector(footerRefreshMethod)];
    _mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];

    
    _mainTableview.tableFooterView = [[UIView alloc]init];
    
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    
    /*
     *添加搜索框监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
}

- (void)back
{
    [super back];
    if ([_searchTextfield isFirstResponder]) {
        
        [_searchTextfield resignFirstResponder];
    }
}



- (void)initData
{
    _channelFilterEntity =[[ChannelFilterEntity alloc]init];
    _phoneAddress = [[NSMutableArray alloc]init];
    
    _queryPhoneAddressUtil = [QueryPhoneAddressUtil shareQueryPhoneAddressUtil];
    _queryPhoneAddressUtil.delegate = self;
    
    _searchText = [NSMutableString string];
    
    
    [self request];
}

- (void)request
{
    [self showLoadingView:nil];
    
    NSString *curPageNum = @"1";
    if(_tableViewSource){
        curPageNum = [NSString stringWithFormat:@"%@",@(_tableViewSource.count/10+1)];
    }
    
    if(_searchKeyWord == nil){
        _searchKeyWord = @"";
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:OnlyDateFormat];
    
    NSString *startTime = [dateFormatter stringFromDate:_channelFilterEntity.startTime];
    NSString *endTime = [dateFormatter stringFromDate:_channelFilterEntity.endTime];
    
    if(!startTime)
    {
        startTime = @"";
    }
    else
    {
        startTime = [NSString stringWithFormat:@"%@ 00:00:00",startTime];
    }
    
    if(!endTime)
    {
        endTime = @"";
    }
    else
    {
        endTime = [NSString stringWithFormat:@"%@ 23:59:59",endTime];
    }

    NSString *departmentKeyId = _channelFilterEntity.department.resultKeyId ;
    NSString *personKeyId = _channelFilterEntity.person.resultKeyId;
    if(!departmentKeyId)
    {
        departmentKeyId = @"";
    }
    if(!personKeyId)
    {
        personKeyId = @"";
    }
    
    NSString *range = @"-1";
    if([AgencyUserPermisstionUtil hasRight:CUSTOMER_CHANNEL_SEARCH_MYSELF]){
        range = [NSString stringWithFormat:@"%d",MYSELF];
    }else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_CHANNEL_SEARCH_MYDEPARTMENT]){
        range = [NSString stringWithFormat:@"%d",MYDEPARTMENT];
    }else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_CHANNEL_SEARCH_ALL]){
        range = [NSString stringWithFormat:@"%d",ALL];
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
    

    _channelCallApi = [[ChannelCallApi alloc] init];
    _channelCallApi.channelType = ChannelCall;
    _channelCallApi.phoneLike = _searchKeyWord;
    _channelCallApi.channelSourceStr = channelSource;
    _channelCallApi.startDate = startTime;
    _channelCallApi.endDate = endTime;
    _channelCallApi.chiefDeptKeyId = departmentKeyId;
    _channelCallApi.chiefKeyId = personKeyId;
    _channelCallApi.publicAccountKeyId = @"";
    _channelCallApi.channelInquiryRange = range;
    _channelCallApi.pageIndex = curPageNum;
    _channelCallApi.pageSize = @"10";
    _channelCallApi.sortField = @"";
    _channelCallApi.ascending = @"true";
    [_manager sendRequest:_channelCallApi];
}


#pragma mark - 搜索框监听的回调方法
- (void)searchBarChangeInput:(NSNotification *)notificationObj
{
    UITextField *searchTextfield = (UITextField *)notificationObj.object;

    if(searchTextfield.tag == SearchTag)
    {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:searchTextfield.text];
        if (!isMatch)
        {
            if (_searchText.length == 0)
            {
                // 首次输入键盘上方
                searchTextfield.text = @"";

            }
            else
            {
                //输入之后
                searchTextfield.text = _searchText;
            }
            
            showMsg(@"只能输入数字！");
            return;
            
        }

        NSString *curPhone = searchTextfield.text;
        
        if ([curPhone isEqualToString:_searchKeyWord])
        {
            //防止点击确认后又发送一次同样的请求
            return;
        }
        
        if(curPhone.length > 11)
        {
            searchTextfield.text = _searchKeyWord;
            return;
        }
        
        _searchKeyWord = searchTextfield.text;
        if (!_searchKeyWord ||[_searchKeyWord isEqualToString:@""])
        {
            [self changeSearchBarRightBtnImageWithSearching:NO];
        }
        else
        {
            [self changeSearchBarRightBtnImageWithSearching:YES];
        }
    }
}



- (void)goFilterVC
{
    ChannelCallFilterViewController *channelCallFilterViewController = [[ChannelCallFilterViewController alloc]initWithNibName:@"ChannelCallFilterViewController"

                                                                                                                 bundle:nil];
    channelCallFilterViewController.isShowStaff = YES;
    
    NSDictionary *dic = [_channelFilterEntity dictionaryFromModel];
    if (_channelFilterEntity.startTime != nil || _channelFilterEntity.endTime != nil)
    {
        [dic setValue:_channelFilterEntity.startTime forKey:@"startTime"];
        [dic setValue:_channelFilterEntity.endTime forKey:@"endTime"];
    }
    channelCallFilterViewController.dataDic = dic;
    channelCallFilterViewController.delegate = self;
    
    [self.navigationController pushViewController:channelCallFilterViewController
                                         animated:YES];
}

- (void)clickVoiceSearch
{
    if ([_searchTextfield isFirstResponder]) {
        
        [_searchTextfield resignFirstResponder];
    }
    
    if(!iflyUtil)
    {
        iflyUtil = [IFlyUtil initWithDelegate:self];
    }
    [iflyUtil showAtPoint:self.view.center];
}

#pragma mark - ChannelCallViewProtocol
/// 转私客跳转
- (void)goTurnPrivateCustomer
{
    ChannelCallModelEntity *channelCall = _tableViewSource[_clickIndex];

   
        BJTurnPrivateCustomerVC *turnPrivateCustomerViewController = [[BJTurnPrivateCustomerVC alloc]initWithNibName:
                                                                      @"BJTurnPrivateCustomerVC" bundle:nil];
        turnPrivateCustomerViewController.channel = channelCall.mchannelInquirySources;
        turnPrivateCustomerViewController.channelKeyId = channelCall.mchannelSourceKeyId;
        turnPrivateCustomerViewController.phoneNumber = channelCall.mphone;
        turnPrivateCustomerViewController.keyId = channelCall.mkeyId;
        turnPrivateCustomerViewController.isMyPayChannelInquiry = channelCall.isMyPayChannelInquiry;

        turnPrivateCustomerViewController.delegate = self;
        [self.navigationController pushViewController:turnPrivateCustomerViewController
                                             animated:YES];

}

#pragma mark - IFlyUtilDelegate
- (void)ifFlyRecognizedResult:(NSString *)result
{
    if(![result isEqualToString:@""]){
        if (![NSString isPureInt:result])
        {
            return;
        }
    }
    
    if (_searchKeyWord) {
        _searchKeyWord = [_searchKeyWord stringByAppendingString:result];
    }
    else
    {
        _searchKeyWord = result;
    }
    _searchTextfield.text = _searchKeyWord;
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchTextfield isFirstResponder]) {
        
        [_searchTextfield resignFirstResponder];
    }
    
    _clickIndex = indexPath.section;
    [_mainTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * listArr = @[@"拨打电话",@"转私客",@"查看明细"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        ChannelCallModelEntity *channelCall = _tableViewSource[_clickIndex];
        
        switch (optionValue) {
            case 0:
            {
                [weakSelf callPhone:channelCall.mphone];
            }
                break;
            case 1:
            {
                // 转私客
                 [self goTurnPrivateCustomer];
            }
                break;
            case 2:
            {
                
                ChannelDetailViewController *channelDetailViewController = [[ChannelDetailViewController alloc]initWithNibName:@"ChannelDetailViewController" bundle:nil];
                channelDetailViewController.phoneNum = channelCall.mphone;
                channelDetailViewController.keyId = channelCall.mkeyId;
                [weakSelf.navigationController pushViewController:channelDetailViewController
                                                     animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }];

    
//    BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"取消"
//                                                             otherButtonTitles:
//                                        @"拨打电话",@"转私客",@"查看明细", nil];
//    byActionSheet.tag = ItemClickActionTag;
//
//    [byActionSheet show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"channelCallTableViewCell";
    
    ChnnelCallTableViewCell *channelCallTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!channelCallTableViewCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ChnnelCallTableViewCell"
                                              bundle:nil]
                              forCellReuseIdentifier:CellIdentifier];
        channelCallTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    NSInteger row = indexPath.section;
    ChannelCallModelEntity *channelCallEntity = _tableViewSource[row];
    PhoneAddressInfo *phoneInfo;
    if(_phoneAddress.count > row){
        phoneInfo = _phoneAddress[row];
    }
    
    channelCallTableViewCell.phoneAddressInfo = phoneInfo;
    channelCallTableViewCell.channelCallModelEntity = channelCallEntity;
    
    return channelCallTableViewCell;
}

//#pragma mark - ActionSheetDelegate
//- (void)actionSheetView:(BYActionSheetView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//    NSInteger tag = alertView.tag;
//    if(tag == ItemClickActionTag){
//
//        ChannelCallModelEntity *channelCall = _tableViewSource[_clickIndex];
//
//        switch (buttonIndex) {
//            case 0:
//            {
//                [self callPhone:channelCall.mphone];
//            }
//                break;
//            case 1:
//            {
//                // 转私客
//                [_channelCallPresenter toTurnPrivateCustomerVC];
//            }
//                break;
//            case 2:
//            {
//
//                ChannelDetailViewController *channelDetailViewController = [[ChannelDetailViewController alloc]initWithNibName:@"ChannelDetailViewController" bundle:nil];
//                channelDetailViewController.phoneNum = channelCall.mphone;
//                channelDetailViewController.keyId = channelCall.mkeyId;
//                [self.navigationController pushViewController:channelDetailViewController
//                                                     animated:YES];
//            }
//                break;
//
//            default:
//                break;
//        }
//
//    }
//}

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
        
    }
    else
    {
        [_rightSearchBtn removeTarget:self
                               action:@selector(clearSearchTextContent)
                     forControlEvents:UIControlEventTouchUpInside];
        [_rightSearchBtn addTarget:self
                            action:@selector(clickVoiceSearch)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_rightSearchBtn setImage:[UIImage imageNamed:RightBtnVoiceImageName]
                         forState:UIControlStateNormal];
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_searchTextfield isFirstResponder]) {
        [_searchTextfield resignFirstResponder];
    }

    [self headerRefreshMethod];
    
    return [self validateNumber:textField.text];
}

//限制只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:string];
    if (!isMatch)
    {
        showMsg(@"只能输入数字！")
    }
    else
    {
        [_searchText appendString:string];
    }
    
    return isMatch;
}

/**
 *  点击清除搜索内容按钮
 */
- (void)clearSearchTextContent
{
    _searchTextfield.text = @"";
    _searchKeyWord = @"";
    _searchText = [NSMutableString string];
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    
//    [_mainTableview headerBeginRefreshing];
      [_mainTableview.mj_header beginRefreshing];
}

#pragma mark - ChannelFilterDelegate
- (void)channelFilterResult:(ChannelFilterEntity *)result
{
    _channelFilterEntity = result;
    [self headerRefreshMethod];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - <QueryResultDelegate>
- (void)queryPhoneAddressResult:(NSArray *)result
{
    [self endRefreshWithTableView:_mainTableview];
    
    [_phoneAddress addObjectsFromArray:result];
    
    [_mainTableview reloadData];
    [self hiddenLoadingView];
}

#pragma mark － <TurnPrivateDelegate>
- (void)turnDone
{
    [self headerRefreshMethod];
}

#pragma mark －<BJTurnPrivateDelegate>
- (void)turnPrivateDoneInBeijing
{
    [self headerRefreshMethod];

}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self endRefreshWithTableView:_mainTableview];

    if([modelClass isEqual:[ChannelCallEntity class]])
    {
        ChannelCallEntity *channelCallEntity = [DataConvert convertDic:data toEntity:modelClass];

        NSString *phoneStrings = [QueryPhoneAddressUtil extractPhoneFromChannelCall:channelCallEntity];
        [_queryPhoneAddressUtil requestQueryPhoneAddressWithPhones:phoneStrings];

        [_tableViewSource addObjectsFromArray:channelCallEntity.mresult];

        if(channelCallEntity.mresult.count < 10){
//            _mainTableview.footerHidden = YES;
            _mainTableview.mj_footer.hidden = YES;
        }else{
//            _mainTableview.footerHidden = NO;
            _mainTableview.mj_footer.hidden = NO;
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
