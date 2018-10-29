//
//  EstateListVC.m
//  APlus
//
//  Created by 张旺 on 2017/10/18.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "EstateListVC.h"
#import "EstateListCell.h"
#import "APFilterView.h"
#import "EventView.h"
#import "CentaShadowView.h"
#import "APSortView.h"
#import "LogOffUtil.h"
#import "GetPropListApi.h"
#import "CheckRealProtectedDurationApi.h"
#import "DataBaseOperation.h"
#import "PropListEntity.h"
#import "CollectPropApi.h"
#import "GetTrustorsApi.h"
#import "CheckRealProtectedEntity.h"
#import "UploadRealSurveyViewController.h"
#import "PropertyDetailVC.h"
#import "CustomActionSheet.h"
#import "FilterListViewController.h"
#import "AppendInfoViewController.h"
#import "PhotoDownLoadImageViewController.h"
#import "NewSearchVC.h"

#import "CallRealPhoneLimitUtil.h"


#import "AllRoundListZJPresenter.h"
#import "AllRoundDetailPresenter.h"

#import "MoreFilterBasePresenter.h"
#import "PropKeyViewController.h"

#define TRUE_String                     @"true"
#define FALSE_String                    @"false"
#define RentPrice                       @"RentPrice"    // 租价
#define SalePrice                       @"SalePrice"    // 售价
#define TableViewHeight                 98*NewRatio
#define TableViewButtomY                49
#define TableViewHeaderHeight           25
#define CallRealPhoneAlertTag           2000            // 拨打真实手机号剩余次数弹框
#define AddFollowActionTag              3000            // 新增跟进

@interface EstateListVC ()<UITableViewDelegate,UITableViewDataSource,AllRoundListViewProtocol,AllRoundFilterCustomViewDelegate
,FilterListDelegate,UIPickerViewDelegate,UIPickerViewDataSource,doneSelect
,TapDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    __weak IBOutlet UILabel *_bottomFilterLabel;
    __weak IBOutlet UIButton *_numberStandard;                       // 数标
    __weak IBOutlet UIView *_bottomView;
    
    __weak IBOutlet NSLayoutConstraint *_sortBtnConstraint;          // Constraint
    __weak IBOutlet NSLayoutConstraint *_backTopBtnConstraint;       // 返回顶部Constraint
    //    __weak IBOutlet NSLayoutConstraint *_mainTableViewButtomHeight;  // tableView底部高度
    
    GetPropListApi *_estateListApi;
    CheckRealProtectedDurationApi *_checkRealProtectedApi;
    DataBaseOperation *_dataBaseOperation;
    FilterEntity *_filterEntity;
    AllRoundListBasePresenter *_allRoundListPresenter;
    AllRoundDetailPresenter *_propDetailPresenter;
    GetPropListApi *_propListApi;
    APFilterView * _filterView;
    CentaShadowView *_shadowView;
    EventView *_eventView;
    AllRoundFilterCustomView *_customView;
    PropertysModelEntty * _estateEntty;
    MoreFilterBasePresenter *_moreFilterPresenter;
    
    UIWindow * _mainWindow;
    NSArray *_SavefilterArray;                  // 保存筛选条件的数组
    NSMutableArray *_estateListArray;           // 房源列表数组
    NSMutableArray *_allInfoArray;              // 数据库保存的信息
    UIButton *_searchRightBtn;                  // 搜索框右部语音按钮
    UIButton *_searchTextBtn;                   // 搜索框文字搜索按钮
    UIButton *_navRightBtn;                     // 导航栏右边按钮
    NSString *_currentShowText;                 // 第一次筛选信息
    NSString *_clickImageHouseID;               // 点击当前实堪image的index
    NSString *_currentSelectString;             // 默认选中的名字
    NSString *_mobile;        // 要拨打的联系方式
    
    NSInteger _recordCount;                     // 房源列表的总数量
    NSInteger _recordIndex;                     // 当前滑到的下标
    NSInteger _mainTableViewButtomY;            // tableView位置
    NSInteger _selectIndex;   // 选择的联系人索引
    
    BOOL _isHeaderRefresh;                      // 是否是下拉刷新
    BOOL _hasTouched;                           // 是否已点击搜索
    BOOL _isSendService;
    BOOL _isSetttingName;                       // 是否更改名字
    BOOL _isSearching;                          // 是否正在搜索状态
    BOOL _collectBtnIsSelect;                   // 收藏按钮是否选中
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightCon;


@end

@implementation EstateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"房源列表"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:nil
                                            sel:nil]];
    
    
    _selectRow = -1;
    _isNewVC = YES;
    
    [self checkPermission:^(NSString *permission) {
        [self initPresenter];
        [self initFilterEntity];
        
        if (self.isPropList)
        {
            // 从数据库中获取已有的筛选数据
            if (!self.isNewProInThreeDay)
            {
                _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
                _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
            }
            
            NSInteger allCount = _allInfoArray.count;
            
            for (NSInteger i = 0; i < allCount; i++)
            {
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                       fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                    error:nil];
                if (filterEntity.isCurrent)
                {
                    _bottomFilterLabel.textColor = YCTextColorBlack;
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                    
                    _filterEntity = filterEntity;
                    _currentShowText = entity.showText;
                    // 从首页进入
                    if([_propType isEqualToString:WARZONE])
                    {
                        // 搜索条件
                        NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
                        [_searchTextBtn setTitle:seachName ? seachName : @"请输入城区、片区、楼盘名" forState:UIControlStateNormal];
                        
                        if (seachName.length > 0)
                        {
                            _searchKeyWord = seachName;
                            [self changeSearchBarRightBtnImageWithSearching:YES];
                        }
                    }
                }
            }
            
            if ([_bottomFilterLabel.text isEqualToString:@"暂无默认搜索"])
            {
                _bottomFilterLabel.textColor = YCTextColorAuxiliary;
                // 没有默认搜索房源状态默认选中
                if ([[_moreFilterPresenter getValueArray][2] firstObject])
                {
                    [_filterEntity.roomStatus addObject:[[_moreFilterPresenter getValueArray][2]firstObject]];
                }
            }
        }
        
        [self initView];
        [self initData];
        [self showLoadingView:nil];
        [self headerRefreshMethod];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [_mainTableView reloadData];
    
    _hasTouched = NO;
    
    if (self.isPropList)
    {
        if (!self.isNewProInThreeDay)
        {
            _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
        }
        NSInteger allArrayCount = _allInfoArray.count;
        // 判断是否清空筛选数据
        if (allArrayCount == 0)
        {
            _bottomFilterLabel.text = @"暂无默认搜索";
            _bottomFilterLabel.textColor = YCTextColorAuxiliary;
        }
        // 如果默认更改了名字 就走此方法
        if (_isSendService)
        {
            for (NSInteger i = 0; i <allArrayCount; i++)
            {
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                       fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                    error:nil];
                if (filterEntity.isCurrent)
                {
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                    _bottomFilterLabel.textColor = YCTextColorBlack;
                    _filterEntity = filterEntity;
                    _currentShowText = entity.showText;
                }
            }
        }
        
        if (_isSetttingName)
        {
            for (NSInteger i = 0; i < allArrayCount; i++)
            {
                DataFilterEntity *entity = _allInfoArray[i];
                FilterEntity *filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                                       fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                                    error:nil];
                if ([filterEntity isEqual: _filterEntity])
                {
                    _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
                    _bottomFilterLabel.textColor = YCTextColorBlack;
                }
            }
        }
    }
    
    if ([_propType isEqualToString:WARZONE])
    {
        //        [_mainTableView reloadData];
    }
    
    // 底部
    NSString *nameString = [CommonMethod getUserdefaultWithKey:NameString];
    if (nameString && !self.isNewProInThreeDay)
    {
        _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",nameString];
        _bottomFilterLabel.textColor = YCTextColorBlack;
    }
    else
    {
        _bottomFilterLabel.text = @"暂无默认搜索";
        _bottomFilterLabel.textColor = YCTextColorAuxiliary;
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    
    _shadowView.hidden = YES;
    _eventView.hidden = YES;
}

- (void)back
{
    if (self.moduleSearchType == HomePageSearch)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - *****初始化界面******

- (void)initView
{
    // 创建筛选view
    [self creatFilterView];
    // 隐藏cell分割线
    _mainTableView.separatorStyle = NO;
    
    if (_isPropList)
    {
        _bottomView.hidden = NO;
        _mainTableViewButtomY = 0;
    }
    else
    {
        
        _bottomView.hidden = YES;
        _mainTableViewButtomY = IS_iPhone_X ? TableViewButtomY+34:TableViewButtomY;
        _backTopBtnConstraint.constant = 11 - _mainTableViewButtomY;
        _sortBtnConstraint.constant = 100 - _mainTableViewButtomY;
    }
    
    // 创建右部语音搜索按钮
    _searchRightBtn = [self createVoiceSearchBtnWithSelector:@selector(clickVoiceSearch)];
    // 创建文字搜索按钮
    _searchTextBtn = [self createTextSearchBtnWithSelector:@selector(clickTextSearch)];
    
    // 创建搜索框
    [self createTopSearchBarViewWithTextSearchBtn:_searchTextBtn
                                      andRightBtn:_searchRightBtn
                                   andPlaceholder:@"请输入城区、片区、楼盘名"];
    
    // 判断是否从搜索页进入到房源列表
    _isSearching = _isFromSearchPage;
    // 判断是否有搜索条件
    NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
    if (seachName.length > 0 || _isSearching)
    {
        [self changeSearchBarRightBtnImageWithSearching:YES];
    }
    else
    {
        [self changeSearchBarRightBtnImageWithSearching:NO];
    }
    
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor blackColor];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    _mainTableView.mj_footer.hidden = YES;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    //加阴影
    _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowRadius = 10;
    _bottomView.layer.shadowOpacity = 0.2;
    
    //设置底部View的高度
    self.bottomViewHeightCon.constant = BOTTOM_SAFE_HEIGHT + 50;
    
}

- (void)initPresenter
{
    
    _allRoundListPresenter = [[AllRoundListZJPresenter alloc] initWithDelegate:self];
    
    _propDetailPresenter = [[AllRoundDetailPresenter alloc] initWithDelegate:self];
    
    
}

- (void)creatFilterView
{
    _filterView = [[APFilterView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, FilterViewHeight)];
    
    NSString *priceText = _filterEntity.rentPriceText;
    if ([self isBlankString:priceText]) priceText = _filterEntity.salePriceText;
    if([self isBlankString:priceText]) priceText = @"价格";
    
    WS(weakSelf);
    
    [_filterView createFiterViewWithItemTitleArray:@[_filterEntity.estDealTypeText,priceText,_filterEntity.tagText,@"更多"] andDataSourceArray:[self getDataArray] andFiterType:FilterEstateType andBlock:^(NSString *fiterStr) {
        
        [weakSelf showLoadingView:nil];
        [weakSelf setTableViewContentOff];
        [weakSelf headerRefreshMethod];
        NSLog(@"%@",fiterStr);
        
    }];
    
    [self.view addSubview:_filterView];
}

- (NSArray *)getDataArray
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
    
    NSMutableDictionary * priceDic = [NSMutableDictionary dictionary];
    
    NSArray *rentArray = @[@"不限",@"2000元以下",@"2000~3000元",@"3000~5000元",@"5000~8000元",@"8000~12000元",@"12000元以上"];
    NSArray *saleArray = @[@"不限",@"150万以下",@"150~200万",@"200~250万",@"250~350万",@"350~500万",@"500~700万",@"700~1000万",@"1000万以上"];
    
    if ([string isEqualToString:@"出租出售租售"])
    {
        allEntity.itemValue = @"";
        [priceDic setValue:rentArray forKey:@"出租价格(元)"];
        [priceDic setValue:saleArray forKey:@"出售价格(万)"];
    }
    else if ([string isEqualToString:@"出租租售"])
    {
        allEntity.itemValue = @"4";
        [priceDic setValue:rentArray forKey:@"出租价格(元)"];
    }
    else if ([string isEqualToString:@"出售租售"])
    {
        allEntity.itemValue = @"5";
        [priceDic setValue:saleArray forKey:@"出售价格(万)"];
    }
    
    [nameArray insertObject:allEntity atIndex:0];
    
    
    NSArray *dealTypeArray = [NSArray arrayWithArray:nameArray];
    
    NSArray *tagTextArray =[_allRoundListPresenter getTagTextArray];
    
    NSArray * dataArray = @[dealTypeArray,priceDic,tagTextArray];
    
    return dataArray;
}

- (void)initFilterEntity
{
    _filterEntity = [FilterEntity new];
    _filterEntity.estDealTypeText = _filterEntity.estDealTypeText?_filterEntity.estDealTypeText:@"全部";
    _filterEntity.isRecommend = @"false";
    _filterEntity.tagText = _filterEntity.tagText?_filterEntity.tagText:@"标签";
    _filterEntity.isNewProInThreeDay = self.isNewProInThreeDay ? @"true":@"false";
    _filterEntity.tagText = self.isNewProInThreeDay ? @"新上房源":_filterEntity.tagText;
    _filterEntity.isOnlyTrust = @"false";
    _filterEntity.hasPropertyKey = @"false";
    _filterEntity.roomType = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.roomStatus = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.roomSituation = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.roomLevels = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.direction = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.propTag = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.buildingType = [NSMutableArray arrayWithCapacity:0];
    _filterEntity.sortField = @"";
    _filterEntity.ascending = TRUE_String;
}

- (void)initData
{
    _propListApi = [GetPropListApi new];
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    _estateListArray = [[NSMutableArray alloc] init];
    _recordIndex = 1;
    
    // 判断是否从搜索页进入到房源列表
    //    _isSearching = _isFromSearchPage;
    
    _estateListApi = [GetPropListApi new];
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    
    [_filterView setFilterEntity:_filterEntity];
    
    
    
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    
    if (self.moduleSearchType == HomePageSearch)
    {
        // 从首页右上角进入
        _filterEntity.estateSelectType = _estateSelectType;
        return;
    }
    
    NSString *seachName = [CommonMethod getUserdefaultWithKey:KeyWord];
    _searchKeyWord = seachName ? seachName : @"";
    
    if ([_propType isEqualToString:CONTRIBUTION])
    {
        // 房源贡献
        _searchKeyWord = @"";
    }
}

#pragma mark - *******网络请求********

- (void)headerRefreshMethod
{
    _realSearchKeyWord = _searchKeyWord;
    if ([_realSearchKeyWord contains:@"，"])
    {
        NSRange range;
        range = [_realSearchKeyWord rangeOfString:@"，"];
        
        if (range.location != NSNotFound)
        {
            _realSearchKeyWord = [_realSearchKeyWord substringToIndex:range.location];
        }
        else
        {
            // Do Nothing
        }
    }
    
    [self commandRequestApi];
    _propListApi.pageIndex = @"1";
    _propListApi.isOnlyTrust = _filterEntity.isOnlyTrust;
    _propListApi.isHasRegisterTrusts = _filterEntity.isTrustProperty ? _filterEntity.isTrustProperty : @"";
    
    _isHeaderRefresh = YES;
    [_manager sendRequest:_propListApi];
}

- (void)footerRefreshMethod
{
    [self commandRequestApi];
    
    _propListApi.pageIndex = [NSString stringWithFormat:@"%@",@(_estateListArray.count / 10 + 1)];
    
    _isHeaderRefresh = NO;
    [_manager sendRequest:_propListApi];
}

- (void)commandRequestApi
{
    [self checkPermission:nil];
    
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
    
    // 房源编号跟房号
    if (self.houseNo.length > 0 && !_filterEntity.houseNo)
    {
        _filterEntity.houseNo = self.houseNo;
    }
    
    if (self.propNo.length > 0 && !_filterEntity.propertyNo)
    {
        _filterEntity.propertyNo = self.propNo;
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
    _propListApi.propertyNo = _filterEntity.propertyNo;//@"";
    _propListApi.trustType = trustType;
    _propListApi.scope = propScopeStr;
    _propListApi.searchKeyWord = _filterEntity.propertyNo.length > 0 ? @"":_realSearchKeyWord;
    _propListApi.isRecommend = _filterEntity.isRecommend;
    _propListApi.hasPropertyKey = _filterEntity.hasPropertyKey;
    _propListApi.estateSelectType = _filterEntity.estateSelectType;
    _propListApi.isPanorama = _filterEntity.isPanorama;
    _propListApi.isNoCall = _filterEntity.isNoCall;
    _propListApi.hasPropertyKey = _filterEntity.isPropertyKey;
    _propListApi.isRealSurvey = _filterEntity.isRealSurvey;
    _propListApi.sortField = _filterEntity.sortField;
    _propListApi.ascending = _filterEntity.ascending;
    _propListApi.houseNo = _filterEntity.houseNo ? _filterEntity.houseNo : @"";
    _propListApi.isCredentials = _filterEntity.isCompleteDoc ? _filterEntity.isCompleteDoc : @"";
    _propListApi.isTrustsApproved = _filterEntity.isTrustsApproved ? _filterEntity.isTrustsApproved : @"";
}

#pragma mark - Button Click

/// 点击语音搜索
- (void)clickVoiceSearch
{
    NewSearchVC *searchVC = [[NewSearchVC alloc]initWithNibName:@"NewSearchVC"
                                                         bundle:nil];
    searchVC.moduleSearchType = AllRoundSearch;
    searchVC.block = ^(SearchPropDetailEntity *entity,BOOL isEstateNo)
    {
        [self showLoadingView:nil];
        
        _filterEntity.propertyNo = @"";
        // 是否搜索房源编号
        if (isEstateNo)
        {
            _filterEntity.propertyNo = entity.itemText;
            _searchKeyWord = entity.itemText;
        }
        // 是否可以搜索房号
        if ([_allRoundListPresenter canSearchHouseNo])
        {
            _filterEntity.houseNo = entity.houseNo;
        }
        
        _filterEntity.estateSelectType = entity.extendAttr;
        if (entity.itemValue.length <=  0)
        {
            _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
        }
        
        if (![NSString isNilOrEmpty:entity.houseNo])
        {
            _searchKeyWord = [NSString stringWithFormat:@"%@，%@",entity.itemValue,entity.houseNo];
        }
        else
        {
            _searchKeyWord = entity.itemValue;
        }
        
        [self changeSearchBarRightBtnImageWithSearching:YES];
        [self headerRefreshMethod];
    };
    
    searchVC.isOpenVoice = YES;
    searchVC.view.clipsToBounds = YES;
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
}


/// 点击文本框搜索
- (void)clickTextSearch
{
    NewSearchVC *searchVC = [[NewSearchVC alloc]initWithNibName:@"NewSearchVC"
                                                         bundle:nil];
    searchVC.moduleSearchType = AllRoundSearch;
    searchVC.block = ^(SearchPropDetailEntity *entity,BOOL isEstateNo)
    {
        [self showLoadingView:nil];
        
        _filterEntity.propertyNo = @"";
        // 是否搜索房源编号
        if (isEstateNo)
        {
            _filterEntity.propertyNo = entity.itemText;
            _searchKeyWord = entity.itemText;
        }
        
        
        _filterEntity.houseNo = entity.houseNo;
        
        
        _filterEntity.estateSelectType = entity.extendAttr;
        if (entity.itemText.length <=  0)
        {
            _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
        }
        
        if (![NSString isNilOrEmpty:entity.houseNo])
        {
            _searchKeyWord = [NSString stringWithFormat:@"%@，%@",entity.itemText,entity.houseNo];
        }
        else
        {
            _searchKeyWord = entity.itemText;
        }
        
        [self changeSearchBarRightBtnImageWithSearching:YES];
        [self headerRefreshMethod];
    };
    
    [self.navigationController pushViewController:searchVC
                                         animated:YES];
}

/// 点击导航栏右边更多按钮
- (void)clickRightBtnItem:(UIButton *)button
{
    _shadowView.hidden = NO;
    _eventView.hidden = NO;
    
}

/// 房源排序
- (IBAction)sortEstateClick:(id)sender
{
    if ([_filterEntity.estDealTypeText isEqualToString:@"出售"]||[_filterEntity.estDealTypeText isEqualToString:@"出租"])
    {
        if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
        {
            _filterEntity.sortField = SalePrice;
            
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
        
        [self showLoadingView:nil];
        [self headerRefreshMethod];
        return;
    }
    
    APSortView *sortView = [[APSortView alloc] initWithFrame:MainScreenBounds];
    NSArray * sortArray = @[@"默认排序",@"售价从大到小",@"售价从小到大",@"租价从大到小",@"租价从小到大"];
    [sortView showSortViewWithSortDataArr:sortArray andSelectData:[self getPriceAscendingStr] andCompleteBlock:^(NSString *sortStr) {
        
        NSInteger selectIndex = [sortArray indexOfObject:sortStr];
        
        switch (selectIndex) {
            case 0:
                // 恢复默认排序
                _filterEntity.sortField = @"";
                _filterEntity.ascending = TRUE_String;
                break;
                
            case 1:
                // 售价从大到小
                _filterEntity.sortField = SalePrice;
                _filterEntity.ascending = FALSE_String;
                break;
                
            case 2:
                // 售价从小到大
                _filterEntity.sortField = SalePrice;
                _filterEntity.ascending = TRUE_String;
                break;
                
            case 3:
                // 租价从大到小
                _filterEntity.sortField = RentPrice;
                _filterEntity.ascending = FALSE_String;
                break;
                
            case 4:
                // 租价从小到大
                _filterEntity.sortField = RentPrice;
                _filterEntity.ascending = TRUE_String;
                break;
                
            default:
                break;
        }
        
        [self showLoadingView:nil];
        [self headerRefreshMethod];
    }];
}

/// 保存搜索
- (IBAction)saveSearchClick:(id)sender
{
    _allInfoArray = [_dataBaseOperation selectAllFilterCondition];
    if (_allInfoArray.count>= 10)
    {
        [CustomAlertMessage showAlertMessage:@"最多可保存10条搜索条件记录,当前已达到上限!\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
        return;
    }
    
    //玩的太高级了，直接new了个window....，降级下吧，
    //    _mainWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    //    NSArray * array = [[NSBundle mainBundle]loadNibNamed:@"AllRoundFilterCustomView" owner:nil options:nil];
    //    _customView = [array firstObject];
    //    _customView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    //    _customView.delegate = self;
    //    _customView.searchName = _searchKeyWord;
    //    [_customView creatView];
    //    [_mainWindow makeKeyAndVisible];
    //    [_mainWindow addSubview:_customView];
    
    //陈行修改
    _customView = [[[NSBundle mainBundle]loadNibNamed:@"AllRoundFilterCustomView" owner:nil options:nil] firstObject];
    _customView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    _customView.delegate = self;
    _customView.searchName = _searchKeyWord;
    [_customView creatView];
    [self.navigationController.view addSubview:_customView];
    
    // 展示具体筛选数据
    _SavefilterArray = [[self getFilterConditionString] componentsSeparatedByString:@","];
    [_customView getTableViewArray:_SavefilterArray];
}

/// 进入筛选条件列表
- (IBAction)pushSearchList:(UIButton *)sender
{
    FilterListViewController *filterList = [[FilterListViewController alloc]initWithNibName:@"FilterListViewController"    bundle:nil];
    filterList.delegate = self;
    filterList.currentSelectName = _currentSelectString;
    [self.navigationController pushViewController:filterList animated:YES];
}

/// 返回顶部
- (IBAction)backTopClick:(id)sender
{
    [_mainTableView setContentOffset:CGPointZero animated:YES];
}

/// 切换搜索框右部按钮状态和触发事件（搜索、未搜索）
- (void)changeSearchBarRightBtnImageWithSearching:(BOOL)isSearchIng
{
    if (isSearchIng && _searchKeyWord.length > 0)
    {
        [_searchTextBtn setTitle:_searchKeyWord forState:UIControlStateNormal];
        
        [_searchRightBtn removeTarget:self
                               action:@selector(clickVoiceSearch)
                     forControlEvents:UIControlEventTouchUpInside];
        [_searchRightBtn addTarget:self
                            action:@selector(clearSearchTextContent)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_searchRightBtn setImage:[UIImage imageNamed:@"nav_close_btn_gray"]
                         forState:UIControlStateNormal];
    }
    else
    {
        [_searchRightBtn removeTarget:self
                               action:@selector(clearSearchTextContent)
                     forControlEvents:UIControlEventTouchUpInside];
        [_searchRightBtn addTarget:self
                            action:@selector(clickVoiceSearch)
                  forControlEvents:UIControlEventTouchUpInside];
        [_searchRightBtn setImage:[UIImage imageNamed:@"语音2"]
                         forState:UIControlStateNormal];
        [_searchTextBtn setTitle:@"请输入城区、片区、楼盘名" forState:UIControlStateNormal];
    }
    
    _isSearching = !isSearchIng;
}

/// 点击清除搜索内容按钮
- (void)clearSearchTextContent
{
    [_searchTextBtn setTitle:@"请输入城区、片区、楼盘名" forState:UIControlStateNormal];
    _searchKeyWord = @"";
    _filterEntity.houseNo = @"";
    _filterEntity.propertyNo = @"";
    _filterEntity.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    
    [self changeSearchBarRightBtnImageWithSearching:NO];
    [self showLoadingView:nil];
    [self headerRefreshMethod];
}

#pragma mark - PrivateMethod

- (void)logout
{
    // 用户退出登录后清除用户信息
    [LogOffUtil clearUserInfoFromLocal];
    
    [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
}

- (void)checkPermission:(HaveMenuPermissionBlock)block
{
    BOOL permission = NO;
    if ([_propType isEqualToString:FAVORITE]) {
        // 我的收藏
        permission = [self checkShowViewPermission:MENU_PROPERTY_MY_FAVORITE andHavePermissionBlock:block];
    } else if ([_propType isEqualToString:WARZONE]) {
        // 房源列表
        permission = [self checkShowViewPermission:MENU_PROPERTY_WAR_ZONE andHavePermissionBlock:block];
    } else if ([_propType isEqualToString:CONTRIBUTION]) {
        // 房源贡献
        permission = [self checkShowViewPermission:MENU_PROPERTY_MY_SHARING andHavePermissionBlock:block];
    }
}

/// 获取FilterEntity里面数组的具体值的value
- (NSMutableArray*)getfilterConditionWith:(NSMutableArray *)array
{
    NSMutableArray * infoArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++)
    {
        SelectItemDtoEntity * entity = array[i];
        if (entity.itemValue)
        {
            [infoArray addObject:entity.itemValue];
        }
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

- (NSString *)getFilterConditionString
{
    NSMutableArray * filterArray = [NSMutableArray arrayWithCapacity:0];
    NSString * areaString = [self getStringWith:_filterEntity.minBuildingArea and:_filterEntity.maxBuildingArea andType:@"面积"];
    NSString * saleString = [self getStringWith:_filterEntity.minSalePrice and:_filterEntity.maxSalePrice andType:@"出售"];
    NSString * rentString = [self getStringWith:_filterEntity.minRentPrice and:_filterEntity.maxRentPrice andType:@"出租"];
    
    if ([_filterEntity.isCompleteDoc isEqualToString:@"true"])
    {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        entity.itemText = @"证件齐全";
        [_filterEntity.propTag addObject:entity];
    }
    
    if ([_filterEntity.isTrustProperty isEqualToString:@"true"])
    {
        SelectItemDtoEntity *entity = [SelectItemDtoEntity new];
        entity.itemText = @"委托房源";
        [_filterEntity.propTag addObject:entity];
    }
    
    if (_searchKeyWord && ![_searchKeyWord isEqualToString:@""] && _filterEntity.propertyNo.length < 1)
    {
        [filterArray addObject:[NSString stringWithFormat:@"关  键  字：%@",_searchKeyWord]];
    }
    
    [filterArray addObject:[NSString stringWithFormat:@"交易类型：%@",[self isHaveString:_filterEntity.estDealTypeText]]];
    
    if (![areaString isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"建筑面积：%@",areaString]];
    }
    
    if (![saleString isEqualToString:@""])
    {
//        if ([saleString isEqualToString:@"500-9999999万"])
//        {
//            saleString = @"500万以上";
//        }
        [filterArray addObject:[NSString stringWithFormat:@"出售价格：%@",saleString]];
    }
    
    if (![rentString isEqualToString:@""])
    {
//        if ([rentString isEqualToString:@"4000-9999999元"])
//        {
//            rentString = @"4000元以上";
//        }
        
        [filterArray addObject:[NSString stringWithFormat:@"出租价格：%@",rentString]];
    }
    
    NSString * tagText = [_filterEntity.tagText isEqualToString:@"标签"] ? @"不限": _filterEntity.tagText;
    [filterArray addObject:[NSString stringWithFormat:@"标        签：%@",[self isHaveString:tagText]]];
    
    if (![[self getArrayString:_filterEntity.roomType] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房        型：%@",[self getArrayString:_filterEntity.roomType]]];
    }
    if (![[self getArrayString:_filterEntity.roomStatus] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房源状态：%@",[self getArrayString:_filterEntity.roomStatus]]];
    }
    
    // 价格排序
    [filterArray addObject:[NSString stringWithFormat:@"排        序：%@",[self getPriceAscendingStr]]];
    
    if (![[self getArrayString:_filterEntity.roomSituation] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房屋现状：%@",[self getArrayString:_filterEntity.roomSituation]]];
    }
    if (![[self getArrayString:_filterEntity.roomLevels] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房屋等级：%@",[self getArrayString:_filterEntity.roomLevels]]];
    }
    if (![[self getArrayString:_filterEntity.direction] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"朝        向：%@",[self getArrayString:_filterEntity.direction]]];
    }
    if (![[self getArrayString:_filterEntity.propTag] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房源标签：%@",[self getArrayString:_filterEntity.propTag]]];
    }
    if (![[self getArrayString:_filterEntity.buildingType] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"建筑类型：%@",[self getArrayString:_filterEntity.buildingType]]];
    }
    if (![[self isHaveString:_filterEntity.propertyNo] isEqualToString:@""])
    {
        [filterArray addObject:[NSString stringWithFormat:@"房源编号：%@",[self isHaveString:_filterEntity.propertyNo]]];
    }
    
    NSInteger tagCount = _filterEntity.propTag.count;
    
    for (NSInteger i = tagCount - 1; i >= 0; i--)
    {
        SelectItemDtoEntity *entity = _filterEntity.propTag[i];
        
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

/// 获取价格排序String
- (NSString *)getPriceAscendingStr
{
    NSString *ascendingStr = @"默认排序";
    if (_filterEntity.sortField.length > 0)
    {
        if ([_filterEntity.sortField isEqualToString:SalePrice])
        {
            if ([_filterEntity.ascending  isEqualToString: TRUE_String])
            {
                ascendingStr = @"售价从小到大";
            }
            else
            {
                ascendingStr = @"售价从大到小";
            }
        }
        else
        {
            if ([_filterEntity.ascending  isEqualToString: TRUE_String])
            {
                ascendingStr = @"租价从小到大";
            }
            else
            {
                ascendingStr = @"租价从大到小";
            }
        }
    }
    
    return ascendingStr;
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

- (BOOL) isBlankString:(NSString *)string
{
    if (string ==  nil || string ==  NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    return NO;
}

/// 获取数组中的text
- (NSString *)getArrayString:(NSMutableArray*)array
{
    if (array.count == 0)
    {
        return @"";
    }
    
    NSMutableArray * stringArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++)
    {
        SelectItemDtoEntity * entity = array[i];
        [stringArray addObject:entity.itemText];
    }
    NSString * string = [stringArray componentsJoinedByString:@"、"];
    return string;
}

/// 输入的面积或价格 （判断价格是否为空或者为0 不保存）
- (NSString *)getStringWith:(NSString *)minString and:(NSString*)maxString andType:(NSString*)type
{
    minString = [self opinionStringFromString:minString];
    maxString = [self opinionStringFromString:maxString];
    
    if ((minString !=  nil && maxString !=  nil) && (![minString isEqualToString:@""]  && ![maxString isEqualToString:@""]))
    {
        NSString * infoString;
        if ([type isEqualToString:@"面积"])
        {
            infoString = [NSString stringWithFormat:@"%@-%@平",minString,maxString];
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
            infoString = [NSString stringWithFormat:@"%@平以上",minString];
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
            infoString = [NSString stringWithFormat:@"%@平以下",maxString];
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

/// 点击灰色区域
- (void)clickTapGesture
{
    [self removeWindow];
}

/// 删除保存view
- (void)removeWindow
{
    
    [_customView removeFromSuperview];
    _customView = nil;
    
    //    [_mainWindow resignKeyWindow];
    //    [_mainWindow removeFromSuperview];
    //
    //    [[self sharedAppDelegate].window makeKeyAndVisible];
}

- (void)setTableViewContentOff
{
    [_mainTableView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -  点击房源列表的图片和下面的五个按钮
- (void)clickEstateListBtnWitdIndex:(NSInteger)index andBtnName:(NSString *)btnName
{
    _estateEntty = _estateListArray[index];
    
    if ([btnName isEqualToString:@"图片"])
    {
        NSString *realSurveyCount = [NSString stringWithFormat:@"%@",_estateEntty.realSurveyCount];
        
        if (realSurveyCount.integerValue > 0)
        {
            BOOL isAble = [_allRoundListPresenter canViewUploadrealSurvey:_estateEntty.departmentPermissions];
            if (isAble)
            {
                PhotoDownLoadImageViewController *photoDownImageVC = [[PhotoDownLoadImageViewController alloc]initWithNibName:@"PhotoDownLoadImageViewController" bundle:nil];
                photoDownImageVC.propKeyId = _estateEntty.keyId;
                photoDownImageVC.isItem = NO;
                [self.navigationController pushViewController:photoDownImageVC animated:YES];
            }
            else
            {
                showMsg(@(NotHavePermissionTip));
            }
        }
        else
        {
            // 上传实勘
            [self uploadRealMethod];
        }
    }
    if ([btnName isEqualToString:@"收藏"])
    {
        EstateListCell * cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.estateFavoriteBtn.selected = !cell.estateFavoriteBtn.selected;
        _collectBtnIsSelect = cell.estateFavoriteBtn.selected;
        
        CollectPropApi *collectPropApi = [[CollectPropApi alloc] init];
        collectPropApi.isCollect = _collectBtnIsSelect;
        collectPropApi.propKeyId = _estateEntty.keyId;
        [_manager sendRequest:collectPropApi];
        
        [self showLoadingView:nil];
    }
    if ([btnName isEqualToString:@"跟进"])
    {
        BOOL hasPermisstion = YES;
        
        if (![NSString isNilOrEmpty:_estateEntty.departmentPermissions])
        {
            hasPermisstion =  [_estateEntty.departmentPermissions contains:DEPARTMENT_PROPERTY_FOLLOW_ADD_ALL];
        }
        
        if (!hasPermisstion || ![AgencyUserPermisstionUtil hasMenuPermisstion:DEPARTMENT_PROPERTY_FOLLOW_ADD_ALL])
        {
            showMsg(@(NotHavePermissionTip));
            return;
        }
        
        /**
         如果房源状态为暂停，无效，资料盘，中原售，中原租时，更多第一项为洗盘。
         如果是有效，预定状态更多第一项为信息补充
         */
        
        NSArray * listArr = @[@"房源动态"];
        
        __block typeof(self) weakSelf = self;
        
        [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
            
            // 信息补全 或 洗盘
            AppendInfoViewController *appendMsgVC = [[AppendInfoViewController alloc]initWithNibName:@"AppendInfoViewController"
                                                                                              bundle:nil];
            BOOL isCanAdd = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOWINFORMATION_ADD];
            if(isCanAdd)
            {
                appendMsgVC.appendMessageType = PropertyFollowTypeInfoAdd;
                appendMsgVC.propertyKeyId = _estateEntty.keyId;
                [weakSelf.navigationController pushViewController:appendMsgVC
                                                         animated:YES];
            }
            else
            {
                showMsg(@(NotHavePermissionTip));
            }
            
        }];
        
        //        NSInteger propertyStatusCategory = [_estateEntty.propertyStatus integerValue];
        //        BYActionSheetView *addNewActionSheet = [_propMoreFollowPresenter addMoreMethod:propertyStatusCategory andTrustType:[NSString stringWithFormat:@"%@",_estateEntty.trustType]];
        //        addNewActionSheet.delegate = self;
        //        addNewActionSheet.tag = AddFollowActionTag;
        //        [addNewActionSheet show];
    }
    if ([btnName isEqualToString:@"电话"])
    {
        // 查看联系人权限
        BOOL hasPermisstion = [_propDetailPresenter canViewTrustors:_estateEntty.departmentPermissions];
        
        if (hasPermisstion) {
            NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:APlusUserMobile];
            
            phoneNum = phoneNum?:@"";
            NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
            NSString *departId = [AgencyUserPermisstionUtil getIdentify].departId;
            
            GetTrustorsApi *getTrustorsApi = [[GetTrustorsApi alloc] init];
            getTrustorsApi.userKeyId = userKeyId;
            getTrustorsApi.departmentKeyId = departId;
            getTrustorsApi.userPhone = phoneNum;
            getTrustorsApi.keyId = _estateEntty.keyId;
            
            //  重置selectIndex
            _selectIndex = 0;
            [_manager sendRequest:getTrustorsApi];
            [self showLoadingView:@"正在获取联系人信息..."];
            
        }else{
            showMsg(@(NotHavePermissionTip));
            
        }
        
        
    }
    if ([btnName isEqualToString:@"实勘"])
    {
        [self uploadRealMethod];
    }
    if ([btnName isEqualToString:@"分享"])
    {
        //        [self sendSharePropDetailWithKeyId:_estateEntty.keyId
        //                                 andImgUrl:_estateEntty.photoPath
        //                                andEstName:_estateEntty.estateName];
        
        
        // 钥匙
        PropKeyViewController *keyBoxVC = [[PropKeyViewController alloc] init];
        keyBoxVC.keyId = _estateEntty.keyId;
        [self.navigationController pushViewController:keyBoxVC animated:YES];
    }
}

- (void)uploadRealMethod
{
    BOOL isAble = [_propDetailPresenter canAddUploadrealSurvey:_estateEntty.departmentPermissions];
    if (isAble)
    {
        // 是否需要验证实勘保护期
        if ([_propDetailPresenter isCheckRealProtected])
        {
            // 是否需要检查房源状态
            if ([_propDetailPresenter isCheckPropertyStatus])
            {
                if ([_estateEntty.propertyStatus  integerValue] != 1)
                {
                    showMsg(@"非有效房源无法上传实勘!");
                    return;
                }
            }
            
            // 验证实堪保护期
            CheckRealProtectedDurationApi *checkRealProtectedApi = [[CheckRealProtectedDurationApi alloc] init];
            checkRealProtectedApi.keyId = _estateEntty.keyId;
            [_manager sendRequest:checkRealProtectedApi];
            
            _clickImageHouseID = _estateEntty.keyId;
        }
        else
        {
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _estateEntty.keyId;
            [self.navigationController pushViewController:uploadRealSurveyVC animated:YES];
        }
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
    }
}

- (CustomActionSheet *)showPickView
{
    CustomActionSheet *sheet = [self.view viewWithTag:1234];
    if (sheet == nil)
    {
        UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
        mPickerView.dataSource = self;
        mPickerView.delegate = self;
        
        sheet = [[CustomActionSheet alloc] initWithView:mPickerView AndHeight:300];
        sheet.tag = 1234;
        sheet.doneDelegate = self;
        
        [JMWindow addSubview:sheet];
    }
    return sheet;
}

#pragma mark - <TapDelegate>

- (void)tapAction
{
    _eventView.hidden = !_eventView.hidden;
}

#pragma mark - <UIPickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *nameArr = [_propDetailPresenter getTrustorsName];
    return nameArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSArray *nameArr = [_propDetailPresenter getTrustorsName];
    
    cusPicLabel.text = nameArr[row];
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
}

#pragma mark - <doneSelect>

- (void)doneSelectItemMethod
{
    // 选择某个联系人之后确定拨打电话
    // 是否使用虚拟号拨打
    BOOL isVirtualCall = NO;
    
    NSString *errorMsg = [_propDetailPresenter callTrustorsMsgSelectIndex:_selectIndex];
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showMsg(errorMsg);
        return;
    }
    
    isVirtualCall = [_propDetailPresenter isCallVirtualPhone];
    NSString *tel = [_propDetailPresenter getCallNumSelectIndex:_selectIndex];
    _mobile = tel;
    
    // 使用虚拟号
    if (isVirtualCall)
    {
        [_propDetailPresenter callVirtualPhoneSelectIndex:_selectIndex
                                                 andMobil:_mobile
                                             andPropKeyId:_estateEntty.keyId
                                            andPropertyNo:_estateEntty.houseNo];
    }
    // 不使用虚拟号
    else
    {
        // 删除当日拨打记录
        [CallRealPhoneLimitUtil deleteNotToday];
        
        // keyId是否存在
        if ([CallRealPhoneLimitUtil isExistWithPropKeyId:_estateEntty.keyId])
        {
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            
            return;
        }
        
        NSInteger limit = [_propDetailPresenter getCallLimit];
        NSInteger curCount = [CallRealPhoneLimitUtil getCountForToday];
        
        if (curCount >= limit)
        {
            showMsg(@"您今日拨打电话次数已用完！");
            return;
        }
        
        NSString *msg = [NSString stringWithFormat:@"剩余拨打次数：%@，您确定要拨打吗？",@(limit - curCount)];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        alertView.tag = CallRealPhoneAlertTag;
        [alertView show];
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CallRealPhoneAlertTag)
    {
        switch (buttonIndex)
        {
            case 1:
            {
                [CallRealPhoneLimitUtil addCallRealPhoneRecordWithPropKeyId:_estateEntty.keyId];
                
                NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - DelegateMethod

- (void)getBtnTag:(NSInteger)tag FilterName:(NSString *)name SettingSwitch:(BOOL)ison andSearchName:(NSString *)searchName
{
    if (tag == 100)
    {
        // 去除字符串前端的空格
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString * nameString = [name stringByTrimmingCharactersInSet:whitespace];
        
        if ([nameString isEqualToString:@""]||[self isBlankString:nameString])
        {
            [CustomAlertMessage showAlertMessage:@"筛选别名不能为空\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2
                                 andCustomWindow:[UIApplication sharedApplication].keyWindow];
        }
        else
        {
            for (int i = 0; i < _allInfoArray.count; i++)
            {
                DataFilterEntity * entity =  _allInfoArray[i];
                if ([entity.nameString isEqualToString:nameString])
                {
                    [CustomAlertMessage showAlertMessage:@"为方便您区分搜索条件,请不要保存重复的别名\n\n"
                                         andButtomHeight:APP_SCREEN_HEIGHT/2
                                         andCustomWindow:[UIApplication sharedApplication].keyWindow];
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
                _bottomFilterLabel.textColor = YCTextColorBlack;
                [CommonMethod setUserdefaultWithValue:_searchKeyWord forKey:KeyWord];
                [CommonMethod setUserdefaultWithValue:nameString forKey:NameString];
            }
            else
            {
                _filterEntity.isCurrent = NO;
            }
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:_filterEntity];
            NSString * valueString = [jsonDic JSONString];
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

#pragma mark - <BYActionSheetViewDelegate>

- (void)actionSheetView:(BYActionSheetView *)alertView
   clickedButtonAtIndex:(NSInteger)buttonIndex
         andButtonTitle:(NSString *)buttonTitle
{
    if ([buttonTitle isEqualToString:@"房源动态"])
    {
        // 信息补全 或 洗盘
        AppendInfoViewController *appendMsgVC = [[AppendInfoViewController alloc]initWithNibName:@"AppendInfoViewController"
                                                                                          bundle:nil];
        BOOL isCanAdd = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOWINFORMATION_ADD];
        if(isCanAdd)
        {
            appendMsgVC.appendMessageType = PropertyFollowTypeInfoAdd;
            appendMsgVC.propertyKeyId = _estateEntty.keyId;
            [self.navigationController pushViewController:appendMsgVC
                                                 animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
        
        return;
    }
    
    if ([buttonTitle isEqualToString:@"申请转盘"])
    {
        BOOL isCancanTrun = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOWTURN_ADD];
        if(isCancanTrun)
        {
            ApplyTransferPubEstViewController *applyTransferEstVC = [[ApplyTransferPubEstViewController alloc] initWithNibName:@"ApplyTransferPubEstViewController"
                                                                                                                        bundle:nil];
            applyTransferEstVC.propEstKeyId = _estateEntty.keyId;
            applyTransferEstVC.propertyStatus = _estateEntty.propertyStatus;
            
            [self.navigationController pushViewController:applyTransferEstVC animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
        return;
    }
}

#pragma mark - FilterListDelegate

- (void)getFilterListEntity:(DataFilterEntity *)entity isSendService:(BOOL)isSend isSettingName:(BOOL)isSetting
{
    _isSetttingName = isSetting;
    _isSendService = isSend;
    
    if (isSend)
    {
        [self showLoadingView:nil];
        if ([entity.nameString isEqualToString:@""]||!entity)
        {
            _bottomFilterLabel.text = @"暂无默认搜索";
            _bottomFilterLabel.textColor = YCTextColorAuxiliary;
            _searchKeyWord = @"";
            
            [self headerRefreshMethod];
        }
        else
        {
            _bottomFilterLabel.text = [NSString stringWithFormat:@"默认：%@",entity.nameString];
            _bottomFilterLabel.textColor = YCTextColorBlack;
            _currentSelectString = entity.nameString;
            
            _filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class]
                                      fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                   error:nil];
            _currentShowText = entity.showText;
            NSString *keyWord = [CommonMethod getUserdefaultWithKey:KeyWord];
            _searchKeyWord = keyWord;
            [_searchTextBtn setTitle:keyWord forState:UIControlStateNormal];
            [self changeSearchBarRightBtnImageWithSearching:YES];
            [self headerRefreshMethod];
        }
    }
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _estateListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return TableViewHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EstateListCell *estateListCell = [EstateListCell cellWithTableView:tableView];
    [estateListCell setCellDataWithDataSource:_estateListArray[indexPath.row]];
    
    WS(weakSelf);
    estateListCell.blcok = ^(NSString *estateName)
    {
        [weakSelf clickEstateListBtnWitdIndex:indexPath.row andBtnName:estateName];
    };
    
    return estateListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertysModelEntty *propModelEntity = [_estateListArray objectAtIndex:indexPath.row];
    
    //处理已阅读数据
    [SQLiteManager insertToTableName:DATABASE_ALREAY_ESTATE_TABLE_NAME andObject:propModelEntity];
    
    propModelEntity.isRead = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //以上处理是否已阅读数据
    
    PropertyDetailVC *vc = [[PropertyDetailVC alloc] init];
    
    __block typeof(self) weakSelf = self;
    
    // 点击收藏回调
    vc.block = ^(BOOL isSelect){
        
        [weakSelf headerRefreshMethod];
    };
    vc.propModelEntity = propModelEntity;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- 网络

- (void)dealData:(id)data andClass:(id)modelClass {
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[PropListEntity class]]) {
        PropListEntity *propListEntity = [DataConvert convertDic:data toEntity:modelClass];
        _recordCount = propListEntity.recordCount;
        
        //处理已阅读数据
        for (PropertysModelEntty * estateModel in propListEntity.propertysModel) {
            
            NSArray * array = [SQLiteManager queryByParamsWithTableName:DATABASE_ALREAY_ESTATE_TABLE_NAME andClass:[PropertysModelEntty class] andParams:@{@"keyId" : estateModel.keyId ? : @""}];
            
            estateModel.isRead = array.count > 0;
            
        }
        //以上处理是否已阅读数据
        
        if (_recordCount > 0)
        {
            _numberStandard.hidden = NO;
            [_numberStandard setTitle:[NSString stringWithFormat:@"%ld/%ld",_recordIndex,_recordCount] forState:UIControlStateNormal];
        }else
        {
            _numberStandard.hidden = YES;
        }
        
        
        BOOL permissionIsEmpty = NO;
        // 更新用户权限
        if(propListEntity.permisstionsModel)
        {
            PermisstionsEntity *permisson = [PermisstionsEntity new];
            permisson.menuPermisstion = propListEntity.permisstionsModel.menuPermisstion;
            permisson.rights = propListEntity.permisstionsModel.rights;
            permisson.departmentKeyIds = propListEntity.permisstionsModel.departmentKeyIds;
            permisson.rightUpdateTime = propListEntity.permisstionsModel.rightUpdateTime;
            [AgencyUserPermisstionUtil updateUserPermission:permisson];
            
            // 如果没有权限，表示经纪人离职
            permissionIsEmpty = [AgencyUserPermisstionUtil permissionIsEmpty];
            if(permissionIsEmpty)
            {
                [self logout];
            }
        }
        
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];
        
        
        // 加次判断为防止没有权限时，强制退出后，提示没有权限
        if(!permissionIsEmpty)
        {
            // 检查权限，没有权限时弹出提示，点击确定退出当前页面
            [self checkPermission:nil];
        }
        
        if(!propListEntity.flag)
        {
            showMsg(propListEntity.errorMsg);
            return;
        }
        
        if (propListEntity.propertysModel.count < 10)
        {
            
            _mainTableView.mj_footer.hidden = YES;
        }
        else
        {
            _mainTableView.mj_footer.hidden = NO;
        }
        
        if (_isHeaderRefresh) [_estateListArray removeAllObjects];
        
        [_estateListArray addObjectsFromArray:propListEntity.propertysModel];
        

        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];

        
        [_mainTableView reloadData];
        
    }else if ([modelClass isEqual:[AgencyBaseEntity class]]) {/// 收藏/取消收藏
        AgencyBaseEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.flag == YES)
        {
            // 收藏/取消收藏成功
            if (_collectBtnIsSelect)
            {
                [CustomAlertMessage showAlertMessage:@"收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            else
            {
                [CustomAlertMessage showAlertMessage:@"取消收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            if ([_propType isEqualToString:FAVORITE])
            {
                [self showLoadingView:nil];
                [self headerRefreshMethod];
            }
        }
    } else if ([modelClass isEqual:[CheckRealProtectedEntity class]]) {
        // 点击上传实勘
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
        
        if(isAble)
        {
            NSString *isLockRoom = [NSString stringWithFormat:@"%d",checkRealProtectedEntity.isLockRoom];
            
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController" bundle:nil];
            uploadRealSurveyVC.propKeyId = _clickImageHouseID;
            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.width])
            {
                uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.high])
            {
                uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            }
            if (![NSString isNilOrEmpty:isLockRoom])
            {
                uploadRealSurveyVC.isLockRoom = checkRealProtectedEntity.isLockRoom;
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount])
            {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount])
            {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            
            [self.navigationController pushViewController:uploadRealSurveyVC
                                                 animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }else  if ([modelClass isEqual:[PropTrustorsInfoEntity class]]) {/// 获取联系人
        
        [_propDetailPresenter getDataSource:data];
        
        // 显示联系人
        [self showPickView];
    }else if ([modelClass isEqual:[PropTrustorsInfoForShenZhenEntity class]]) {
        
        [_propDetailPresenter getDataSource:data];
        // 显示联系人
        [self showTrustors];
    }
    
}
/// 显示联系人
- (void)showTrustors {
    
    
    NSString *errorMsg = [_propDetailPresenter showTrustorsErrorMsg];
    if (errorMsg.length || ![_propDetailPresenter getTrustorsName].count) {
        showMsg(errorMsg?:@"暂无联系人信息!");
        
    }else{
        
        [self showPickView];
    }
    
    
}
#pragma mark - 显示或隐藏置顶按钮

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint scrollEndPoint = scrollView.contentOffset;
    
    NSInteger index = (scrollEndPoint.y + 32)/TableViewHeight;
    if (index%1 == 0)
    {
        _recordIndex = index + 1;
        [_numberStandard setTitle:[NSString stringWithFormat:@"%ld/%ld",_recordIndex,_recordCount] forState:UIControlStateNormal];
    }
    
    if (scrollEndPoint.y == 0)
    {
        [self.view constraintAnimateWithConstraint:_backTopBtnConstraint andConstant:11.0 - _mainTableViewButtomY];
        [self.view constraintAnimateWithConstraint:_sortBtnConstraint andConstant:100.0 - _mainTableViewButtomY];
    }
    else if (scrollEndPoint.y > 120)
    {
        [self.view constraintAnimateWithConstraint:_backTopBtnConstraint andConstant:100.0 - _mainTableViewButtomY];
        [self.view constraintAnimateWithConstraint:_sortBtnConstraint andConstant:150.0 - _mainTableViewButtomY];
    }
}

@end
