//
//  MyClientViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyClientVC.h"
#import "CreatFilterButtonView.h"
#import "MoreFilterViewController.h"
#import "MyClientFilterVC.h"

#import "FilterEntity.h"
#import "MyClientTableViewCell.h"
#import "MyClientApi.h"


#import "AddEventView.h"

#define     SearchTag       100     // 搜索

@interface MyClientVC ()<ButtonClickDelegate,FilterViewDelegate,UITableViewDataSource,UITableViewDelegate,
AddCustomerDelegate,AddEventDelegate,CustomTextFieldDelegate, MyClientFilterDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet NSLayoutConstraint *_bottomLineHight;
    __weak IBOutlet UIView *_topView;
    
    MyClientApi *_myClientApi;
    
    CreatFilterButtonView *_customView;
    FilterEntity *_filterEntity;
    FilterView *_filterView;
    NSMutableArray *_tableViewSource;
    NSMutableArray *_dealPriceNameType;     // 交易价格类型名称数组
    NSMutableArray *_priceArray;            // 价格数组
    NSMutableArray *_clientStatusArray;     // 客户状态数组
    NSMutableArray *_dealTpyeArray;         // 交易类型数组
    NSInteger _btnTag;                      // 记录当前点击btn
    NSArray *_saleArray;
    NSArray *_rentArray;
    NSString *_clientDealTypeText;
    
    UITextField *_searchTextfield;
    UIButton *_selectBtn;
    CustomTextField *_searchTF;
    UIView *_shadowView;
    AddEventView *_selectView;
    AddEventView *_moreItemView;
    
    NSString *privateInquiryRange;
    
    NSString *_minRentPrice;
    NSString *_maxRentPrice;
    NSString *_minSalePrice;
    NSString *_maxSalePrice;
    NSString *_clientStatuValue;
    NSString *_clientDealTypeValue;
 
    
    RemindPersonDetailEntity *_searchPersonDetailEntity;
}
@end

@implementation MyClientVC

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    _mainTableView.backgroundColor = YCThemeColorBackground;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bottomLineHight.constant = 0.5;
    
    [self checkShowViewPermission:MENU_CUSTOMER_ALL_CUSTOMER andHavePermissionBlock:^(NSString *permission) {
        if([self getPrivateInquiryRange]){

            _minRentPrice = @"";
            _maxRentPrice = @"";
            _minSalePrice = @"";
            _maxSalePrice = @"";
            _searchPersonDetailEntity = nil;
            
            
            [self initData:@""];
            [self initArray];
            
            [self initNavTitleView];
            
            [self initOrderFilterView];
            [self creatFilterView];
            _mainTableView.tableFooterView = [[UIView alloc]init];
            _mainTableView.separatorStyle = NO;
            
            [self endRefreshWithTableView:_mainTableView];
            

            _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
            
            _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];

            [_mainTableView registerNib:[UINib nibWithNibName:@"MyClientTableViewCell" bundle:nil]
            forCellReuseIdentifier:@"myClientCell"];
            _mainTableView.tableFooterView = [[UIView alloc]init];
            _tableViewSource = [[NSMutableArray alloc]init];
            
            _filterEntity = [FilterEntity new];
            _filterEntity.clientStatuText = @"不限";
            _filterEntity.clientDealTypeText = @"不限";
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FirstTitle:) name:@"FirstTitle" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SecondTitle:) name:@"SecondTitle" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ThirdTitle:) name:@"ThirdTitle" object:nil];
            
        }
        else
        {
            showMsg(@"您没有访问权限")
        }
    }];
    
}

- (BOOL)getPrivateInquiryRange
{
    if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYSELF])
    {
        privateInquiryRange = @"4";
    }
    else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        privateInquiryRange = @"3";
    }
    else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_ALL])
    {
        privateInquiryRange = @"1";
    }
    else
    {
        // 无权限查看，退出当前视图
        return NO;
    }
    
    return YES;
}

- (void)FirstTitle:(NSNotification *)text
{
    UILabel *label = (UILabel *)[self.view viewWithTag:1000000];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:11];
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    
    if ([value isEqualToString:@"不限"]) {
        
        value = @"客户状态";
        
        label.textColor = YCTextColorBlack;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        
    }else{
        
        value = value;
        
        label.textColor = YCThemeColorGreen;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
        
    }
    
    label.text = value;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28)
                                      options: NSStringDrawingTruncatesLastVisibleLine
                                   attributes:attribute
                                      context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3) - ((APP_SCREEN_WIDTH / 3) / 2 - (size.width / 2)) + 6, label.center.y - 2, 8, 6);
}

- (void)SecondTitle:(NSNotification *)text
{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000001];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:12];
    
    if ([value isEqualToString:@"不限"]) {
        
        value = @"交易类型";
        
        label.textColor = YCTextColorBlack;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        
    }else{
        
        value = value;
        
        label.textColor = YCThemeColorGreen;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
        
    }
    
    label.text = value;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)-((APP_SCREEN_WIDTH/3)/2-(size.width/2))+6, label.center.y-2, 8, 6);

//    UILabel *secondLabel = (UILabel *)[self.view viewWithTag:1000002];
//    secondLabel.text = @"价格";
//    UIImageView *secondImageView = (UIImageView *)[self.view viewWithTag:13];
//    NSDictionary *secondAttribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
//    CGSize otherSize = [@"价格" boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:secondAttribute context:nil].size;
//    secondImageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)-((APP_SCREEN_WIDTH/3)/2-(otherSize.width/2))+6, label.center.y-2, 8, 6);
}

- (void)ThirdTitle:(NSNotification *)text
{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000002];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:13];
    
    if ([value isEqualToString:@"不限"]) {
        
        value = @"价格";
        
        label.textColor = YCTextColorBlack;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        
    }else{
        
        value = value;
        
        label.textColor = YCThemeColorGreen;
        
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
        
    }
    
    label.text = value;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)-((APP_SCREEN_WIDTH/3)/2-(size.width/2))+6, label.center.y-2, 8, 6);
}

- (void)initArray
{
    _clientStatusArray = [NSMutableArray arrayWithCapacity:0];
    _dealTpyeArray = [NSMutableArray arrayWithCapacity:0];
    SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
    entity.itemText = @"不限";
    entity.itemValue = @"";
    SysParamItemEntity *clientStatus = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_STATUS];
    [_clientStatusArray addObject:entity];
    [_clientStatusArray addObjectsFromArray:[self getInfomationWith:clientStatus.itemList]];

    SysParamItemEntity *clientDealtype = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TRADE_TYPE];
    [_dealTpyeArray addObject:entity];
    [_dealTpyeArray addObjectsFromArray:[self getInfomationWith:clientDealtype.itemList]];
    // 售价数组
    _saleArray = [NSArray arrayWithObjects:
                  @"150万以下",@"150-200万",
                  @"200-250万",@"250-350万",@"350-500万",
                  @"500-700万",@"700-1000万",@"1000万以上", nil];
    // 租价数组
    _rentArray = [NSArray arrayWithObjects:
                  @"2000元以下",@"2000-3000元",@"3000-5000元",
                  @"5000-8000元",@"8000-12000元",
                  @"12000元以上", nil];
    _dealPriceNameType = [NSMutableArray arrayWithObjects:@"不限",@"求租价格",@"求购价格", nil];
    _priceArray = [NSMutableArray arrayWithObjects:@[],_rentArray,_saleArray, nil];
}

- (NSMutableArray *)getInfomationWith:(NSArray *)array
{
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger count = array.count;
    for (NSInteger i = 0; i < count; i++)
    {
        SelectItemDtoEntity *entity = array[i];
        [infoArray addObject:entity];
    }
    
    return infoArray;
}

- (void)headerRefreshMethod
{
    [_tableViewSource removeAllObjects];
    
    if (_searchTF)
    {
        [self initData:_searchTF.text];
    }
    else
    {
        [self initData:_searchTextfield.text];
    }
}

- (void)footerRefreshMethod
{
    if (_searchTF)
    {
        [self initData:_searchTF.text];
    }
    else
    {
        [self initData:_searchTextfield.text];
    }
}

- (void)creatFilterView
{
    _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 0)];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
}

- (void)initOrderFilterView
{
    _customView =[[CreatFilterButtonView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 40)];
    [_customView creatButtonFirstLabel:@"客户状态" SecondLabel:@"交易类型" ThirdLabel:@"价格" ];
    _customView.delegate = self;
    [_topView addSubview:_customView];
}

#pragma mark - <MyClientViewProcotol>

- (void)initNavTitleView
{
    [self setNavTitle:@"我的客户"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    [self initRightButtonItem];
    // 中间
    // 创建顶部搜索框
    _searchTextfield = [self createTextfieldWithPlaceholder:@"请输入客户姓名" andHaveRightBtn:NO];
    _searchTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextfield.returnKeyType = UIReturnKeySearch;
    _searchTextfield.tag = SearchTag;
    _searchTextfield.delegate = self;
    
    [self createTopSearchBarViewWithTextField:_searchTextfield andRightBtn:nil];
}

- (void)initRightButtonItem
{
    // 右部添加客户按钮
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewtouchGesture:)];
    tapGesture.numberOfTapsRequired = 1;    // 点击次数
    tapGesture.numberOfTouchesRequired = 1; // 点击手指
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 33)];
    
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(11, 6, 18, 18)];
    rightImg.image = [UIImage imageNamed:@"加号2"];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, 40, 10)];
    rightLabel.font = [UIFont fontWithName:FontName
                                      size:10.0];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"添加客户";
    
    [view addSubview:rightImg];
    [view addSubview:rightLabel];
    [view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -15;
    
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacer,releaseButtonItem];
}

- (void)initShadowView
{
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
    _shadowView.hidden = YES;
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_shadowView addGestureRecognizer:tap];
    [self.view addSubview:_shadowView];
    
//    NSArray *titleArr =  @[@"客户姓名", @"电话号码", @"客源编号"];
    NSArray *titleArr = @[];

    CGFloat height = RowHeight * titleArr.count + ArrowHeight;
    _selectView = [[AddEventView alloc] initWithFrame:CGRectMake(45, 5, 70, height)];
    _selectView.backgroundColor = [UIColor clearColor];
    _selectView.layer.cornerRadius = 5;
    _selectView.layer.masksToBounds = YES;
    _selectView.titleArr = titleArr;
    _selectView.addEventDelegate = self;
    _selectView.hidden = YES;
    [self.view addSubview:_selectView];
    
   
    
    NSArray *moreTitleArr = @[];
    CGFloat moreHeight = RowHeight * moreTitleArr.count + ArrowHeight;
    CGFloat width = 70;
    _moreItemView = [[AddEventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - width - 10, 5, 70, moreHeight)];
    _moreItemView.backgroundColor = [UIColor clearColor];
    _moreItemView.layer.cornerRadius = 5;
    _moreItemView.layer.masksToBounds = YES;
    _moreItemView.titleArr = moreTitleArr;
    _moreItemView.addEventDelegate = self;
    _moreItemView.hidden = YES;
    [self.view addSubview:_moreItemView];
}

- (void)back
{
    if (self.isPopToRoot)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [_searchTextfield resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectAction:(UIButton *)btn
{
    _selectView.hidden = !_selectView.hidden;
    _shadowView.hidden = !_shadowView.hidden;
    _moreItemView.hidden = YES;
    
    btn.selected = !btn.selected;
}

#pragma mark - <AddEventDelegate>

- (void)addEventClickWithBtnTitle:(NSString *)title
{
    _searchTF.text = nil;
    
    if ([title contains:@"电话号码"])
    {
        // 手机号
        _searchTF.limitCondition = ONLY_NUMBER;
        _searchTF.limitLength = 30;
        [_selectBtn setTitle:@"电话号码" forState:UIControlStateNormal];
        _searchTF.placeholder = @"请输入电话号码进行搜索";
        _searchTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([title contains:@"客源编号"])
    {
        // 客源编号
        _searchTF.limitLength = 30;
        _searchTF.limitCondition = NUMBERANDLETTER;
        [_selectBtn setTitle:@"客源编号" forState:UIControlStateNormal];
        _searchTF.placeholder = @"请输入客源编号进行搜索";
        _searchTF.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if([title contains:@"客户姓名"])
    {
        // 客户名
        _searchTF.limitLength = 30;
        _searchTF.limitCondition = nil;
        [_selectBtn setTitle:@"客户姓名" forState:UIControlStateNormal];
        _searchTF.placeholder = @"请输入客户姓名进行搜索";
        _searchTF.keyboardType = UIKeyboardTypeDefault;
    }
    
    // 更多
    if ([title contains:@"新增客户"])
    {
        // 新增客户
        [self ViewtouchGesture:nil];
    }
    else if ([title contains:@"筛选"])
    {
        // 筛选
        MyClientFilterVC *myClientFilterVC = [[MyClientFilterVC alloc] initWithNibName:@"MyClientFilterVC" bundle:nil];
        myClientFilterVC.delegate = self;
        [self.navigationController pushViewController:myClientFilterVC animated:YES];
    }
    
    _selectView.hidden = YES;
    _shadowView.hidden = YES;
    _moreItemView.hidden = YES;
    _selectBtn.selected = NO;
    
    // 收起键盘
    [_searchTF endEditing:YES];
}

- (void)clickMoreItemMethod
{
    _shadowView.hidden = !_shadowView.hidden;
    _moreItemView.hidden = !_moreItemView.hidden;
    _selectBtn.selected = NO;
    _selectView.hidden = YES;
    // 收起键盘
    [_searchTF endEditing:YES];
}

#pragma mark - 背景视图点击手势

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 新增视图隐藏
    _shadowView.hidden = YES;
    _selectView.hidden = YES;
    _moreItemView.hidden = YES;
    _selectBtn.selected = NO;
}

#pragma mark - <CustomTextFieldDelegate>

- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField
{
    _selectView.hidden = YES;
    _shadowView.hidden = YES;
    _moreItemView.hidden = YES;
    _selectBtn.selected = NO;
    
    return YES;
}

- (void)customTextFieldShouldReturn:(UITextField *)textField
{
    [_searchTF resignFirstResponder];
    
    [_tableViewSource removeAllObjects];
    [self initData:textField.text];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == SearchTag)
    {
        [textField endEditing:YES];
        [_tableViewSource removeAllObjects];
        [_mainTableView reloadData];
        [self initData:textField.text];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_filterView.opened)
    {
        [_filterView ClicktapGesture];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectTextField" object:self userInfo:nil];
    return YES;
}


- (void)initData:(NSString *)keyWord
{
    [self showLoadingView:nil];
    
    NSString *curPageNum = @"1";
    if(_tableViewSource)
    {
        curPageNum = [NSString stringWithFormat:@"%@",@(_tableViewSource.count/10+1)];
    }
    
    NSArray *statusArr = @[];
    if(keyWord == nil)
    {
        keyWord = @"";
    }
    
    if(_clientStatuValue != nil && _clientStatuValue.length > 0)
    {
        statusArr = @[_clientStatuValue];
    }
    
    if(_clientDealTypeValue == nil)
    {
        _clientDealTypeValue = @"";
    }

//    NSString *contactType = [NSString isNilOrEmpty:keyWord]? @"":[_myClientPresenter getContentType:_selectBtn.titleLabel.text];
     NSString *contactType = @"";
    _myClientApi = [[MyClientApi alloc] init];
    _myClientApi.privateInquiryRange = privateInquiryRange;
    _myClientApi.inquiryStatusKeyIds = statusArr;
    _myClientApi.contactType = contactType;
    _myClientApi.contactContent = keyWord;
    _myClientApi.houseTypeKeyIds = @[];
    _myClientApi.inquiryTag = @"";
    _myClientApi.isExpire30Day = @"false";
    _myClientApi.inquiryTradeTypeKeyId = _clientDealTypeValue;
    _myClientApi.salePriceFrom = _minSalePrice;
    _myClientApi.salePriceTo = _maxSalePrice;
    _myClientApi.rentPriceFrom = _minRentPrice;
    _myClientApi.rentPriceTo = _maxRentPrice;
    _myClientApi.pageIndex = curPageNum;
    _myClientApi.pageSize = @"10";
    if (_searchPersonDetailEntity)
    {
        _myClientApi.chiefKeyId = _searchPersonDetailEntity.resultKeyId;
        _myClientApi.chiefDeptKeyId = _searchPersonDetailEntity.departmentKeyId;
    }
    
    _myClientApi.sortField = @"";
    _myClientApi.ascending = @"true";
    _myClientApi.searchKey = keyWord;
    [_manager sendRequest:_myClientApi];
}

- (void)ViewtouchGesture:(UITapGestureRecognizer *)gesture
{
    if(![AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_ADD_ALL])
    {
        showMsg(@(NotHavePermissionTip));
        return;
    }
    
    [_searchTextfield resignFirstResponder];
    
    AddCustomerViewController *addCustomer = [[AddCustomerViewController alloc]initWithNibName:@"AddCustomerViewController" bundle:nil];
    addCustomer.delegate = self;
    
    [self.navigationController pushViewController:addCustomer animated:YES];
}

#pragma mark - <AddCustomerDelegate>

- (void)backAddCustomerListViewController
{
    [self headerRefreshMethod];
}

#pragma mark - <MyClientFilterDelegate>

- (void)finishFilter:(RemindPersonDetailEntity *)personDetailEntity
{
    _searchPersonDetailEntity = personDetailEntity;
    [_tableViewSource removeAllObjects];
    [self initData:_searchTF.text];
}

#pragma mark - <FilterViewDelegate>
- (void)getButtonTag:(NSInteger)tag
{
    [_searchTextfield endEditing:YES];
    _filterView.opened = YES;
    
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT);
    [_filterView filterEntity:_filterEntity];
    switch (tag)
    {
        case 10:
            [_filterView creatTableViewWithFirstArray:_clientStatusArray
                                       AndSecondArray:nil
                                        AndThirdArray:nil
                                     AndTableViewType:1
                                            AndBtnTag:tag
                                         AndTitleType:@"ClientStatus"];
            break;
        case 11:	
            [_filterView creatTableViewWithFirstArray:_dealTpyeArray
                                       AndSecondArray:nil
                                        AndThirdArray:nil
                                     AndTableViewType:1
                                            AndBtnTag:tag
                                         AndTitleType:@"ClientDealType"];
            break;
        case 12:
        {
            [_priceArray removeAllObjects];
            [_priceArray addObject:@[]];
            [_priceArray addObject:_rentArray];
            [_priceArray addObject:_saleArray];
            
            [_dealPriceNameType removeAllObjects];
            [_dealPriceNameType addObject:@"不限"];
            [_dealPriceNameType addObject:@"求租价格"];
            [_dealPriceNameType addObject:@"求购价格"];
            
            if ([_clientDealTypeText isEqualToString:@"求购"])
            {
                [_priceArray removeObject:_rentArray];
                [_dealPriceNameType removeObject:@"求租价格"];
            }
            if ([_clientDealTypeText isEqualToString:@"求租"])
            {
                [_priceArray removeObject:_saleArray];
                [_dealPriceNameType removeObject:@"求购价格"];
            }
            
            [_filterView creatTableViewWithFirstArray:_dealPriceNameType
                                       AndSecondArray:_priceArray
                                        AndThirdArray:nil
                                     AndTableViewType:2
                                            AndBtnTag:tag
                                         AndTitleType:@"ClientPriceType"];
        }
            break;
        default:
            break;
    }
    
    if (_btnTag == tag)
    {
        [self revertAnimation];
        
    }
    else
    {
        _btnTag = tag;
    }
}

- (void)requestNeedEntity:(FilterEntity *)entity andType:(BOOL)type{
    
    if(type)
    {
        _minRentPrice = entity.minRentPrice;
        _maxRentPrice = entity.maxRentPrice;
        
        _minSalePrice = entity.minSalePrice;
        _maxSalePrice = entity.maxSalePrice;
        
        _clientStatuValue = entity.clientStatuValue;
        _clientDealTypeValue = entity.clientDealTypeValue;
        
        // 客户交易类型
        _clientDealTypeText = entity.clientDealTypeText;
        
        if(_minRentPrice == nil)
        {
            _minRentPrice = @"";
        }
        if(_maxRentPrice == nil)
        {
            _maxRentPrice = @"";
        }
        
        if(_minSalePrice == nil)
        {
            _minSalePrice = @"";
        }
        if(_maxSalePrice == nil)
        {
            _maxSalePrice = @"";
        }
        
        if(_clientStatuValue == nil)
        {
            _clientStatuValue = @"";
        }
        if(_clientDealTypeValue == nil)
        {
            _clientDealTypeValue = @"";
        }
        
        [_tableViewSource removeAllObjects];
        [_mainTableView reloadData];
        [self initData:@""];
    }
    
     [self revertAnimation];
}

/// 还原动画
- (void)revertAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    _btnTag = 0;
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 102;
//    NSInteger rowIndex = indexPath.row;
//    if(rowIndex >= _tableViewSource.count)
//    {
//        return 44*NewRatio;
//    }
//
//    CustomerEntity *customer = (CustomerEntity *)_tableViewSource[indexPath.row];
//    NSString *roomType = customer.roomType ? customer.roomType:@"";
//    NSString *decorationSituation = customer.decorationSituation ? customer.decorationSituation:@"";
//    NSString *houseType = customer.houseType ? customer.houseType:@"";
//    NSString *houseDirection = customer.houseDirection ? customer.houseDirection:@"";
//    NSString *marea = customer.area ? customer.area:@"";
//    NSString *dataString = @"";
//    if([customer.area isEqualToString:@""])
//    {
//        dataString = [NSString stringWithFormat:@"%@%@%@%@",
//                                     roomType,
//                                     decorationSituation,
//                                     houseType,
//                                     houseDirection];
//    }
//    else
//    {
//        dataString = [NSString stringWithFormat:@"%@%@%@%@/%@㎡",
//                                     roomType,
//                                     decorationSituation,
//                                     houseType,
//                                     houseDirection,
//                                     marea];
//    }
//
//    CGFloat height = [dataString getStringHeight:[UIFont fontWithName:FontName size:12.0] width:200 size:12.0];
//
//    return height + 44*NewRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyClientTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myClientCell" forIndexPath:indexPath];
    cell.customerEntity = _tableViewSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTextfield resignFirstResponder];
    CustomerEntity *customer = _tableViewSource[indexPath.row];
    
    CustomerInfoViewController *customerInfoVC = [[CustomerInfoViewController alloc] init];
    customerInfoVC.customerEntity = customer;
    [self.navigationController pushViewController:customerInfoVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0)
    {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0)
        {
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 12;
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 隐藏键盘
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self endRefreshWithTableView:_mainTableView];
    if ([modelClass isEqual:[CustomerListEntity class]])
    {
        CustomerListEntity *customerListEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_tableViewSource addObjectsFromArray:customerListEntity.inquirys];
        
        _mainTableView.mj_footer.hidden = customerListEntity.recordCount == _tableViewSource.count;
        
    }

    [_mainTableView reloadData];
    [self hiddenLoadingView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
