//
//  MyCollectViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MoreFilterViewController.h"
#import "CreatFilterButtonView.h"
#import "FilterView.h"
#import "AllRoundListCell.h"
#import "FilterEntity.h"
#import "PropListEntity.h"
#import "PhotoDownLoadImageViewController.h"
#import "UploadRealSurveyViewController.h"
#import "AllRoundDetailViewController.h"
#import "SearchViewController.h"
#import "CheckRealProtectedEntity.h"
#import "LogOffUtil.h"

#import "GetPropListApi.h"
#import "CheckRealProtectedDurationApi.h"
#import "CollectPropApi.h"
#import "SystemParamTypeEnum.h"
#import "PropertyStatusCategoryEnum.h"
#import "HQAllRoundDetailVC.h"

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
#define NotHavePermissionAlertTag       4000

@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,FilterViewDelegate,ButtonClickDelegate,MoreFilterInfoDelegate,AllRoundListViewProtocol,
UITextFieldDelegate,SearchResultDelegate,EditRefreshDelegate,AllRoundListViewProtocol>
{
    AllRoundListBasePresenter *_allRoundListPresenter;

    GetPropListApi *_propListApi;
    CheckRealProtectedDurationApi *_checkRealProtectedApi;
    CollectPropApi *_collectPropApi;
    
    __weak IBOutlet UIView *_topView;
    __weak IBOutlet UITableView *_mainTableView;
    FilterView * _filterView;
    CreatFilterButtonView * _customView;
    FilterEntity *_filterEntity;

    NSInteger _btnTag;
    NSMutableArray * _propListArray;
    NSMutableArray *_dealPriceNameType;       //交易价格类型名称数组
    NSMutableArray *_priceArray;              //价格数组
    NSArray * _dealTypeArray;           //交易类型数组
    NSArray * _tagTextArray;            //标签数组
    NSString *_clickImageHouseID;   //点击当前实勘image的houseid

    UITextField *_searchTextfield;      //导航栏上的输入框（不可输入，只能显示文字）
    UIButton *_rightSearchBtn;          //导航栏上右部的按钮（语音、删除搜索内容）
    
    BOOL _isSearching;                  //是否正在搜索的状态，用来切换导航栏右部的按钮样式
    
    NSString *_searchKeyWord;           //搜索关键字
    NSString *_cancleCollectKeyId;      //取消收藏的keyId
    
    NSArray *_rentArray;
    NSArray *_saleArray;
    NSInteger _selectRow;     // 当前选中cell
}

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectRow = -1;
    
    [self checkPermission:^(NSString *permission) {
        [self showLoadingView:nil];
        
        [self initPresenter];
        [self initData];
        [self initArray];
        [self initNavTitleView];
        [self creatFilterView];
        [self createRefreshViewMethod];
        [self initOrderFilterView];
        _mainTableView.tableFooterView = [[UIView alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FirstTitle:) name:@"FirstTitle" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SecondTitle:) name:@"SecondTitle" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ThirdTitle:) name:@"ThirdTitle" object:nil];
    }];
    
}

- (void)checkPermission:(HaveMenuPermissionBlock)block
{
    [self checkShowViewPermission:MENU_PROPERTY_MY_FAVORITE andHavePermissionBlock:block];
}

- (void)logout
{
    /// 用户退出登录后清除用户信息
    [LogOffUtil clearUserInfoFromLocal];
    
    [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
}


- (void)FirstTitle:(NSNotification *)text{
    UILabel *label = (UILabel *)[self.view viewWithTag:1000000];
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    label.text = value;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:11];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3) - ((APP_SCREEN_WIDTH / 3) / 2 - (size.width / 2)) + 3, label.center.y - 2, 8, 6);
    
    
    UILabel *secondLabel = (UILabel *)[self.view viewWithTag:1000001];
    secondLabel.text = @"价格";
    UIImageView *secondImageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *secondAttribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize otherSize = [@"价格" boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:secondAttribute context:nil].size;
    secondImageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3) - ((APP_SCREEN_WIDTH / 3) / 2 - (otherSize.width / 2)) + 3, label.center.y - 2, 8, 6);
}
- (void)SecondTitle:(NSNotification *)text{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000001];
    label.text = value;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3) - ((APP_SCREEN_WIDTH / 3) / 2 - (size.width / 2)) + 3, label.center.y - 2, 8, 6);
}

- (void)ThirdTitle:(NSNotification *)text
{
    NSString *value = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"key"]];
    UILabel *label = (UILabel *)[self.view viewWithTag:1000002];
    label.text = value;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:13];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH / 3) - ((APP_SCREEN_WIDTH / 3) / 2 - (size.width / 2)) + 3, label.center.y - 2, 8, 6);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mainTableView headerBeginRefreshing];
}

- (void)initNavTitleView
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
    
    
}

- (void)clickVoiceSearch
{
    //语音搜索
    
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController"
                                                                           bundle:nil];
    searchVC.searchType = TopVoidSearchType;
    searchVC.isFromMainPage = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
    
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
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    _filterEntity.houseNo = @"";
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    
    [_mainTableView headerBeginRefreshing];
}

#pragma mark - <TextfieldDelegate>
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

#pragma mark - <SearchResultDelegate>
- (void)searchResultWithKeyword:(NSString *)keyword andExtendAttr:(NSString *)extendAttr andItemValue:(NSString *)itemvalue andHouseNum:(NSString *)houseNum
{
    _searchKeyWord = keyword;
    // 是否可以搜索房号
    if ([_allRoundListPresenter canSearchHouseNo]) {
        _filterEntity.houseNo = houseNum;
        if (![NSString isNilOrEmpty:houseNum]) {
            _searchKeyWord = [NSString stringWithFormat:@"%@,%@",keyword,houseNum];
        }
    }
    
    _filterEntity.estateSelectType = extendAttr;
    if (keyword.length <= 0) {
        _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    }

    
    
    [self changeSearchBarRightBtnImageWithSearching:YES];
    
    [_mainTableView headerBeginRefreshing];
}

#pragma mark - <筛选>
- (void)goFilterVC {
    //删除自定义filterview的tag记录
    _btnTag = 0;
    MoreFilterViewController *moreFilterVC = [[MoreFilterViewController alloc]initWithNibName:@"MoreFilterViewController"   bundle:nil];
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:_filterEntity];
    moreFilterVC.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    moreFilterVC.filterEntity = _filterEntity;
    moreFilterVC.delegate = self;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectFilterButton" object:self userInfo:nil];
    [self.navigationController pushViewController:moreFilterVC
                                         animated:YES];
    
}

- (void)createRefreshViewMethod
{
    [_mainTableView addHeaderWithTarget:self
                                 action:@selector(headerRefreshMethod)];
    [_mainTableView addFooterWithTarget:self
                                 action:@selector(footerRefreshMethod)];
    
    
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
    [_customView creatButtonFirstLabel:@"交易类型" SecondLabel:@"价格" ThirdLabel:@"不限"];
    _customView.delegate = self;
    [_topView addSubview:_customView];
}

- (void)initArray
{
    SysParamItemEntity *exchangeType = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_TYPE];
    SelectItemDtoEntity *allEntity = [SelectItemDtoEntity new];
    allEntity.itemText = @"全部";
    NSMutableString *string = [[NSMutableString alloc]init];
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:0];
    /**
     *  房源列表页的交易类型筛选项根据权限显示不同的筛选项
     */
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
    
    
    for (int i = 0; i < nameArray.count; i++)
    {
        SelectItemDtoEntity *entity = nameArray[i];
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
  
    //售价数组
    _saleArray = [NSArray arrayWithObjects:
                         @"100万以下",@"100万-150万",
                         @"150万-200万",@"200万-250万",
                         @"250万-300万",@"300万-350万",
                         @"350万-400万",@"400万-450万",
                         @"450万-500万",@"500万以上", nil];
    //租价数组
    _rentArray = [NSArray arrayWithObjects:
                         @"500元以下",@"500元-1000元",
                         @"1000元-1500元",@"1500元-2000元",
                         @"2000元-2500元",@"2500元-3000元",
                         @"3000元-3500元",@"3500元-4000元",
                         @"4000元以上", nil];
    _dealPriceNameType = [NSMutableArray arrayWithObjects:@"出租价格(元)",@"出售价格(万元)",@"不限", nil];
    _priceArray = [NSMutableArray arrayWithObjects:_rentArray,_saleArray,@[], nil];
    
    
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
    _propListApi = [GetPropListApi new];
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    _collectPropApi = [CollectPropApi new];
    
    _filterEntity=[FilterEntity new];
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
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    _filterEntity.sortField = @"";
    _filterEntity.ascending = @"true";
    
    _propListArray = [[NSMutableArray alloc]init];
    
    /// 是否含有委托已审
    if ([_allRoundListPresenter haveTrustsApproved])
    {
        _filterEntity.isTrustsApproved = @"false";
    }

    ///是否含有证件齐全
    if ([_allRoundListPresenter haveCompleteDoc])
    {
        _filterEntity.isCompleteDoc = @"false";
    }

    /// 是否含有委托已审
    if ([_allRoundListPresenter haveTrustProperty])
    {
        _filterEntity.isTrustProperty = @"false";
    }



}

#pragma mark - <MoreFilterInfoDelegate>
- (void)getFilterEntity:(FilterEntity *)entity
{
    
    NSString *price;
    NSString *minString;
    NSString *maxString;
    NSString *typeString;
    
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH, 0);

    if ((_filterEntity.moreFilterMinSalePrice == nil||[_filterEntity.moreFilterMinSalePrice isEqualToString:@""])&&
        (_filterEntity.moreFilterMaxSalePrice == nil||[_filterEntity.moreFilterMaxSalePrice isEqualToString:@""]))
    {
        minString = _filterEntity.moreFilterMinRentPrice;
        maxString = _filterEntity.moreFilterMaxRentPrice;
        typeString = @"出租";
    }
    else
    {
        minString = _filterEntity.moreFilterMinSalePrice;
        maxString = _filterEntity.moreFilterMaxSalePrice;
        
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
    
    //通过tag值找到具体的控件 改变显示内容
    UILabel *label = (UILabel *)[self.view viewWithTag:1000001];
    label.text = price;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:12];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [price boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    if (size.width/2>APP_SCREEN_WIDTH/6)
    {
        size.width = APP_SCREEN_WIDTH/3-4;
    }
    imageView.frame = CGRectMake((APP_SCREEN_WIDTH/3)-((APP_SCREEN_WIDTH/3)/2-(size.width/2))+3, label.center.y-2, 8, 6);
    
    
    
    _filterEntity = entity;
    [_mainTableView headerBeginRefreshing];
}
//判断字符串转为int类型的时候是否为0
- (NSString *)opinionStringFromString:(NSString *)string
{
    
    if ([[string stringByReplacingOccurrencesOfString:@"0" withString:@""] isEqualToString:@""]&&
        ![string isEqualToString:@""])
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
//输入的面积或价格 （判断价格是否为空或者为0 不保存）
- (NSString *)getStringWith:(NSString *)minString and:(NSString*)maxString andType:(NSString*)type
{
    minString = [self opinionStringFromString:minString];
    maxString = [self opinionStringFromString:maxString];
    if ((minString != nil &&maxString != nil) && (![minString isEqualToString:@""] &&![maxString isEqualToString:@""]))
    {
        
        NSString * infoString;
        if ([type isEqualToString:@"出租"])
        {
            infoString = [NSString stringWithFormat:@"%@-%@元",minString,maxString];
        }
        else
        {
            infoString = [NSString stringWithFormat:@"%@-%@万",minString,maxString];
        }
        
        return infoString;
        
        
    }
    else if (minString != nil && ![minString isEqualToString:@""])
    {
        NSString *infoString;
        if ([type isEqualToString:@"出租"])
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
        NSString *infoString;
        if ([type isEqualToString:@"出租"])
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
#pragma mark - <MJRefreshMethod>
//获取FilterEntity里面数组的具体值的value
- (NSMutableArray*)getfilterConditionWith:(NSMutableArray *)array
{
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<array.count; i++)
    {
        SelectItemDtoEntity *entity = array[i];
        [infoArray addObject:entity.itemValue];
    }
    return infoArray;
}

- (NSString *)priceType
{
    SysParamItemEntity *exchangeType = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_TYPE];
    NSString *priceString = [exchangeType.itemList componentsJoinedByString:@""];
    NSString *valueString;
    if ([priceString isEqualToString:@"出租出售租售"])
    {
        valueString = @"";
    }
    else if ([priceString isEqualToString:@"出租租售"])
    {
        valueString = @"4";
    }
    else if ([priceString isEqualToString:@"出售租售"])
    {
        valueString = @"5";
    }
    return valueString;
}

- (void)headerRefreshMethod
{
    [self checkPermission:nil];
    
    [_mainTableView reloadData];
    
    NSString *trustType;
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
    {
        trustType = @"5";
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        trustType = @"4";
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"租售"])
    {
        trustType = @"3";
    }
    else
    {
        trustType = [self priceType];
    }
    
    
    NSString *keyWord = _searchKeyWord;
    
    if ([keyWord contains:@"，"])
    {
        NSRange range;
        range = [keyWord rangeOfString:@"，"];
        
        if (range.location != NSNotFound) {
            
            keyWord = [keyWord substringToIndex:range.location];
            NSLog(@"keyWord = %@",keyWord);
        }
        else
        {
            // Do Nothing
        }
    }
    

    
    NSString *propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    _propListApi.propListTyp = @"5";
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
    _propListApi.searchKeyWord = keyWord;
    _propListApi.isRecommend = _filterEntity.isRecommend;
    _propListApi.pageIndex = @"1";
    _propListApi.hasPropertyKey = _filterEntity.hasPropertyKey;
    _propListApi.estateSelectType = _filterEntity.estateSelectType;
    _propListApi.isTrustsApproved = _filterEntity.isTrustsApproved ? _filterEntity.isTrustsApproved:@"";
    _propListApi.houseNo = _filterEntity.houseNo ? _filterEntity.houseNo : @"";
    _propListApi.isOnlyTrust = _filterEntity.isOnlyTrust;
    
    [_manager sendRequest:_propListApi];

}

- (void)footerRefreshMethod
{
    [self checkPermission:nil];
    
    NSString *curPageNum = [NSString stringWithFormat:@"%@",@(_propListArray.count/10+1)];
    
    NSString *trustType;
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
    {
        trustType = @"5";
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        trustType = @"4";
    }
    else if ([_filterEntity.estDealTypeText isEqualToString:@"租售"])
    {
        trustType = @"3";
    }
    else
    {
        trustType = [self priceType];
    }
    
    
    NSString *keyWord = _searchKeyWord;
    
    if ([keyWord contains:@"，"])
    {
        NSRange range;
        range = [keyWord rangeOfString:@"，"];
        
        if (range.location != NSNotFound) {
            
            keyWord = [keyWord substringToIndex:range.location];
            NSLog(@"keyWord = %@",keyWord);
        }
        else
        {
            // Do Nothing
        }
    }
    
    NSString *propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    _propListApi.propListTyp = @"5";
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
    _propListApi.searchKeyWord = keyWord;
    _propListApi.isRecommend = _filterEntity.isRecommend;
    _propListApi.pageIndex = curPageNum;
    _propListApi.hasPropertyKey = _filterEntity.hasPropertyKey;
    _propListApi.estateSelectType = _filterEntity.estateSelectType;
    _propListApi.isTrustsApproved = _filterEntity.isTrustsApproved ? _filterEntity.isTrustsApproved:@"";
    _propListApi.houseNo = _filterEntity.houseNo ? _filterEntity.houseNo : @"";
    _propListApi.isOnlyTrust = _filterEntity.isOnlyTrust;
    
    [_manager sendRequest:_propListApi];
}

#pragma mark-<EditRefreshDelegate>
- (void)editRefresh:(PropPageDetailEntity *)entity{
    if ([CityCodeVersion isGuangZhou]) {
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

#pragma mark - <UIAlertDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if(tag == NotHavePermissionAlertTag){
        switch (buttonIndex) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }
}



#pragma mark - <FilterViewDelegate>
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
#pragma mark - <FilterViewDelegate>
- (void)requestNeedEntity:(FilterEntity *)entity andType:(BOOL)type{
    
    _filterEntity = entity;
    [self revertAnimation];
    if (type)
    {
        [_mainTableView headerBeginRefreshing];
    }
}
#pragma mark - <还原动画>
- (void)revertAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _filterView.frame = CGRectMake(0, 40, APP_SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    _btnTag = 0;
}

#pragma mark - <TableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _propListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"allRoundListCell";
    
    AllRoundListCell *allRoundListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!allRoundListCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"AllRoundListCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        allRoundListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    PropertysModelEntty *propModelEntity ;
    
    if (_propListArray.count != 0) {
        
        propModelEntity = [_propListArray objectAtIndex:indexPath.row];
        
        
        // 是否为澳盘
        if ([propModelEntity.isMacau boolValue]) {
            allRoundListCell.propImageAO.hidden = NO;
        }else{
            allRoundListCell.propImageAO.hidden = YES;
        }
        
        
        if (propModelEntity.buildingName) {
            //buildingName不为空
            allRoundListCell.propTitleLabel.text = [NSString stringWithFormat:@"%@ %@",propModelEntity.estateName,propModelEntity.buildingName];
            
        }else{
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
        
        if(tagCount == 2)
        {
            allRoundListCell.tag1.hidden = NO;
            allRoundListCell.tag2.hidden = NO;
           
            allRoundListCell.tag1.text = @"押";
            allRoundListCell.tag2.text = [_allRoundListPresenter getTagString];
            
        }else if(tagCount == 1){
            allRoundListCell.tag1.hidden = YES;
            allRoundListCell.tag2.hidden = NO;
            
            if(propModelEntity.entrustKeyId){
                allRoundListCell.tag2.text = @"押";
            }
            else
            {
                allRoundListCell.tag1.text = @"押";
                allRoundListCell.tag2.text = [_allRoundListPresenter getTagString];
            }
        }else{
            allRoundListCell.tag1.hidden = YES;
            allRoundListCell.tag2.hidden = YES;
        }
        
        if (propModelEntity.photoPath &&
            ![propModelEntity.photoPath isEqualToString:@""]) {
            
            [CommonMethod setImageWithImageView:allRoundListCell.propImgView
                                    andImageUrl:propModelEntity.photoPath
                        andPlaceholderImageName:@"defaultEstateBg_img"];
        }else{
            
            [allRoundListCell.propImgView setImage:[UIImage imageNamed:@"defaultEstateBg_img"]];
        }
        
        allRoundListCell.propSupportLabel.text = [NSString stringWithFormat:@"%@  %@",
                                                  propModelEntity.houseType?propModelEntity.houseType:@"",
                                                  propModelEntity.floor?propModelEntity.floor:@""];
        allRoundListCell.propDetailMsgLabel.text = [NSString stringWithFormat:@"%@  %@",
                                                    propModelEntity.houseDirection?propModelEntity.houseDirection:@"",
                                                    propModelEntity.propertyType?propModelEntity.propertyType:@""];
        
        //面积
        if ([_allRoundListPresenter haveAreaUnit])
        {
            allRoundListCell.propAcreage.text = propModelEntity.square;
        }
        else
        {
            allRoundListCell.propAcreage.text = [NSString stringWithFormat:@"%@㎡",propModelEntity.square];
        }
        
        allRoundListCell.propImageCntLabel.text = [NSString stringWithFormat:@"%@",propModelEntity.realSurveyCount];
        NSString *propImgCntStr = [NSString stringWithFormat:@"%@10",propModelEntity.realSurveyCount];
        CGFloat propImgCntWidth = [propImgCntStr getStringWidth:[UIFont fontWithName:FontName
                                                                                size:10.0]
                                                         Height:14.0
                                                           size:10.0];
        if (propImgCntWidth >= 12) {
            
            allRoundListCell.propImgCntViewWidth.constant = 26 + (propImgCntWidth-12);
        }else{
            
            allRoundListCell.propImgCntViewWidth.constant = 26;
        }
        
        allRoundListCell.propTypeSignImageView.hidden = NO;
        
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

        if (propModelEntity.trustType.integerValue == 1 ||
            propModelEntity.trustType.integerValue == 3) {
            
            /**
             *  售价超过“亿”，转换单位，数据是以“万”为单位
             *
             */
            
            if (propModelEntity.salePrice.floatValue >= 10000) {
                
                propPriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      propModelEntity.salePrice.floatValue/10000];
                propPriceUnitStr = @"亿";
            }else{
                
                propPriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      propModelEntity.salePrice.floatValue];
                propPriceUnitStr = @"万";
            }
            if ([propPriceResultStr rangeOfString:@".00"].location != NSNotFound) {
                
                //不是有效的数字，去除小数点后的0
                propPriceResultStr = [propPriceResultStr
                                      substringToIndex:propPriceResultStr.length - 3];
            }
            
        }else{
            
            propPriceResultStr = [NSString stringWithFormat:@"%g",propModelEntity.rentPrice.floatValue];
            propPriceUnitStr = @"元/月";
        }
        
        allRoundListCell.propPriceLabel.text = [NSString stringWithFormat:@"%@%@",
                                                propPriceResultStr,
                                                propPriceUnitStr];
        
        /**
         *  出售、租售需要显示均价(售价是以万为单位的)
         */
        NSString *propAvgPriceStr;
        NSString *propAvgPriceUnitStr;
        
        if (propModelEntity.trustType.integerValue == 1 ||
            propModelEntity.trustType.integerValue == 3) {
            
            CGFloat propAvgPriceValue = propModelEntity.salePriceUnit.floatValue;
            
            if (propAvgPriceValue > 10000) {
                
                propAvgPriceValue = propAvgPriceValue/10000;
                
                propAvgPriceStr = [NSString stringWithFormat:@"%.2f",
                                   propAvgPriceValue];
                propAvgPriceUnitStr = [NSString stringWithFormat:@"万/㎡"];
            }else{
                
                propAvgPriceStr = [NSString stringWithFormat:@"%.2f",
                                   propAvgPriceValue];
                propAvgPriceUnitStr = [NSString stringWithFormat:@"元/㎡"];
            }
            
            if ([propAvgPriceStr rangeOfString:@".00"].location != NSNotFound) {
                
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
        }else{
            
            allRoundListCell.propAvgPriceLabel.text = @"";
        }
        
        
        /**
         *  设置列表中的标签的值
         */
        allRoundListCell.propFirstTagBtn.hidden = YES;
        allRoundListCell.propSecondTagBtn.hidden = YES;
        allRoundListCell.propThreeTagBtn.hidden = YES;
        
        if (propModelEntity.propertyTags.count == 1) {
            
            PropertyTagEntity *firstTagEntity = [propModelEntity.propertyTags objectAtIndex:0];
            
            allRoundListCell.propFirstTagBtn.hidden = NO;
            [allRoundListCell.propFirstTagBtn setTitle:firstTagEntity.tagName
                                              forState:UIControlStateNormal];
            [allRoundListCell.propFirstTagBtn setBackgroundColor:[CommonMethod transColorWithHexStr:firstTagEntity.styleColor]];
            
            CGFloat firstBtnWidth = [firstTagEntity.tagName getStringWidth:[UIFont fontWithName:FontName size:11.0]
                                                                    Height:15
                                                                      size:11.0];
            allRoundListCell.propFirstTagBtnWidth.constant = firstBtnWidth + 10 ;
            
        }else if (propModelEntity.propertyTags.count == 2){
            
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
            
        }else if (propModelEntity.propertyTags.count >= 3){
            
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
    if ([_allRoundListPresenter isCurrencyDataView])
    {
        AllRoundDetailViewController *allRoundDetailVC = [[AllRoundDetailViewController alloc]initWithNibName:@"AllRoundDetailViewController" bundle:nil];
        allRoundDetailVC.myDelegate = self;
        allRoundDetailVC.propKeyId = propModelEntity.keyId;
        allRoundDetailVC.propTrustType = [NSString stringWithFormat:@"%@",propModelEntity.trustType];
        allRoundDetailVC.propNameStr = [NSString stringWithFormat:@"%@",propModelEntity.estateName];
        allRoundDetailVC.propBuildingName = [NSString stringWithFormat:@"%@",propModelEntity.buildingName];
        allRoundDetailVC.propHouseNo = [NSString stringWithFormat:@"%@",propModelEntity.houseNo];
        allRoundDetailVC.propModelEntity = propModelEntity;
        allRoundDetailVC.takeSeeCount = [NSString stringWithFormat:@"%@",propModelEntity.takeToSeeCount];
        
        [self.navigationController pushViewController:allRoundDetailVC
                                             animated:YES];
        _selectRow = indexPath.row;

    }else{
        // 横琴 澳门
        HQAllRoundDetailVC *allRoundDetailVC = [[HQAllRoundDetailVC alloc]initWithNibName:@"HQAllRoundDetailVC" bundle:nil];
        allRoundDetailVC.propKeyId = propModelEntity.keyId;
        allRoundDetailVC.propTrustType = [NSString stringWithFormat:@"%@",propModelEntity.trustType];
        allRoundDetailVC.propNameStr = [NSString stringWithFormat:@"%@",propModelEntity.estateName];
        allRoundDetailVC.propBuildingName = [NSString stringWithFormat:@"%@",propModelEntity.buildingName];
        allRoundDetailVC.propHouseNo = [NSString stringWithFormat:@"%@",propModelEntity.houseNo];
        allRoundDetailVC.propModelEntity = propModelEntity;
        
        [self.navigationController pushViewController:allRoundDetailVC
                                             animated:YES];
    }


}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:indexPath.row];
    
    [self showLoadingView:nil];
    
    _collectPropApi.propKeyId = propModelEntity.keyId;
    _cancleCollectKeyId = propModelEntity.keyId;
    _collectPropApi.isCollect = NO;
    [_manager sendRequest:_collectPropApi];
    
    
}

#pragma mark - <ClickHeadImageMethod>
- (void)clickHeadImageMethod:(UIButton *)button
{
    NSInteger selectPropItemIndex = button.tag - PropHeadImageBtnTag;
    
    PropertysModelEntty *propModelEntity = [_propListArray objectAtIndex:selectPropItemIndex];
    
    NSString *realPhotoPath = [NSString stringWithFormat:@"%@",propModelEntity.photoPath];
    NSString *realSurveyCount = [NSString stringWithFormat:@"%@",propModelEntity.realSurveyCount];
    
    if (realPhotoPath &&
        ![realPhotoPath isEqualToString:@""] &&
        realSurveyCount.integerValue != 0) {
        // 查看实勘
        BOOL isAble = [_allRoundListPresenter canViewUploadrealSurvey:propModelEntity.departmentPermissions];

        if (isAble)
        {
            PhotoDownLoadImageViewController *photoDownImageVC = [[PhotoDownLoadImageViewController alloc]initWithNibName:@"PhotoDownLoadImageViewController" bundle:nil];
            photoDownImageVC.propKeyId = propModelEntity.keyId;
            [self.navigationController pushViewController:photoDownImageVC
                                                 animated:YES];
        }else{
            showMsg(@(NotHavePermissionTip));
        }
        
    }else{
        
        //上传实勘
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

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[PropListEntity class]]) {
        [_mainTableView reloadData];

        PropListEntity *propListEntity = [DataConvert convertDic:data toEntity:modelClass];;
        
        //更新用户权限
        if(propListEntity.permisstionsModel != nil){
            
            PermisstionsEntity *permisson = [[PermisstionsEntity alloc]init];
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
            
            if([AgencyUserPermisstionUtil permissionIsEmpty]){
                [self logout];
            }
        }
        
        [self endRefreshWithTableView:_mainTableView];
        
        [self checkPermission:nil];
        
        if(!propListEntity.flag)
        {
            showMsg(propListEntity.errorMsg);
            return;
        }
        
        if (_mainTableView.headerRefreshing) {
            
            [_propListArray removeAllObjects];
        }
        
        if (propListEntity.propertysModel.count < 10 ||
            !propListEntity.propertysModel) {
            
            _mainTableView.footerHidden = YES;
        }else{
            
            _mainTableView.footerHidden = NO;
        }
        
        [_propListArray addObjectsFromArray:propListEntity.propertysModel];
        
        [_mainTableView reloadData];
        
        
    }else if ([modelClass isEqual:[CheckRealProtectedEntity class]])
    {
        //点击上传实勘
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];
        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
        if(isAble){
            
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _clickImageHouseID;
            uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount]) {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount]) {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            [self.navigationController pushViewController:uploadRealSurveyVC
                                                 animated:YES];
        }else{
            showMsg(@(NotHavePermissionTip));
        }

    }else if([modelClass isEqual:[AgencyBaseEntity class]]){
        //取消收藏
        
        AgencyBaseEntity *collectResultEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (collectResultEntity.flag) {
            
            [CustomAlertMessage showAlertMessage:@"取消收藏成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            for (PropertysModelEntty *entity in _propListArray) {
                if ([entity.keyId isEqualToString:_cancleCollectKeyId]) {
                    [_propListArray removeObject:entity];
                    _cancleCollectKeyId = nil;
                    [_mainTableView reloadData];
                    return;
                }
            }
        }
    }
}


- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
}


@end
