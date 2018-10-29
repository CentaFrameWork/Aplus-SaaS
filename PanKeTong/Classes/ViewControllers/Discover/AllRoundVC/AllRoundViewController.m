//
//  AllRoundViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundViewController.h"
#import "AllRoundListCell.h"
#import "AllRoundDetailViewController.h"
#import "CreatFilterButtonView.h"
#import "PropListEntity.h"
#import "PhotoDownLoadImageViewController.h"
#import "UploadRealSurveyViewController.h"
#import "FilterListViewController.h"
#import "AllRoundFilterCustomView.h"
#import "AgencySysParamUtil.h"
#import "AgencyUserPermisstionUtil.h"
#import "SysParamItemEntity.h"
#import "SelectItemDtoEntity.h"
#import "SearchViewController.h"
#import "FilterEntity.h"
#import "AgencyPermissionsDefine.h"
#import "MoreFilterViewController.h"
#import "DataBaseOperation.h"
#import "SelectItemDtoEntity.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AgencyUserPermisstionUtil.h"
#import "RecentBrowseUtils.h"
#import "CheckRealProtectedEntity.h"
#import "LogOffUtil.h"
#import "CheckRealProtectedDurationApi.h"
#import "GetPropListApi.h"
#import "SystemParamTypeEnum.h"
#import "PropertyStatusCategoryEnum.h"
#import "HQAllRoundDetailVC.h"
#import "PropPageDetailEntity.h"
#import "TrustTypeEnum.h"
#import "AllRoundListBJPresenter.h"
#import "AllRoundListNJPresenter.h"
#import "AllRoundListTJPresenter.h"
#import "AllRoundListSZPresenter.h"
#import "AllRoundListCQPresenter.h"
#import "AllRoundListGZPresenter.h"
#import "AllRoundListAMPresenter.h"
#import "AllRoundListCSPresenter.h"
#import "AllRoundListHZPresenter.h"

#define PropHeadImageBtnTag             10000
#define RightBtnVoiceImageName          @"voiceSearch_icon"
#define RightDelSearchImageName         @"close_btn"
#define TRUE_String                     @"true"
#define FALSE_String                    @"false"
#define RentPrice                       @"RentPrice"   //租价
#define SalePrice                       @"SalePrice" //售价

@interface AllRoundViewController ()<UITableViewDataSource,UITableViewDelegate,ButtonClickDelegate,FilterViewDelegate,FilterListDelegate,MoreFilterInfoDelegate,AllRoundFilterCustomViewDelegate,SearchResultDelegate,UITextFieldDelegate,EditRefreshDelegate,BYActionSheetViewDelegate,AllRoundListViewProtocol>
{
    __weak IBOutlet UIButton *_sortButton;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIView *_topView;
    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet NSLayoutConstraint *_topViewBottomLabelHeight;
    __weak IBOutlet UILabel *_bottomFilterLabel;
    __weak IBOutlet NSLayoutConstraint *propTableViewButtomHeight;
    
    CreatFilterButtonView *_filterCustomView;
    FilterView *_filterView;
    AllRoundFilterCustomView *_customView;
    FilterEntity *_filterEntity;
    DataBaseOperation *_dataBaseOperation;
    BYActionSheetView *_addNewActionSheet;
    AllRoundListBasePresenter *_allRoundListPresenter;
    GetPropListApi *_propListApi;
    CheckRealProtectedDurationApi *_checkRealProtectedApi;
    
    NSMutableArray *_propListArray;
    NSMutableArray *_dealPriceNameType;       //交易价格类型名称数组
    NSMutableArray *_priceArray;              //价格数组
    NSMutableArray *_allInfoArray;
    NSArray *_dealTypeArray;           //交易类型数组
    NSArray *_tagTextArray;            //标签数组
    NSArray *_saleArray;
    NSArray *_rentArray;
    NSArray *_SavefilterArray;          //保存筛选条件的数组
    UIWindow * _mainWindow;
    UITextField *_searchTextfield;          //顶部搜索textfield
    UIButton *_rightSearchBtn;              // 搜索框右部按钮
    NSString *_currentSelectString;         // 默认选中的名字
    NSString *_currentShowText;             // 第一次筛选信息
    NSString *_currentSort;                 // 当前排序
    NSString *_clickImageHouseID;//点击当前实堪image的index
    NSInteger _selectIndex;     // 当前选中cell
    NSInteger _btnTag;//记录当前点击btn
    
    BOOL _isSearching;  //是否正在搜索状态
    BOOL _isSetttingName;  //是否更改名字
    BOOL _isSendService;
    BOOL _isTouchUnloadImg;//是否点击了上传实勘
}

@end

@implementation AllRoundViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectRow = -1;
    
    [self checkPermission:^(NSString *permission) {
        
        [self initPresenter];
        [self initView];
        [self initArray];
        [self initData];
        if (self.isPropList)
        {
            // 从数据库中获取已有的筛选数据
            _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
            for (NSInteger i = 0; i <_allInfoArray.count; i++) {
                
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                      fromJSONDictionary: [entity.entity jsonDictionaryFromJsonString]
                                                                   error:nil];
                if (filterEntity.isCurrent)
                {
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                    
                    _filterEntity = filterEntity;
                    _currentShowText = entity.showText;
                    if([_propType isEqualToString:WARZONE]){
                        // 从首页进入
                        // 搜索条件
                        NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
                        _searchTextfield.text = seachName ? seachName : @"输入城区、片区、楼盘名";
                    }
                }
            }
        }
        [self initOrderFilterView];
        [self creatFilterView];
        [self headerRefreshMethod];
        
        // 筛选View第一个title
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstTitle:) name:@"FirstTitle" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondTitle:) name:@"SecondTitle" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdTitle:) name:@"ThirdTitle" object:nil];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isPropList)
    {
        _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
        // 判断是否清空筛选数据
        if (_allInfoArray.count == 0)
        {
            _bottomFilterLabel.text = @"暂无默认搜索";
        }
        // 如果默认更改了名字 就走此方法
        if (_isSendService)
        {
            for (NSInteger i = 0; i <_allInfoArray.count; i++) {
                
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                       fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                    error:nil];
                if (filterEntity.isCurrent)
                {
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                    _filterEntity = filterEntity;
                    _currentShowText = entity.showText;
                }
            }
        }
        
        if (_isSetttingName) {
            for (NSInteger i = 0; i < _allInfoArray.count; i++) {
                
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                       fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                    error:nil];
                if ([filterEntity isEqual: _filterEntity])
                {
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                }
            }
        }
    }
    
    if ([_propType isEqualToString:WARZONE])
    {
        [_mainTableView reloadData];
    }
    
    // 底部
    NSString *nameString = [CommonMethod getUserdefaultWithKey:NameString];
    if (nameString) {
        _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",nameString];
    }else{
        _bottomFilterLabel.text = @"暂无默认搜索";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isTouchUnloadImg = NO;
    
    [self endRefreshWithTableView:_mainTableView];
    
}

#pragma mark - init

- (void)initOrderFilterView
{
    _filterCustomView  = [[CreatFilterButtonView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 40)];
    if (self.isPropList)
    {
        // 交易类型
        NSString * priceType = _filterEntity.estDealTypeText?_filterEntity.estDealTypeText:@"全部";
        // 标签
        NSString * tagText = _filterEntity.tagText?_filterEntity.tagText:@"不限";
        // 价格
        NSString * priceText;
        if (_filterEntity.salePriceText && ![_filterEntity.salePriceText isEqualToString:@""]) {
            priceText = _filterEntity.salePriceText;
        }
        else if (_filterEntity.rentPriceText && ![_filterEntity.rentPriceText isEqualToString:@""])
        {
            priceText = _filterEntity.rentPriceText;
        }
        else
        {
            priceText = @"价格";
        }
        [_filterCustomView creatButtonFirstLabel:priceType SecondLabel:priceText ThirdLabel:tagText];
    }
    else
    {
        [_filterCustomView creatButtonFirstLabel:@"全部" SecondLabel:@"价格" ThirdLabel:@"不限"];
    }
    _filterCustomView.delegate = self;
    [_topView addSubview:_filterCustomView];
}

- (void)initArray
{
    SysParamItemEntity * exchangeType =  [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_TYPE];
    SelectItemDtoEntity * allEntity = [SelectItemDtoEntity new];
    allEntity.itemText = @"全部";
    NSMutableString * string = [[NSMutableString alloc]init];
    NSMutableArray * nameArray = [NSMutableArray arrayWithCapacity:0];
    
    // 房源列表页的交易类型筛选项根据权限显示不同的筛选项
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_ALLTREDE_SEARCH])
    {
        [nameArray addObjectsFromArray:exchangeType.itemList];
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_RENT_SEARCH_ALL])
    {
        [nameArray addObjectsFromArray:exchangeType.itemList];
        [nameArray removeObjectAtIndex:1];
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_SALE_SEARCH_ALL])
    {
        [nameArray addObjectsFromArray:exchangeType.itemList];
        [nameArray removeObjectAtIndex:0];
    }
    
    
    for (int i = 0; i<nameArray.count; i++)
    {
        SelectItemDtoEntity * entity = nameArray[i];
        [string appendString:entity.itemText];
    }
    if ([string isEqualToString:@"出租出售租售"])
    {
        allEntity.itemValue = @"";
    }
    else if ([string isEqualToString:@"出租租售"])
    {
        allEntity.itemValue = @"4";
    }
    else if ([string isEqualToString:@"出售租售"])
    {
        allEntity.itemValue = @"5";
    }
    
    [nameArray insertObject:allEntity atIndex:0];
    _dealTypeArray = [NSArray arrayWithArray:nameArray];
    _tagTextArray = [_allRoundListPresenter getTagTextArray];
    
    // 售价数组
    _saleArray = [NSArray arrayWithObjects:
                         @"100万以下",@"100-150万",
                         @"150-200万",@"200-250万",
                         @"250-300万",@"300-350万",
                         @"350-400万",@"400-450万",
                         @"450-500万",@"500万以上", nil];
    // 租价数组
    _rentArray = [NSArray arrayWithObjects:
                         @"500元以下",@"500-1000元",
                         @"1000-1500元",@"1500-2000元",
                         @"2000-2500元",@"2500-3000元",
                         @"3000-3500元",@"3500-4000元",
                         @"4000元以上", nil];
    _dealPriceNameType = [NSMutableArray arrayWithObjects:@"出租价格(元)",@"出售价格(万元)",@"不限", nil];
    _priceArray = [NSMutableArray arrayWithObjects:_rentArray,_saleArray,@[], nil];
}

- (void)initView
{
    _topViewBottomLabelHeight.constant = 0.5;
    
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
    _searchTextfield = [self createTextfieldWithPlaceholder:@"输入城区、片区、楼盘名"
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
    
    [_mainTableView addHeaderWithTarget:self
                                 action:@selector(headerRefreshMethod)];
    [_mainTableView addFooterWithTarget:self
                                 action:@selector(footerRefreshMethod)];
    
    _mainTableView.tableFooterView = [UIView new];
    
    if (_isPropList)
    {
        _bottomView.hidden = NO;
        propTableViewButtomHeight.constant = 42;
    }
    else
    {
        _bottomView.hidden = YES;
        propTableViewButtomHeight.constant = 0;
    }
    
    // 判断是否从搜索页进入到房源列表
    _isSearching = _isFromSearchPage;
    // 判断是否有搜索条件
    NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
    if (seachName) {
        [self changeSearchBarRightBtnImageWithSearching:NO];
    }else{
        [self changeSearchBarRightBtnImageWithSearching:NO];
    }
    
    // 排序按钮
    [_sortButton addTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside];
    // 是否显示排序按钮
    _sortButton.hidden = YES;
    
    /// 是否含有排序按钮
    if ([_allRoundListPresenter haveSortButton])
    {
        if (![_propType isEqualToString:CONTRIBUTION])
        {
            // 通盘房源列表显示   (房源贡献、我的收藏都不显示)
             _sortButton.hidden = NO;
        }
    }
}

- (void)initPresenter
{
    if ([CityCodeVersion isNanJing]) {
        _allRoundListPresenter = [[AllRoundListNJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isBeiJing]){
        _allRoundListPresenter = [[AllRoundListBJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isTianJin]){
        _allRoundListPresenter = [[AllRoundListTJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChongQing]){
        _allRoundListPresenter = [[AllRoundListCQPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isShenZhen]){
        _allRoundListPresenter = [[AllRoundListSZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isGuangZhou]){
        _allRoundListPresenter = [[AllRoundListGZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isAoMenHengQin]){
        _allRoundListPresenter = [[AllRoundListAMPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChangSha]){
        _allRoundListPresenter = [[AllRoundListCSPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isHangZhou]){
        _allRoundListPresenter = [[AllRoundListHZPresenter alloc] initWithDelegate:self];
    }else{
        _allRoundListPresenter = [[AllRoundListBasePresenter alloc] initWithDelegate:self];
    }
}

- (void)initData
{
    //房源状态更改
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTradingState:) name:ChangeTradingState object:nil];
    
    _propListApi = [GetPropListApi new];
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    
    _filterEntity = [FilterEntity new];
    _filterEntity.estDealTypeText = @"全部";
    _filterEntity.tagText = @"不限";
    _filterEntity.isRecommend = @"false";
    _filterEntity.isNewProInThreeDay = @"false";
    _filterEntity.isOnlyTrust = @"false";
    _filterEntity.hasPropertyKey = @"false";
    _filterEntity.roomType = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.roomStatus = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.direction = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.propTag = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.buildingType = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.sortField = @"";
    _filterEntity.ascending = TRUE_String;
    
    /// 是否含有委托已审
    if ([_allRoundListPresenter haveTrustsApproved])
    {
        _filterEntity.isTrustsApproved = @"false";
    }

    /// 是否含有证件齐全
    if ([_allRoundListPresenter haveCompleteDoc])
    {
        _filterEntity.isCompleteDoc = @"false";
    }

    ///是否含有委托房源
    if ([_allRoundListPresenter haveTrustProperty]) {
        _filterEntity.isTrustProperty = @"false";
    }

    _currentSort = @"恢复默认排序";
    
    /// 是否可以搜索房号
    if ([_allRoundListPresenter canSearchHouseNo]) {
        _filterEntity.houseNo = _houseNo;
    }
    
    _propListArray = [NSMutableArray array];
    
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    if (_isHomePageSearch){
        // 从首页右上角进入
        _filterEntity.estateSelectType = _estateSelectType;
        return;
    }
    
    NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
    _searchKeyWord = seachName ? seachName : @"";
    
    if ([_propType isEqualToString:CONTRIBUTION]) {
        // 房源贡献
        _searchKeyWord = @"";
    }
}

#pragma mark -  Custom method

- (void)logout
{
    // 用户退出登录后清除用户信息
    [LogOffUtil clearUserInfoFromLocal];
    
    [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
}

- (void)checkPermission:(HaveMenuPermissionBlock)block
{
    BOOL permission = NO;
    if(self.isPropList){
        permission = [self checkShowViewPermission:MENU_PROPERTY_WAR_ZONE andHavePermissionBlock:block];
    }else{
        permission = [self checkShowViewPermission:MENU_PROPERTY_MY_SHARING andHavePermissionBlock:block];
    }
}

- (void)firstTitle:(NSNotification *)text{
    
    UILabel *label = (UILabel *)[self.view viewWithTag:1000000];
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    label.text = value;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:11];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (size.width/2))+3, label.center.y-2, 8, 6);
    
    UILabel *secondLabel = (UILabel *)[self.view viewWithTag:1000001];
    secondLabel.text = @"价格";
    UIImageView *secondImageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *secondAttribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize otherSize = [@"价格" boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:secondAttribute context:nil].size;
    secondImageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (otherSize.width/2))+3, label.center.y-2, 8, 6);
    
    _filterEntity.sortField = @"";
    _filterEntity.ascending = FALSE_String;
}

- (void)secondTitle:(NSNotification *)text
{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000001];
    label.text = value;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:12];
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (size.width/2))+3, label.center.y-2, 8, 6);
}

- (void)thirdTitle:(NSNotification *)text
{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000002];
    label.text = value;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:13];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3)- ((APP_SCREEN_WIDTH / 3) / 2- (size.width/2)) + 3, label.center.y - 2, 8, 6);
}

- (void)creatFilterView
{
    _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 0)];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
}

- (void)sortAction
{
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"]||[_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
        {
            _filterEntity.sortField = SalePrice;
            _currentSort = @"恢复默认排序";
            
            if ([_filterEntity.ascending isEqualToString:TRUE_String])
            {
                // 售价从大到小
                _filterEntity.ascending = FALSE_String;
            }
            else
            {
                // 售价从小到大
                _filterEntity.ascending = TRUE_String;
            }
        }
        
        if ([_filterEntity.estDealTypeText isEqualToString:@"出租"])
        {
            _filterEntity.sortField = RentPrice;
            
            if ([_filterEntity.ascending isEqualToString:TRUE_String])
            {
                // 租价从大到小
                _filterEntity.ascending = FALSE_String;
            }
            else
            {
                // 租价从小到大
                _filterEntity.ascending = TRUE_String;
            }
        }

        [self headerRefreshMethod];
        return;
    }
    
    // 排序弹框
    BYActionSheetView *addNewActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"售价从大到小",@"售价从小到大",@"租价从大到小",@"租价从小到大",@"恢复默认排序", nil];
    [addNewActionSheet initialValue:_currentSort];
    [addNewActionSheet show];
}

/// 切换搜索框右部按钮状态和触发事件（搜索、未搜索）
- (void)changeSearchBarRightBtnImageWithSearching:(BOOL)isSearchIng
{
    _searchTextfield.text = _searchKeyWord;
    
    if (isSearchIng)
    {
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
    
    _isSearching = !isSearchIng;
}

#pragma mark - TextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController"
                                                                           bundle:nil];
    searchVC.searchType = TopTextSearchType;
    searchVC.isFromMainPage = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
    
    return NO;
}

#pragma mark - <EditRefreshDelegate>
- (void)editRefresh:(PropPageDetailEntity *)entity
{
    // 是否含有编辑房源功能
    if ([_allRoundListPresenter haveEditFunction])
    {
        if (!(_selectRow < 0)) {
            PropertysModelEntty *oldEntity = [_propListArray objectAtIndex:_selectRow];
            oldEntity.square = entity.squareEdit;
            oldEntity.salePrice = entity.salePrice;
            oldEntity.rentPrice = entity.rentPrice;
            oldEntity.houseDirection = entity.houseDirection;
            [_mainTableView reloadData];
        }
    }
}

#pragma mark - buttonClickAction
/// 进入筛选页
- (void)goFilterVC
{
    // 删除自定义filterview的tag记录
    _btnTag = 0;
    MoreFilterViewController *moreFilterVC = [[MoreFilterViewController alloc]initWithNibName:@"MoreFilterViewController"   bundle:nil];
    
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:_filterEntity];
    moreFilterVC.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    moreFilterVC.delegate = self;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectFilterButton" object:self userInfo:nil];
    
    [self.navigationController pushViewController:moreFilterVC
                                         animated:YES];
}

/// 语音搜索
- (void)clickVoiceSearch
{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController"
                                                                           bundle:nil];
    searchVC.searchType = TopVoidSearchType;
    searchVC.isFromMainPage = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
}

/// 点击清除搜索内容按钮
- (void)clearSearchTextContent
{
    _searchTextfield.text = @"";
    _searchKeyWord = @"";
    _filterEntity.houseNo = @"";
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    [self headerRefreshMethod];
}

/// 保存搜索条件
- (IBAction)saveSearchBtnClick:(UIButton *)sender
{
    _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
    if (_allInfoArray.count>= 10)
    {
        [CustomAlertMessage showAlertMessage:@"最多可保存10条搜索条件记录,当前已达到上限!\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
        return;
    }
    _mainWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"AllRoundFilterCustomView" owner:nil options:nil];
    _customView = [array firstObject];
    _customView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    _customView.delegate = self;
    _customView.searchName = _searchKeyWord;
    [_customView creatView];
    [_mainWindow makeKeyAndVisible];
    [_mainWindow addSubview:_customView];
    //展示具体筛选数据
    _SavefilterArray = [[self getFilterConditionString] componentsSeparatedByString:@","];
    [_customView getTableViewArray:_SavefilterArray];
}

//进入筛选条件列表
- (IBAction)pushSearchList:(UIButton *)sender
{
    FilterListViewController *filterList = [[FilterListViewController alloc]initWithNibName:@"FilterListViewController"    bundle:nil];
    filterList.delegate = self;
    filterList.currentSelectName = _currentSelectString;
    [self.navigationController pushViewController:filterList animated:YES];
}


- (void)clickHeadImageMethod:(UIButton *)button
{
    NSInteger selectPropItemIndex = button.tag - PropHeadImageBtnTag;
    
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:selectPropItemIndex];
    
    NSString *realPhotoPath = [NSString stringWithFormat:@"%@",propModelEntity.photoPath];
    NSString *realSurveyCount = [NSString stringWithFormat:@"%@",propModelEntity.realSurveyCount];
    
    if (realPhotoPath &&
        ![realPhotoPath isEqualToString:@""] &&
        realSurveyCount.integerValue !=  0)
    {
        BOOL isAble = [_allRoundListPresenter canViewUploadrealSurvey:propModelEntity.departmentPermissions];
        
        if (isAble)
        {
            PhotoDownLoadImageViewController *photoDownImageVC = [[PhotoDownLoadImageViewController alloc]initWithNibName:@"PhotoDownLoadImageViewController" bundle:nil];
            photoDownImageVC.propKeyId = propModelEntity.keyId;
            photoDownImageVC.isItem = NO;
            [self.navigationController pushViewController:photoDownImageVC
                                                 animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }
    else
    {
        //上传实勘
        if (_isTouchUnloadImg) {
            return;
        }
        _isTouchUnloadImg = YES;
        BOOL isAble = [_allRoundListPresenter canAddUploadrealSurvey:propModelEntity.departmentPermissions];
        
        if(isAble)
        {
            // 是否需要验证实勘保护期
            if ([_allRoundListPresenter isCheckRealProtected])
            {
                // 是否需要检查房源状态
                if ([_allRoundListPresenter isCheckPropertyStatus])
                {
                    if ([propModelEntity.propertyStatusCategory integerValue] != VALID) {
                        showMsg(@"非有效房源无法上传实勘!");
                        return;
                    }
                }
                //验证实勘保护期
                _checkRealProtectedApi.keyId = propModelEntity.keyId;
                [_manager sendRequest:_checkRealProtectedApi];
                
                _clickImageHouseID = propModelEntity.keyId;
            }
            else
            {
                UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController" bundle:nil];
                uploadRealSurveyVC.propKeyId = propModelEntity.keyId;
                
                [self.navigationController pushViewController:uploadRealSurveyVC
                                                     animated:YES];
            }
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
        
    }
}

#pragma mark - MoreFilterInfoDelegate
- (void)moreFilterBack
{
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH, 0);
}

- (void)getFilterEntity:(FilterEntity *)entity
{
    _isSendService = NO;
    _filterEntity = entity;
    _SavefilterArray = [[self getFilterConditionString] componentsSeparatedByString:@","];
    [self headerRefreshMethod];
    
    NSString * price;
    NSString * minString;
    NSString * maxString;
    NSString * typeString;
    if ([NSString isNilOrEmpty:_filterEntity.moreFilterMinSalePrice]&&[NSString isNilOrEmpty:_filterEntity.moreFilterMaxSalePrice])
    {
        minString = _filterEntity.minRentPrice;
        maxString = _filterEntity.maxRentPrice;
        typeString = @"出租";
    }
    else
    {
        minString = _filterEntity.minSalePrice;
        maxString = _filterEntity.maxSalePrice;
        typeString = @"出售";
    }
    
    price = [self getStringWith:minString and:maxString andType:typeString];
    
    if (!price || [price isEqualToString:@""])
    {
        if (_filterEntity.minSalePrice && _filterEntity.maxSalePrice && ![_filterEntity.minSalePrice isEqualToString:@""]&& ![_filterEntity.maxSalePrice isEqualToString:@""])
        {
            price = [NSString stringWithFormat:@"%@-%@万元",_filterEntity.minSalePrice,_filterEntity.maxSalePrice];
        }
        else if (_filterEntity.minRentPrice && _filterEntity.maxRentPrice && ![_filterEntity.minRentPrice isEqualToString:@""]&& ![_filterEntity.maxRentPrice isEqualToString:@""])
        {
            price = [NSString stringWithFormat:@"%@-%@元",_filterEntity.minRentPrice,_filterEntity.maxRentPrice];
        }
        else
        {
            price = @"价格";
        }
    }
    // 通过tag值找到具体的控件 改变显示内容
    UILabel * label = (UILabel *)[self.view viewWithTag:1000001];
    label.text = price;
    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [price boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    if (size.width/2>APP_SCREEN_WIDTH/6)
    {
        size.width = APP_SCREEN_WIDTH/3-4;
    }
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (size.width/2))+3, label.center.y-2, 8, 6);
}

/// 判断字符串转为int类型的时候是否为0
- (NSString * )opinionStringFromString:(NSString *)string
{
    if ([[string stringByReplacingOccurrencesOfString:@"0" withString:@""] isEqualToString:@""]&&![string isEqualToString:@""])
    {
        return @"0";
    }
    while ([string hasPrefix:@"0"])
        
    {
        if ([string isEqualToString:@"0"])
        {
            return string;
        }
        string = [string substringFromIndex:1];
    }
    return string;
}

- (void)changeTradingState:(NSNotification *)noti
{
    NSString *tradingState = noti.object;
    
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:_selectIndex];
    propModelEntity.trustType = tradingState;
    
    [_propListArray replaceObjectAtIndex:_selectIndex withObject:propModelEntity];
}

#pragma mark - SearchResultDelegate
- (void)searchResultWithKeyword:(NSString *)keyword andExtendAttr:(NSString *)extendAttr andItemValue:(NSString *)itemvalue andHouseNum:(NSString *)houseNum
{
    // 是否可以搜索房号
    if ([_allRoundListPresenter canSearchHouseNo])
    {
        _filterEntity.houseNo = houseNum;
    }
    
    _filterEntity.estateSelectType = extendAttr;
    if (keyword.length <=  0)
    {
        _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    }
    
    if (![NSString isNilOrEmpty:houseNum]) {
        _searchKeyWord = [NSString stringWithFormat:@"%@，%@",keyword,houseNum];
    }
    else
    {
        _searchKeyWord = keyword;
    }
    
    [self changeSearchBarRightBtnImageWithSearching:YES];
    [self headerRefreshMethod];
}

#pragma mark - Network Request

- (void)headerRefreshMethod
{
    [self checkPermission:nil];
    [self showLoadingView:nil];
    
    [_propListArray removeAllObjects];
    [_mainTableView reloadData];
    
    NSString * trustType;
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
    {
        trustType = [NSString stringWithFormat:@"%d",SALEBOTH];
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        trustType = [NSString stringWithFormat:@"%d",RENTBOTH];
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"租售"])
    {
        trustType = [NSString stringWithFormat:@"%d",BOTH];
    }
    else
    {
        trustType = [self priceType];
    }
    
    NSString * propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    
    _realSearchKeyWord = _searchKeyWord;
    
    if ([_realSearchKeyWord contains:@"，"])
    {
        NSRange range;
        range = [_realSearchKeyWord rangeOfString:@"，"];
        
        if (range.location != NSNotFound) {
         
            _realSearchKeyWord = [_realSearchKeyWord substringToIndex:range.location];
            NSLog(@"keyWord = %@",_realSearchKeyWord);
        }
        else
        {
            // Do Nothing
        }
    }
    
    _propListApi.propListTyp = self.propType;
    _propListApi.propertyTypes = [self getfilterConditionWith:_filterEntity.roomType];
    _propListApi.popStatus = [self getfilterConditionWith:_filterEntity.roomStatus];
    _propListApi.propSituationValue = _filterEntity.propSituationValue;
    _propListApi.roomLevelValue = _filterEntity.roomLevelValue;
    _propListApi.houseDirection = [self getfilterConditionWith:_filterEntity.direction];
    _propListApi.propertyboolTag = [self getfilterConditionWith:_filterEntity.propTag];
    _propListApi.isNewProInThreeDay = _filterEntity.isNewProInThreeDay;
    _propListApi.buildTypes = [self getfilterConditionWith:_filterEntity.buildingType];
    _propListApi.minBuildingArea = _filterEntity.minBuildingArea;
    _propListApi.maxBuildingArea = _filterEntity.maxBuildingArea;
    _propListApi.minSalePrice = _filterEntity.minSalePrice;
    _propListApi.maxSalePrice = _filterEntity.maxSalePrice;
    _propListApi.minRentPrice = _filterEntity.minRentPrice;
    _propListApi.maxRentPrice = _filterEntity.maxRentPrice;
    _propListApi.trustType = trustType;
    _propListApi.scope = propScopeStr;
    _propListApi.searchKeyWord = _realSearchKeyWord;
    _propListApi.isRecommend = _filterEntity.isRecommend;
    _propListApi.pageIndex = @"1";
    _propListApi.hasPropertyKey = _filterEntity.hasPropertyKey;
    _propListApi.estateSelectType = _filterEntity.estateSelectType;
    _propListApi.isOnlyTrust = _filterEntity.isOnlyTrust;
    _propListApi.sortField = _filterEntity.sortField;
    _propListApi.ascending = _filterEntity.ascending;
    _propListApi.isTrustsApproved = _filterEntity.isTrustsApproved ? _filterEntity.isTrustsApproved:@"";
    _propListApi.isCredentials = _filterEntity.isCompleteDoc ? _filterEntity.isCompleteDoc:@"";
    _propListApi.isHasRegisterTrusts = _filterEntity.isTrustProperty?_filterEntity.isTrustProperty:@"";
    _propListApi.houseNo = _filterEntity.houseNo ? _filterEntity.houseNo : @"";
    [_manager sendRequest:_propListApi];
}

- (void)footerRefreshMethod
{
    [self checkPermission:nil];
    
    NSString *curPageNum = [NSString stringWithFormat:@"%@",@(_propListArray.count/10+1)];
    NSString * trustType;
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
    {
        trustType = [NSString stringWithFormat:@"%d",SALEBOTH];
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        trustType = [NSString stringWithFormat:@"%d",RENTBOTH];
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"租售"])
    {
        trustType = [NSString stringWithFormat:@"%d",BOTH];
    }
    else

    {
        trustType = [self priceType];
    }
    
    NSString * propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    
    _propListApi.propListTyp = self.propType;
    _propListApi.propertyTypes = [self getfilterConditionWith:_filterEntity.roomType];
    _propListApi.popStatus = [self getfilterConditionWith:_filterEntity.roomStatus];
    _propListApi.propSituationValue = _filterEntity.propSituationValue;
    _propListApi.roomLevelValue = _filterEntity.roomLevelValue;
    _propListApi.houseDirection = [self getfilterConditionWith:_filterEntity.direction];
    _propListApi.propertyboolTag = [self getfilterConditionWith:_filterEntity.propTag];
    _propListApi.isNewProInThreeDay = _filterEntity.isNewProInThreeDay;
    _propListApi.buildTypes = [self getfilterConditionWith:_filterEntity.buildingType];
    _propListApi.minBuildingArea = _filterEntity.minBuildingArea;
    _propListApi.maxBuildingArea = _filterEntity.maxBuildingArea;
    _propListApi.minSalePrice = _filterEntity.minSalePrice;
    _propListApi.maxSalePrice = _filterEntity.maxSalePrice;
    _propListApi.minRentPrice = _filterEntity.minRentPrice;
    _propListApi.maxRentPrice = _filterEntity.maxRentPrice;
    _propListApi.trustType = trustType;
    _propListApi.scope = propScopeStr;
    _propListApi.searchKeyWord = _realSearchKeyWord;
    _propListApi.isRecommend = _filterEntity.isRecommend;
    _propListApi.pageIndex = curPageNum;
    _propListApi.hasPropertyKey = _filterEntity.hasPropertyKey;
    _propListApi.estateSelectType = _filterEntity.estateSelectType;
    _propListApi.sortField = _filterEntity.sortField;
    _propListApi.ascending = _filterEntity.ascending;
    _propListApi.isTrustsApproved = _filterEntity.isTrustsApproved ? _filterEntity.isTrustsApproved:@"";
    _propListApi.isCredentials = _filterEntity.isCompleteDoc ? _filterEntity.isCompleteDoc:@"";
    _propListApi.houseNo = _filterEntity.houseNo ? _filterEntity.houseNo : @"";
    
    [_manager sendRequest:_propListApi];
}

#pragma mark - FilterViewDelegate
- (void)getButtonTag:(NSInteger)tag
{
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT);
    [_filterView filterEntity:_filterEntity];
    switch (tag)
    {
        case 10:
            
            [_filterView creatTableViewWithFirstArray:_dealTypeArray
                                       AndSecondArray:nil
                                        AndThirdArray:nil
                                     AndTableViewType:1
                                            AndBtnTag:tag
                                         AndTitleType:@"EstDealType"];
            
            break;
        case 11:
            
            [_priceArray removeAllObjects];
            [_priceArray addObject:_rentArray];
            [_priceArray addObject:_saleArray];
            [_priceArray addObject:@[]];
            
            [_dealPriceNameType removeAllObjects];
            [_dealPriceNameType addObject:@"出租价格(元)"];
            [_dealPriceNameType addObject:@"出售价格(万元)"];
            [_dealPriceNameType addObject:@"不限"];
            
            if ([_filterEntity.estDealTypeText isEqualToString:@"出售"]) {
                [_priceArray removeObject:_rentArray];
                [_dealPriceNameType removeObject:@"出租价格(元)"];
            }
            if ([_filterEntity.estDealTypeText isEqualToString:@"出租"]) {
                [_priceArray removeObject:_saleArray];
                [_dealPriceNameType removeObject:@"出售价格(万元)"];
            }
            
            [_filterView creatTableViewWithFirstArray:_dealPriceNameType
                                       AndSecondArray:_priceArray
                                        AndThirdArray:nil
                                     AndTableViewType:2
                                            AndBtnTag:tag
                                         AndTitleType:@"PriceType"];
            break;
        case 12:
            
            [_filterView creatTableViewWithFirstArray:_tagTextArray
                                       AndSecondArray:nil
                                        AndThirdArray:nil
                                     AndTableViewType:1
                                            AndBtnTag:tag
                                         AndTitleType:@"TagLabel"];
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

- (void)requestNeedEntity:(FilterEntity *)entity andType:(BOOL)type
{
    _filterEntity = entity;
    
    [self revertAnimation];
    if (type)
    {
        [self headerRefreshMethod];
    }
    _SavefilterArray = [[self getFilterConditionString] componentsSeparatedByString:@","];
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

#pragma mark - GetFilterInfoShowText
/// 顶部view的显示文字
- (void)getTopViewFilterCondition
{
    // 第一个label
    UILabel * label = (UILabel *)[self.view viewWithTag:1000000];
    label.text = _filterEntity.estDealTypeText;
    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:11];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [_filterEntity.estDealTypeText boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (size.width/2))+3, label.center.y-2, 8, 6);
    
    // 第二个label
    UILabel * secondLabel = (UILabel *)[self.view viewWithTag:1000001];
    // 价格
    NSString * priceText;
    if (_filterEntity.salePriceText && ![_filterEntity.salePriceText isEqualToString:@""]) {
        priceText = _filterEntity.salePriceText;
    }
    else if (_filterEntity.rentPriceText && ![_filterEntity.rentPriceText isEqualToString:@""])
    {
        priceText = _filterEntity.rentPriceText;
    }
    else
    {
        priceText = @"价格";
    }
    
    secondLabel.text = priceText;
    UIImageView * secondImageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *secondAttribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize otherSize = [priceText boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:secondAttribute context:nil].size;
    secondImageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (otherSize.width/2))+3, label.center.y-2, 8, 6);
    
    // 第三个label
    UILabel * thirdLabel = (UILabel *)[self.view viewWithTag:1000002];
    thirdLabel.text = _filterEntity.tagText;
    UIImageView * thirdImageView = (UIImageView *)[self.view viewWithTag:13];
    NSDictionary *thirdAttribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize thirdSize = [_filterEntity.tagText boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:thirdAttribute context:nil].size;
    thirdImageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)- ((APP_SCREEN_WIDTH/3)/2- (thirdSize.width/2))+3, label.center.y-2, 8, 6);
}

- (NSString *)getFilterConditionString
{
    if ([_filterEntity.isTrustsApproved isEqualToString:@"true"]) {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        entity.itemText = @"委托已审";
        [_filterEntity.propTag addObject:entity];
    }

    if ([_filterEntity.isCompleteDoc isEqualToString:@"true"]) {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        entity.itemText = @"证件齐全";
        [_filterEntity.propTag addObject:entity];
    }

    if ([_filterEntity.isTrustProperty isEqualToString:@"true"]) {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        entity.itemText = @"委托房源";
        [_filterEntity.propTag addObject:entity];
    }

    NSMutableArray * filterArray = [NSMutableArray arrayWithCapacity:0];
    if (_searchKeyWord && ![_searchKeyWord isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"关键字：%@",_searchKeyWord]];
    }
    
    [filterArray addObject:[NSString stringWithFormat:@"交易类型：%@",[self isHaveString:_filterEntity.estDealTypeText]]];
    NSString * areaString = [self getStringWith:_filterEntity.minBuildingArea and:_filterEntity.maxBuildingArea andType:@"面积"];
    if (![areaString isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"建筑面积：%@",areaString]];
    }
    NSString * saleString = [self getStringWith:_filterEntity.minSalePrice and:_filterEntity.maxSalePrice andType:@"出售"];
    if (![saleString isEqualToString:@""])
    {
        if ([saleString isEqualToString:@"500-9999999万"])
        {
            saleString = @"500万以上";
        }
        [filterArray addObject:[NSString stringWithFormat:@"出售价格：%@",saleString]];
    }
    NSString * rentString = [self getStringWith:_filterEntity.minRentPrice and:_filterEntity.maxRentPrice andType:@"出租"];
    if (![rentString isEqualToString:@""])
    {
        if ([rentString isEqualToString:@"4000-9999999元"])
        {
            rentString = @"4000元以上";
        }
        
        [filterArray addObject:[NSString stringWithFormat:@"出租价格：%@",rentString]];
    }
    [filterArray addObject:[NSString stringWithFormat:@"标签：%@",[self isHaveString:_filterEntity.tagText]]];
    if (![[self getArrayString:_filterEntity.roomType] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房型：%@",[self getArrayString:_filterEntity.roomType]]];
    }
    if (![[self getArrayString:_filterEntity.roomStatus] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"房源状态：%@",[self getArrayString:_filterEntity.roomStatus]]];
        
    }
    if (![[self isHaveString:_filterEntity.propSituationText] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"房屋现状：%@",[self isHaveString:_filterEntity.propSituationText]]];
    }
    if (![[self isHaveString:_filterEntity.roomLevelText] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"房源等级：%@",[self isHaveString:_filterEntity.roomLevelText]]];
    }
    if (![[self getArrayString:_filterEntity.direction] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"朝向：%@",[self getArrayString:_filterEntity.direction]]];
    }
    if (![[self getArrayString:_filterEntity.propTag] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"房源标签：%@",[self getArrayString:_filterEntity.propTag]]];
    }
    if (![[self getArrayString:_filterEntity.buildingType] isEqualToString:@""]) {
        [filterArray addObject:[NSString stringWithFormat:@"建筑类型：%@",[self getArrayString:_filterEntity.buildingType]]];
    }
    
    NSInteger tagCount = _filterEntity.propTag.count;
    
    for (NSInteger i = tagCount - 1; i >= 0; i--)
    {
        SelectItemDtoEntity *entity = _filterEntity.propTag[i];
        
        if ([entity.itemText isEqualToString:@"委托已审"])
        {
            [_filterEntity.propTag removeObject:entity];
        }

        if ([entity.itemText isEqualToString:@"证件齐全"])
        {
            [_filterEntity.propTag removeObject:entity];
        }

        if ([_allRoundListPresenter haveTrustProperty])
        {
            if ([entity.itemText isEqualToString:@"委托房源"])
            {
                [_filterEntity.propTag removeObject:entity];
            }
        }
    }
    
    [filterArray removeObject:@""];
    
    NSString * string = [filterArray componentsJoinedByString:@","];
    return string;
}

/// 输入的面积或价格 （判断价格是否为空或者为0 不保存）
- (NSString *)getStringWith:(NSString *)minString and:(NSString*)maxString andType:(NSString*)type
{
    minString = [self opinionStringFromString:minString];
    maxString = [self opinionStringFromString:maxString];
    if ((minString !=  nil &&maxString !=  nil) && (![minString isEqualToString:@""] &&![maxString isEqualToString:@""]))
    {
        NSString * infoString;
        if ([type isEqualToString:@"面积"])
        {
            infoString = [NSString stringWithFormat:@"%@-%@㎡",minString,maxString];
        }
        else if ([type isEqualToString:@"出租"])
        {
            infoString = [NSString stringWithFormat:@"%@-%@元",minString,maxString];
        }
        else
        {
            infoString = [NSString stringWithFormat:@"%@-%@万",minString,maxString];
        }
        
        return infoString;
    }
    else if (minString!= nil && ![minString isEqualToString:@""])
    {
        NSString * infoString;
        if ([type isEqualToString:@"面积"])
        {
            infoString = [NSString stringWithFormat:@"%@㎡以上",minString];
        }
        else if ([type isEqualToString:@"出租"])
        {
            infoString = [NSString stringWithFormat:@"%@元以上",minString];
        }
        else
        {
            infoString = [NSString stringWithFormat:@"%@万以上",minString];
        }
        
        return infoString;
    }
    else if (maxString != nil && ![maxString isEqualToString:@""])
    {
        NSString * infoString;
        if ([type isEqualToString:@"面积"])
        {
            infoString = [NSString stringWithFormat:@"%@㎡以下",maxString];
        }
        else if ([type isEqualToString:@"出租"])
        {
            infoString = [NSString stringWithFormat:@"%@元以下",maxString];
        }
        else
        {
            infoString = [NSString stringWithFormat:@"%@万以下",maxString];
        }
        
        return infoString;
    }
    else
    {
        return @"";
    }
}

/// 判断字符串是否为空
- (NSString *)isHaveString:(NSString *)string
{
    if (string && ![string isEqualToString:@""])
    {
        return string;
    }
    return @"";
}

/// 获取数组中的text
- (NSString *)getArrayString:(NSMutableArray*)array
{
    if (array.count == 0)
    {
        return @"";
    }
    NSMutableArray * stringArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<array.count; i++)
    {
        SelectItemDtoEntity * entity = array[i];
        [stringArray addObject:entity.itemText];
    }
    NSString * string = [stringArray componentsJoinedByString:@"、"];
    return string;
}

- (BOOL) isBlankString:(NSString *)string
{
    if (string ==  nil || string ==  NULL) { return YES; }
    if ([string isKindOfClass:[NSNull class]]) { return YES; }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    return NO;
}

/// 获取FilterEntity里面数组的具体值的value
- (NSMutableArray*)getfilterConditionWith:(NSMutableArray *)array
{
    NSMutableArray * infoArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<array.count; i++)
    {
        SelectItemDtoEntity * entity = array[i];
        [infoArray addObject:entity.itemValue];
    }
    return infoArray;
}

- (NSString *)priceType
{
      NSString * valueString;
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_ALLTREDE_SEARCH])
    {
        valueString = @"";
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_RENT_SEARCH_ALL])
    {
        valueString = @"4";
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_SALE_SEARCH_ALL])
    {
        valueString = @"5";
    }
    return valueString;
}

#pragma mark - AllRoundListViewProtocol
- (void)goAllRoundDetailViewController
{
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:_selectIndex];

    if ([_allRoundListPresenter isCurrencyDataView])
    {
        AllRoundDetailViewController *allRoundDetailVC = [[AllRoundDetailViewController alloc]initWithNibName:@"AllRoundDetailViewController" bundle:nil];
        allRoundDetailVC.myDelegate = self;
        allRoundDetailVC.propKeyId = propModelEntity.keyId;
        allRoundDetailVC.propTrustType = [NSString stringWithFormat:@"%@",propModelEntity.trustType];
        allRoundDetailVC.propNameStr = [NSString stringWithFormat:@"%@",propModelEntity.estateName];
        allRoundDetailVC.propBuildingName = [NSString stringWithFormat:@"%@",propModelEntity.buildingName];
        allRoundDetailVC.propHouseNo = [NSString stringWithFormat:@"%@",propModelEntity.houseNo];
        allRoundDetailVC.propImgUrl = [NSString stringWithFormat:@"%@",propModelEntity.photoPath];
        allRoundDetailVC.propModelEntity = propModelEntity;
        allRoundDetailVC.takeSeeCount = [NSString stringWithFormat:@"%@",propModelEntity.takeToSeeCount];
        NSInteger intNum = [propModelEntity.hasRegisterTrusts integerValue];
        if (intNum == 1) {
            allRoundDetailVC.isHasRegisterTrusts = YES;
        }else{
            allRoundDetailVC.isHasRegisterTrusts = NO;
        }
        
        [self.navigationController pushViewController:allRoundDetailVC
                                             animated:YES];
    }
    else
    {
        // 横琴 澳门
        HQAllRoundDetailVC *allRoundDetailVC = [[HQAllRoundDetailVC alloc]initWithNibName:@"HQAllRoundDetailVC" bundle:nil];
        
        allRoundDetailVC.propKeyId = propModelEntity.keyId;
        allRoundDetailVC.propTrustType = [NSString stringWithFormat:@"%@",propModelEntity.trustType];
        allRoundDetailVC.propNameStr = [NSString stringWithFormat:@"%@",propModelEntity.estateName];
        allRoundDetailVC.propBuildingName = [NSString stringWithFormat:@"%@",propModelEntity.buildingName];
        allRoundDetailVC.propHouseNo = [NSString stringWithFormat:@"%@",propModelEntity.houseNo];
        allRoundDetailVC.propImgUrl = [NSString stringWithFormat:@"%@",propModelEntity.photoPath];
        allRoundDetailVC.propModelEntity = propModelEntity;
        allRoundDetailVC.isMacau = propModelEntity.isMacau;
        
        [self.navigationController pushViewController:allRoundDetailVC
                                             animated:YES];
    }
}

#pragma mark - BYActionSheetViewDelegate
- (void)actionSheetView:(BYActionSheetView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
{
    if (buttonIndex < 0 || buttonIndex == 5) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            // 售价从大到小
            _filterEntity.sortField = SalePrice;
            _filterEntity.ascending = FALSE_String;
            _currentSort = @"售价从大到小";
            break;
        case 1:
            // 售价从小到大
            _filterEntity.sortField = SalePrice;
            _filterEntity.ascending = TRUE_String;
            _currentSort = @"售价从小到大";
            break;
        case 2:
            // 租价从大到小
            _filterEntity.sortField = RentPrice;
            _filterEntity.ascending = FALSE_String;
            _currentSort = @"租价从大到小";
            break;
        case 3:
            // 租价从小到大
            _filterEntity.sortField = RentPrice;
            _filterEntity.ascending = TRUE_String;
            _currentSort = @"租价从小到大";
            break;
        case 4:
            // 恢复默认排序
            _filterEntity.sortField = @"";
            _filterEntity.ascending = TRUE_String;
            _currentSort = @"恢复默认排序";
            break;
        default:
            break;
    }
    
    [self headerRefreshMethod];
}

#pragma mark - AllRoundFilterCustomViewDelegate
- (void)getBtnTag:(NSInteger)tag FilterName:(NSString *)name SettingSwitch:(BOOL)ison andSearchName:(NSString *)searchName
{
    if (tag == 100)
    {
        //去除字符串前端的空格
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString * nameString = [name stringByTrimmingCharactersInSet:whitespace];
        
        if ([nameString isEqualToString:@""]||[self isBlankString:nameString])
        {
            [CustomAlertMessage showAlertMessage:@"筛选别名不能为空\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2
                                 andCustomWindow:_mainWindow];
        }
        else
        {
            for (int i = 0; i<_allInfoArray.count; i++)
            {
                DataFilterEntity * entity =  _allInfoArray[i];
                if ([entity.nameString isEqualToString:nameString])
                {
                    [CustomAlertMessage showAlertMessage:@"为方便您区分搜索条件,请不要保存重复的别名\n\n"
                                         andButtomHeight:APP_SCREEN_HEIGHT/2
                                         andCustomWindow:_mainWindow];
                    return;
                }
            }
            
            if (ison)
            {
                _filterEntity.isCurrent = YES;
                for (NSInteger i = 0; i <_allInfoArray.count; i++)
                {
                    
                    DataFilterEntity * entity = _allInfoArray[i];
                    FilterEntity * filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                          fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                       error:nil];
                    filterEntity.isCurrent = NO;
                    NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:filterEntity];
                    NSString * valueString = [jsonDic JSONString];
                    [_dataBaseOperation updateFilterConditionIsCurrent:valueString fromFilterName:entity.nameString];
                }
                _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",nameString];
                [CommonMethod setUserdefaultWithValue:_searchKeyWord forKey:KeyWord];
                [CommonMethod setUserdefaultWithValue:nameString forKey:NameString];
            }
            else
            {
                _filterEntity.isCurrent = NO;
            }
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:_filterEntity];
            NSString * valueString = [jsonDic JSONString];
            //	NSString *jsonShowStr = [[self getFilterConditionString] JSONString];
            NSString *jsonShowStr = [self getFilterConditionString];
            [_dataBaseOperation insertFilterConditionName:nameString
                                              FilterValue:jsonShowStr
                                             FilterEntity:valueString];
            [CustomAlertMessage showAlertMessage:@"保存成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            [self removeWindow];
        }
    }
    else
    {
        [self removeWindow];
    }
}
//点击灰色区域
- (void)clickTapGesture
{
    [self removeWindow];
}
// 删除保存view
- (void)removeWindow
{
    [_mainWindow resignKeyWindow];
    [_mainWindow removeFromSuperview];
    
    [[self sharedAppDelegate].window makeKeyAndVisible];
}

#pragma mark - FilterListDelegate
- (void)getFilterListEntity:(DataFilterEntity *)entity isSendService:(BOOL)isSend isSettingName:(BOOL)isSetting
{
    [self changeSearchBarRightBtnImageWithSearching:YES];
    _isSetttingName = isSetting;
    _isSendService = isSend;
    if (isSend)
    {
        if ([entity.nameString isEqualToString:@""]||!entity)
        {
            _bottomFilterLabel.text = @"暂无默认搜索";
            _searchKeyWord = @"";
            _searchTextfield.text =  @"输入城区、片区、楼盘名";
            
            [self headerRefreshMethod];
        }
        else
        {
            _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
            _currentSelectString = entity.nameString;
            
            _filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                    fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                 error:nil];
            _currentShowText = entity.showText;
            NSString *keyWord = [CommonMethod getUserdefaultWithKey:KeyWord];
            _searchKeyWord = keyWord;
            _searchTextfield.text = keyWord;
            [self headerRefreshMethod];
        }
        //顶部view的显示文字
        [self getTopViewFilterCondition];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _propListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"allRoundListCell";
    
    AllRoundListCell *allRoundListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!allRoundListCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"AllRoundListCell"
                                              bundle:nil]
                              forCellReuseIdentifier:CellIdentifier];
        allRoundListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    PropertysModelEntty *propModelEntity;
    
    if (_propListArray.count !=  0)
    {
        propModelEntity = [_propListArray objectAtIndex:indexPath.row];
        // 是否为澳盘
        if ([propModelEntity.isMacau boolValue])
        {
            allRoundListCell.propImageAO.hidden = NO;
        }
        else
        {
            allRoundListCell.propImageAO.hidden = YES;
        }
        
        allRoundListCell.propTitleLabel.textColor = [UIColor blackColor];
        allRoundListCell.propAcreage.textColor = [UIColor grayColor];
        allRoundListCell.propSupportLabel.textColor = [UIColor grayColor];
        allRoundListCell.propDetailMsgLabel.textColor = [UIColor grayColor];
        allRoundListCell.propAvgPriceLabel.textColor = [UIColor grayColor];
        
        if ([_propType isEqualToString:WARZONE])
        {
            if ([RecentBrowseUtils istHouseIdCache:propModelEntity.keyId])
            {
                allRoundListCell.propTitleLabel.textColor = [UIColor lightGrayColor];
                allRoundListCell.propAcreage.textColor = [UIColor lightGrayColor];
                allRoundListCell.propSupportLabel.textColor = [UIColor lightGrayColor];
                allRoundListCell.propDetailMsgLabel.textColor = [UIColor lightGrayColor];
                allRoundListCell.propAvgPriceLabel.textColor = [UIColor lightGrayColor];
            }
        }
        
        if (propModelEntity.buildingName)
        {
            //buildingName不为空
            allRoundListCell.propTitleLabel.text = [NSString stringWithFormat:@"%@ %@",propModelEntity.estateName,propModelEntity.buildingName];
        }
        else
        {
            allRoundListCell.propTitleLabel.text = propModelEntity.estateName;
        }
        
        [allRoundListCell.propImgView setContentMode:UIViewContentModeScaleAspectFill];
        
        int tagCount = 0;
        if(propModelEntity.entrustKeyId){
            tagCount ++;
        }
        if(propModelEntity.onlyTrustKeyId){
            tagCount ++;
        }
        
        if(tagCount ==  2)
        {
            allRoundListCell.tag1.hidden = NO;
            allRoundListCell.tag2.hidden = NO;
            
            allRoundListCell.tag1.text = @"押";
            allRoundListCell.tag2.text = [_allRoundListPresenter getTagString];
          
        }
        else if(tagCount ==  1)
        {
            allRoundListCell.tag1.hidden = YES;
            allRoundListCell.tag2.hidden = NO;
            
            if(propModelEntity.entrustKeyId)
            {
                allRoundListCell.tag2.text = @"押";
            }
            else
            {
                allRoundListCell.tag1.text = @"押";
                allRoundListCell.tag2.text = [_allRoundListPresenter getTagString];
            }
        }
        else
        {
            allRoundListCell.tag1.hidden = YES;
            allRoundListCell.tag2.hidden = YES;
        }
        
        if (![NSString isNilOrEmpty:propModelEntity.photoPath])
        {
            
            NSString *newImgPhotoPath = [NSString stringWithFormat:@"%@%@&watermark=smallgroup_center",propModelEntity.photoPath,AllRoundListPhotoWidth];
            
            [CommonMethod setImageWithImageView:allRoundListCell.propImgView
                                    andImageUrl:newImgPhotoPath
                        andPlaceholderImageName:@"defaultEstateBg_img"];
        }
        else
        {
            
            [allRoundListCell.propImgView setImage:[UIImage imageNamed:@"defaultEstateBg_img"]];
        }
        
        allRoundListCell.propSupportLabel.text = [NSString stringWithFormat:@"%@  %@",
                                                  propModelEntity.houseType?propModelEntity.houseType:@"",
                                                  propModelEntity.floor?propModelEntity.floor:@""];
        allRoundListCell.propDetailMsgLabel.text = [NSString stringWithFormat:@"%@  %@",
                                                    propModelEntity.houseDirection?propModelEntity.houseDirection:@"",
                                                    propModelEntity.propertyType?propModelEntity.propertyType:@""];
        
        allRoundListCell.propImageCntLabel.text = [NSString stringWithFormat:@"%@",propModelEntity.realSurveyCount];
        
        //面积
        
        if ([_allRoundListPresenter haveAreaUnit])
        {
            allRoundListCell.propAcreage.text = propModelEntity.square;
        }
        else
        {
            allRoundListCell.propAcreage.text = [NSString stringWithFormat:@"%@㎡",propModelEntity.square];
        }
        
        NSString *propImgCntStr = [NSString stringWithFormat:@"%@10",propModelEntity.realSurveyCount];
        CGFloat propImgCntWidth = [propImgCntStr getStringWidth:[UIFont fontWithName:FontName
                                                                                size:10.0]
                                                         Height:14.0
                                                           size:10.0];
        if (propImgCntWidth >=  12)
        {
            allRoundListCell.propImgCntViewWidth.constant = 26 + (propImgCntWidth-12);
        }
        else
        {
            allRoundListCell.propImgCntViewWidth.constant = 26;
        }
        
        allRoundListCell.propTypeSignImageView.hidden = NO;
        allRoundListCell.propPriceLabel.hidden = NO;
        
        switch (propModelEntity.trustType.integerValue) {
            case 1:
            {
                //出售
                allRoundListCell.propTypeSignImageWidth.constant = 18;
                [allRoundListCell.propTypeSignImageView setImage:[UIImage imageNamed:@"propSaleType_sign_alpha_"]];
            }
                break;
            case 2:
            {
                //出租
                allRoundListCell.propTypeSignImageWidth.constant = 18;
                [allRoundListCell.propTypeSignImageView setImage:[UIImage imageNamed:@"propRentType_sign_alpha_"]];
            }
                break;
            case 3:
            {
                //租售
                allRoundListCell.propTypeSignImageWidth.constant = 27;
                [allRoundListCell.propTypeSignImageView setImage:[UIImage imageNamed:@"propRentAndSaleType_sign_alpha_"]];
            }
                break;
                
            default:
            {
                allRoundListCell.propPriceLabel.hidden = YES;
                allRoundListCell.propTypeSignImageView.hidden = YES;
            }
                break;
        }
        
        allRoundListCell.propImageBtn.tag = PropHeadImageBtnTag+indexPath.row;
        [allRoundListCell.propImageBtn addTarget:self
                                          action:@selector(clickHeadImageMethod:)
                                forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  出租：显示租价；出售：显示售价；租售：显示售价
         */
        NSString *propPriceResultStr ;
        NSString *propPriceUnitStr;
        NSString *salePrice;
        
        if (propModelEntity.trustType.integerValue ==  1 ||
            propModelEntity.trustType.integerValue ==  3) {
            
            /**
             *  售价超过“亿”，转换单位，数据是以“万”为单位
             *
             */
            if (propModelEntity.salePrice.floatValue >=  10000)
            {
                propPriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      propModelEntity.salePrice.floatValue/10000];
                propPriceUnitStr = @"亿";
            }
            else
            {
                propPriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      propModelEntity.salePrice.floatValue];
                propPriceUnitStr = @"万";
            }
            //			if ([propPriceResultStr rangeOfString:@".00"].location !=  NSNotFound) {
            //
            //				//不是有效的数字，去除小数点后的0
            //				propPriceResultStr = [propPriceResultStr
            //									  substringToIndex:propPriceResultStr.length - 3];
            //			}
            
            if ([_allRoundListPresenter havePriceUnit])
            {
                salePrice = propModelEntity.salePrice;
            }
        }
        else
        {
            CGFloat propPriceResult = [propModelEntity.rentPrice floatValue];
            
            if (propPriceResult >=  10000)
            {
                propPriceUnitStr = @"万/月";
                propPriceResult = propPriceResult/10000;
            }
            else
            {
                propPriceUnitStr = @"元/月";
            }
            
            propPriceResultStr = [NSString stringWithFormat:@"%.2f",propPriceResult];
            
            if ([_allRoundListPresenter havePriceUnit])
            {
                salePrice = propModelEntity.rentPrice;
            }
        }
        
        if ([propPriceResultStr rangeOfString:@".00"].location !=  NSNotFound)
        {
            //不是有效的数字，去除小数点后的0
            propPriceResultStr = [propPriceResultStr
                                  substringToIndex:propPriceResultStr.length - 3];
        }
        
        if ([_allRoundListPresenter havePriceUnit])
        {
            allRoundListCell.propPriceLabel.text = salePrice;
            
        }
        else
        {
            allRoundListCell.propPriceLabel.text = [NSString stringWithFormat:@"%@%@",
                                                    propPriceResultStr,
                                                    propPriceUnitStr];
        }
        
        /**
         *  出售、租售需要显示均价(售价是以万为单位的)
         */
        NSString *propAvgPriceStr;
        NSString *propAvgPriceUnitStr;
        
        if (propModelEntity.trustType.integerValue ==  1 ||
            propModelEntity.trustType.integerValue ==  3) {
            
            CGFloat propAvgPriceValue = propModelEntity.salePriceUnit.floatValue;
        
            if (propAvgPriceValue > 10000)
            {
                propAvgPriceValue = propAvgPriceValue/10000;
                propAvgPriceStr = [NSString stringWithFormat:@"%.2f",
                                   propAvgPriceValue];
                propAvgPriceUnitStr = [NSString stringWithFormat:@"万/㎡"];
            }
            else
            {
                propAvgPriceStr = [NSString stringWithFormat:@"%.2f",
                                   propAvgPriceValue];
                propAvgPriceUnitStr = [NSString stringWithFormat:@"元/㎡"];
            }
            
            if ([propAvgPriceStr rangeOfString:@".00"].location !=  NSNotFound)
            {
                //不是有效的数字，去除小数点后的0
                propAvgPriceStr = [propAvgPriceStr
                                   substringToIndex:propAvgPriceStr.length - 3];
            }
            
            
            if ([_allRoundListPresenter havePriceUnit])
            {
                allRoundListCell.propAvgPriceLabel.text = propModelEntity.salePriceUnit;
               
            }
            else
            {
                allRoundListCell.propAvgPriceLabel.text = [NSString stringWithFormat:@"%@%@",
                                                           propAvgPriceStr,
                                                           propAvgPriceUnitStr];
            }
        }
        else
        {
            allRoundListCell.propAvgPriceLabel.text = @"";
        }
        
        /**
         *  设置列表中的标签的值
         */
        allRoundListCell.propFirstTagBtn.hidden = YES;
        allRoundListCell.propSecondTagBtn.hidden = YES;
        allRoundListCell.propThreeTagBtn.hidden = YES;
        
        if (propModelEntity.propertyTags.count ==  1)
        {
            PropertyTagEntity *firstTagEntity = [propModelEntity.propertyTags objectAtIndex:0];
            
            allRoundListCell.propFirstTagBtn.hidden = NO;
            [allRoundListCell.propFirstTagBtn setTitle:firstTagEntity.tagName
                                              forState:UIControlStateNormal];
            [allRoundListCell.propFirstTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:firstTagEntity.styleColor]];
            
            CGFloat firstBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            allRoundListCell.propFirstTagBtnWidth.constant = firstBtnWidth + 10 ;
            
        }
        else if (propModelEntity.propertyTags.count ==  2)
        {
            PropertyTagEntity *firstTagEntity = [propModelEntity.propertyTags objectAtIndex:0];
            PropertyTagEntity *secondTagEntity = [propModelEntity.propertyTags objectAtIndex:1];
            
            allRoundListCell.propFirstTagBtn.hidden = NO;
            [allRoundListCell.propFirstTagBtn setTitle:firstTagEntity.tagName
                                              forState:UIControlStateNormal];
            [allRoundListCell.propFirstTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:firstTagEntity.styleColor]];
            
            allRoundListCell.propSecondTagBtn.hidden = NO;
            [allRoundListCell.propSecondTagBtn setTitle:secondTagEntity.tagName
                                               forState:UIControlStateNormal];
            [allRoundListCell.propSecondTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:secondTagEntity.styleColor]];
            
            CGFloat firstBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            allRoundListCell.propFirstTagBtnWidth.constant = firstBtnWidth + 10 ;
            
            CGFloat secondBtnWidth = [secondTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                      Height:15
                                                                        size:11.0];
            allRoundListCell.propSecondTagBtnWidth.constant = secondBtnWidth + 10 ;
            
        }
        else if (propModelEntity.propertyTags.count >=  3)
        {
            PropertyTagEntity *firstTagEntity = [propModelEntity.propertyTags objectAtIndex:0];
            PropertyTagEntity *secondTagEntity = [propModelEntity.propertyTags objectAtIndex:1];
            PropertyTagEntity *threeTagEntity = [propModelEntity.propertyTags objectAtIndex:2];
            
            allRoundListCell.propFirstTagBtn.hidden = NO;
            [allRoundListCell.propFirstTagBtn setTitle:firstTagEntity.tagName
                                              forState:UIControlStateNormal];
            [allRoundListCell.propFirstTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:firstTagEntity.styleColor]];
            
            allRoundListCell.propSecondTagBtn.hidden = NO;
            [allRoundListCell.propSecondTagBtn setTitle:secondTagEntity.tagName
                                               forState:UIControlStateNormal];
            [allRoundListCell.propSecondTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:secondTagEntity.styleColor]];
            
            allRoundListCell.propThreeTagBtn.hidden = NO;
            [allRoundListCell.propThreeTagBtn setTitle:threeTagEntity.tagName
                                              forState:UIControlStateNormal];
            [allRoundListCell.propThreeTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:threeTagEntity.styleColor]];
            
            CGFloat firstBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            allRoundListCell.propFirstTagBtnWidth.constant = firstBtnWidth + 10 ;
            
            CGFloat secondBtnWidth = [secondTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                      Height:15
                                                                        size:11.0];
            allRoundListCell.propSecondTagBtnWidth.constant = secondBtnWidth + 10 ;
            
            CGFloat threeBtnWidth = [threeTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            allRoundListCell.propThreeTagBtnWidth.constant = threeBtnWidth + 10 ;
        }
        return allRoundListCell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:indexPath.row];
    
    _selectIndex = indexPath.row;
    _selectRow = indexPath.row;
    
    if ([_propType isEqualToString:WARZONE])
    {
        if (![RecentBrowseUtils istHouseIdCache:propModelEntity.keyId]) {
            [RecentBrowseUtils setRecentBrowse:propModelEntity.keyId];
        }
    }

    // 进入房源详情页
    [_allRoundListPresenter goAllRoundDetailVC];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

#pragma mark - ClickHeadImageMethod

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >=  7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        
        if (MODEL_VERSION >=  8.0)
        {
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


#pragma mark-ResponseDelegate
- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];

    if ([modelClass isEqual:[PropListEntity class]]) {
        
        PropListEntity *propListEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        BOOL permissionIsEmpty = NO;
        //更新用户权限
        if(propListEntity.permisstionsModel){
            
            PermisstionsEntity *permisson = [PermisstionsEntity new];
            permisson.menuPermisstion = propListEntity.permisstionsModel.menuPermisstion;
            permisson.rights = propListEntity.permisstionsModel.rights;
            //            permisson.operatorValPermisstion = propListEntity.permisstionsModel.operatorValPermisstion;
            permisson.departmentKeyIds = propListEntity.permisstionsModel.departmentKeyIds;
            permisson.rightUpdateTime = propListEntity.permisstionsModel.rightUpdateTime;
            
            [AgencyUserPermisstionUtil updateUserPermission:permisson];

            /**
             更新筛选项
             */
            [self initArray];
            
            //如果没有权限，表示经纪人离职
            permissionIsEmpty = [AgencyUserPermisstionUtil permissionIsEmpty];
            if(permissionIsEmpty)
            {
                [self logout];
            }
        }
        
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];
        
//        if (propListEntity.tag !=  Tag_GetPropList) {
//            return;
//        }

        //加次判断为防止没有权限时，强制退出后，提示没有权限
        if(!permissionIsEmpty){
            //检查权限，没有权限时弹出提示，点击确定退出当前页面
            [self checkPermission:nil];
        }
        
        if(!propListEntity.flag)
        {
            showMsg(propListEntity.errorMsg);
            return;
        }
        
        if (propListEntity.propertysModel.count < 10 ||!propListEntity.propertysModel)
        {
            _mainTableView.footerHidden = YES;
        }
        else
        {
            _mainTableView.footerHidden = NO;
        }
        
        [_propListArray addObjectsFromArray:propListEntity.propertysModel];
        
        if (_propListArray.count ==  0) {
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }else{
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }
        
        [_mainTableView reloadData];
    }
    
    if ([modelClass isEqual:[CheckRealProtectedEntity class]])
    {
        //点击上传实勘
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];

        if(isAble)
        {
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _clickImageHouseID;
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.width]) {
                uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.high]) {
                uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            }
            
            NSString *isLockRoom = [NSString stringWithFormat:@"%d",checkRealProtectedEntity.isLockRoom];
            if (![NSString isNilOrEmpty:isLockRoom]) {
                uploadRealSurveyVC.isLockRoom = checkRealProtectedEntity.isLockRoom;
            }
            
            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount]) {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount]) {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            [self.navigationController pushViewController:uploadRealSurveyVC
                                                 animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [[SDImageCache sharedImageCache] clearDisk];
    
    [super didReceiveMemoryWarning];
}


@end
