//
//  SearchViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/24.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SearchViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "SearchPropEntity.h"
#import "DataBaseOperation.h"
#import "AllRoundVC.h"
#import "SearchPropApi.h"
#import "NSString+Extension.h"
#import "SearchBuildingVC.h"
#import "SearchViewCell.h"


#define RoomNumberTextFieldTag   100005
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface SearchViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    UITextField *_textfield;
    IFlyRecognizerView  *_iflyRecognizerView;
    DataBaseOperation *_dataBaseOperation;  //数据库操作类

    BOOL _isFirstAppear;
    BOOL _isSearching;  //是否正在搜索的操作

    NSMutableArray *_searchResultArr;   //搜索结果、搜索历史
    NSString *_searchKeyWordsStr;   //搜索关键字
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *_clearSearchHisBtn;   //清空搜索历史按钮
    
    NSString *_buildingName; // 楼盘名
    NSString *_extendAttr;
    
    // 导航栏控件
    UIView *_topSearchView;
    UIButton *_rightVoiceButton;
    UIImageView *_searchBarBgImage;
    
    UIView *_topSearchRoomNumberView;
    UIView *_searchRoomNumberBgImage;
    UITextField *_searchRoomNumberTextField;
    
    SearchPropApi *_searchPropApi;
    NSMutableString *_searchText;
    NSString *_estateSelectType;
    
    
    SearchPropDetailEntity *_searchEntity;
}

@end

@implementation SearchViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavView];
    if ([_fromModuleStr isEqualToString:From_Calendar] || [_fromModuleStr isEqualToString:From_TrustAuditing])
    {
        _estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ESTATENAME];
    }
    else
    {
        _estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
    }

    _searchPropApi = [[SearchPropApi alloc] init];
    
    [self.view endEditing:YES];
    _isFirstAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    // 添加搜索框监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    if (_isFirstAppear)
    {
        _isFirstAppear = NO;
        [self initView];
    }
    
    [self changeNavViewName:@"" andHasRoomNumber:NO];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}



- (void)initView
{
    _searchText = [NSMutableString string];

    [_clearSearchHisBtn addTarget:self
                           action:@selector(removeSearchResultMethodAndLoadMore)
                 forControlEvents:UIControlEventTouchUpInside];
    
    if (_searchType == TopVoidSearchType)
    {
        // 语音搜索
        [self createVoiceSearch];
    }
    else if (_searchType == TopTextSearchType)
    {
        // 文字搜索
        [_textfield becomeFirstResponder];
    }
}

- (void)initData
{
    // 如果输入框中没有输入文字的时候，每次进入页面时需要刷新搜索历史记录
    if (!_searchKeyWordsStr ||
        [_searchKeyWordsStr isEqualToString:@""])
    {
        _searchResultArr = [[NSMutableArray alloc]init];
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        _isSearching = NO;
        [self changeSearchState];
    }
    else
    {
        if ([_fromModuleStr isEqualToString:From_Calendar] || [_fromModuleStr isEqualToString:From_TrustAuditing])
        {
            _searchResultArr = [[NSMutableArray alloc]init];
            _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];

            _isSearching = NO;
            [self changeSearchState];
        }
    }
}

- (void)initNavView
{
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    _topSearchView = [[UIView alloc] init];
    [_topSearchView setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-65, 30)];
    [_topSearchView setBackgroundColor:[UIColor clearColor]];
    UIImageView * searchIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    searchIconImage.frame=CGRectMake(10, 7, 16, 16);
    
    _searchBarBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框背景"]];
    [_searchBarBgImage setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-65, 30)];
    
    _rightVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightVoiceButton setFrame:CGRectMake(_topSearchView.bounds.size.width-43, 0, 43, 30)];
    
    [_rightVoiceButton setImage:[UIImage imageNamed:@"voiceSearch_icon"]
                       forState:UIControlStateNormal];
    [_rightVoiceButton setBackgroundColor:[UIColor clearColor]];
    [_rightVoiceButton addTarget:self
                          action:@selector(createVoiceSearch)
                forControlEvents:UIControlEventTouchUpInside];
    
    _textfield=[[UITextField alloc]initWithFrame:CGRectMake(35, 0, APP_SCREEN_WIDTH-143, 30)];
    if ([_fromModuleStr isEqualToString:From_Calendar] || [_fromModuleStr isEqualToString:From_TrustAuditing])
    {
        _textfield.placeholder = @"  请输入楼盘名";
    }
    else
    {
        _textfield.placeholder = @"  输入城区、片区、楼盘名";
    }
    
    _textfield.delegate=self;
    _textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfield.textColor = YCTextColorAuxiliary;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.textAlignment = NSTextAlignmentLeft;
    _textfield.enablesReturnKeyAutomatically = YES;
    _textfield.font=[UIFont systemFontOfSize:13.0];
    _textfield.clearButtonMode=UITextFieldViewModeNever;
    [_textfield setBackgroundColor:[UIColor clearColor]];
    
    // 设置搜索房号导航栏
    [self getSearchNumberNav];
    
    [_topSearchView addSubview:_searchBarBgImage];
    [_topSearchView addSubview:searchIconImage];
    [_topSearchView addSubview:_rightVoiceButton];
    [_topSearchView addSubview:_textfield];
    
    self.navigationItem.titleView = _topSearchView;
}

#pragma mark - RequestData

/// 请求搜索结果
- (void)searchPropMethod
{
    _searchPropApi.name = _searchKeyWordsStr;
    _searchPropApi.topCount = @"10";
    _searchPropApi.buildName = @"";
    _searchPropApi.estateSelectType = _estateSelectType;
    [_manager sendRequest:_searchPropApi];
}

#pragma mark - PrivateMethod

/// 切换搜索列表显示的内容：搜索历史、搜索结果
- (void)changeSearchState
{
    [_searchResultArr removeAllObjects];
    
    if (_isSearching)
    {
        _clearSearchHisBtn.hidden = YES;
    }
    else
    {
        [self getSearchHisData];

        if (_searchResultArr.count > 0)
        {
            _clearSearchHisBtn.hidden = NO;
            [_clearSearchHisBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        }
        else
        {
            _clearSearchHisBtn.hidden = YES;
        }
    }
    
    [_mainTableView reloadData];
}

// 检测是否需要加载更多
- (void)searchLoadMore
{
    if (_searchResultArr.count == 10)
    {
        if ([_searchPropApi.topCount isEqualToString:@"50"])
        {
            _clearSearchHisBtn.hidden = YES;
            return;
        }
        
        _clearSearchHisBtn.hidden = NO;
        [_clearSearchHisBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    }
    else
    {
        _clearSearchHisBtn.hidden = YES;
    }
}

/// 获取搜索历史数据
- (void)getSearchHisData
{
    NSArray *searchHisArr;
    if ([_fromModuleStr isEqualToString:From_TrustAuditing])
    {
        // 从委托审核
        searchHisArr = [[NSArray alloc] initWithArray:[[_dataBaseOperation selectSearchResultType:TrustAuditingSearchType]
                                                       objectForKey:TrustAuditingSearchType]];
    }
    else if ([_fromModuleStr isEqualToString:From_Calendar])
    {
        // 从日历行程
        searchHisArr = [[NSArray alloc] initWithArray:[[_dataBaseOperation selectSearchResultType:PropCalendarSearchList]
                                                       objectForKey:PropCalendarSearchList]];
    }
    else
    {
        searchHisArr = [[NSArray alloc] initWithArray:[[_dataBaseOperation selectSearchResultType:PropListSearchType]
                                                       objectForKey:PropListSearchType]];
    }
    [_searchResultArr removeAllObjects];
    
    for (NSInteger i = searchHisArr.count-1; i>=0; i--)
    {
        [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
    }
}

///  修改导航栏样式
- (void)changeNavViewName:(NSString *)searchText andHasRoomNumber:(BOOL)hasRoomNumber
{
    if (hasRoomNumber)
    {
        // 显示房号textfield
        _topSearchView.width = APP_SCREEN_WIDTH ;
        _searchBarBgImage.width = APP_SCREEN_WIDTH - 140;
        _rightVoiceButton.x = _searchBarBgImage.width - 37;
        _textfield.width = APP_SCREEN_WIDTH - 195;
        _textfield.text = searchText;
        
        // 房号
        _topSearchRoomNumberView.hidden = NO;
        _searchRoomNumberBgImage.hidden = NO;
        _searchRoomNumberTextField.hidden = NO;
        
        [_topSearchRoomNumberView setFrame:CGRectMake(_searchBarBgImage.right + 10, 0, 65, 30)];
        [_topSearchRoomNumberView setBackgroundColor:[UIColor clearColor]];
        
        [_searchRoomNumberBgImage setFrame:CGRectMake(_topSearchRoomNumberView.x, 0, _topSearchRoomNumberView.width, 30)];
        [_searchRoomNumberTextField setFrame:CGRectMake(_topSearchRoomNumberView.x + 7, 0, _topSearchRoomNumberView.width - 12, 30)];
        _searchRoomNumberTextField.text = @"";
    }
    else
    {
        // 隐藏房号textfield
        _topSearchRoomNumberView.hidden = YES;
        _searchRoomNumberBgImage.hidden = YES;
        _searchRoomNumberTextField.hidden = YES;
        if ([_fromModuleStr isEqualToString:From_Calendar] || [_fromModuleStr isEqualToString:From_TrustAuditing])
        {
            _textfield.placeholder = @"  请输入楼盘名";
        }
        else
        {
            _textfield.placeholder = @"  输入城区、片区、楼盘名";
        }
        _textfield.text = searchText;
        _textfield.frame = CGRectMake(35, 0, APP_SCREEN_WIDTH - 143, 30);
        _searchBarBgImage.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 120, 30);
        _rightVoiceButton.frame = CGRectMake(_topSearchView.bounds.size.width - 43, 0, 43, 30);
    }
}

- (void)recoveryNavigation
{
    if (!_searchRoomNumberTextField.hidden)
    {
        // 隐藏房号textfield
        _topSearchRoomNumberView.hidden = YES;
        _searchRoomNumberBgImage.hidden = YES;
        _searchRoomNumberTextField.hidden = YES;
        if ([_fromModuleStr isEqualToString:From_Calendar] || [_fromModuleStr isEqualToString:From_TrustAuditing])
        {
            _textfield.placeholder = @"  请输入楼盘名";
        }
        else
        {
            _textfield.placeholder = @"  输入城区、片区、楼盘名";
        }
        _textfield.frame = CGRectMake(35, 0, APP_SCREEN_WIDTH - 143, 30);
        _searchBarBgImage.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 65, 30);
        _rightVoiceButton.frame = CGRectMake(_topSearchView.bounds.size.width - 43, 0, 43, 30);
    }
}

- (void)back
{
    [super back];
    
    if ([_textfield isFirstResponder])
    {
        [_textfield resignFirstResponder];
    }
}

- (void)createVoiceSearch
{
    if ([_textfield isFirstResponder])
    {
        [_textfield resignFirstResponder];
    }
    
    __weak typeof (self) weakSelf = self;
    
    // 检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (granted)
        {
            // 初始化语音识别控件
            if (!_iflyRecognizerView)
            {
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                // 设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }
            
            _iflyRecognizerView.delegate = weakSelf;
            [_iflyRecognizerView start];
        }
        else
        {
            showMsg(SettingMicrophone);
        }
    }];
}

#pragma mark - <SearchViewProtocol>

- (void)getSearchNumberNav
{
    _topSearchRoomNumberView = [[UIView alloc] init];
    
    _searchRoomNumberBgImage = [[UIView alloc]init];
    _searchRoomNumberBgImage.backgroundColor = [UIColor whiteColor];
    _searchRoomNumberBgImage.alpha = 0.3;
    // 设置圆角
    _searchRoomNumberBgImage.layer.cornerRadius = 15;
    // 将多余的部分切掉
    _searchRoomNumberBgImage.layer.masksToBounds = YES;
    
    _searchRoomNumberTextField = [[UITextField alloc] init];
    _searchRoomNumberTextField.delegate = self;
    _searchRoomNumberTextField.textColor = [UIColor whiteColor];
    _searchRoomNumberTextField.returnKeyType = UIReturnKeySearch;
    _searchRoomNumberTextField.textAlignment = NSTextAlignmentCenter;
    _searchRoomNumberTextField.enablesReturnKeyAutomatically = YES;
    _searchRoomNumberTextField.font = [UIFont systemFontOfSize:13.0];
    _searchRoomNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _searchRoomNumberTextField.tag = RoomNumberTextFieldTag;
    
//    [_searchRoomNumberTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_topSearchView addSubview:_topSearchRoomNumberView];
    [_topSearchView addSubview:_searchRoomNumberBgImage];
    [_topSearchView addSubview:_searchRoomNumberTextField];
    
    _topSearchRoomNumberView.hidden = YES;
    _searchRoomNumberBgImage.hidden = YES;
    _searchRoomNumberTextField.hidden = YES;
}

#pragma mark - ClearSearchResultMethodAndLoadMore

/// 清空搜索历史
- (void)removeSearchResultMethodAndLoadMore
{
    if ([_clearSearchHisBtn.titleLabel.text isEqualToString:@"清空搜索历史"] )
    {
        if ([_fromModuleStr isEqualToString:From_TrustAuditing])
        {
            [_dataBaseOperation deleteSearchResultWithType:TrustAuditingSearchType];
        }
        else if ([_fromModuleStr isEqualToString:From_Calendar])
        {
            [_dataBaseOperation deleteSearchResultWithType:PropCalendarSearchList];
        }
        else
        {
            [_dataBaseOperation deleteSearchResultWithType:PropListSearchType];
        }

        [self getSearchHisData];
        
        _isSearching = YES;
        [self changeSearchState];
        
        [_mainTableView reloadData];
    }
    
    if ([_clearSearchHisBtn.titleLabel.text isEqualToString:@"加载更多"])
    {
        _searchPropApi.name = _searchKeyWordsStr;
        _searchPropApi.topCount = @"50";
        _searchPropApi.estateSelectType = _estateSelectType;
        [_manager sendRequest:_searchPropApi];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewCell *searchViewCell = [SearchViewCell cellWithTableView:tableView];
    
    searchViewCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    SearchPropDetailEntity *searchDetailEntity;
    
    if (_isSearching)
    {
        searchDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];
        
        searchDetailEntity = [MTLJSONAdapter modelOfClass:[SearchPropDetailEntity class]
                                       fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                    error:nil];
    }
    
    NSString *districtName = searchDetailEntity.districtName?searchDetailEntity.districtName:@"";   // 城区
    NSString *areaName = searchDetailEntity.areaName?searchDetailEntity.areaName:@"";               // 片区
    
    if (districtName.length > 0 && areaName.length > 0)
    {
        searchViewCell.rightLabelTitle.text = [NSString stringWithFormat:@"(%@-%@",districtName,areaName];
        searchViewCell.bracketsLabel.hidden = NO;
        searchViewCell.rightLabelTitle.hidden = NO;
    }
    else
    {
        searchViewCell.bracketsLabel.hidden = YES;
        searchViewCell.rightLabelTitle.hidden = YES;
    }
    
    searchViewCell.leftLabelTitle.text = [NSString stringWithFormat:@"%@",searchDetailEntity.itemText] ;
    
    
        // 如果存在房号
        if (![NSString isNilOrEmpty:searchDetailEntity.houseNo])
        {
             searchViewCell.leftLabelTitle.text = [NSString stringWithFormat:@"%@,%@",searchDetailEntity.itemText,searchDetailEntity.houseNo];
        }
    

    return searchViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchPropDetailEntity *searchPropDetailEntity;

    if (!_isSearching)
    {
        // 直接使用历史搜索的结果
        NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];

        searchPropDetailEntity = [MTLJSONAdapter modelOfClass:[SearchPropDetailEntity class]
                                           fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                        error:nil];
        _buildingName = searchPropDetailEntity.itemText;
    }
    else
    {
        searchPropDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];

        if (_fromModuleStr.length == 0)
        {
            _searchRoomNumberTextField.text = @"";
            searchPropDetailEntity.houseNo = @"";
        }
        else
        {
           //非深圳 先保存
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:searchPropDetailEntity];
            NSString *jsonStr = [jsonDic JSONString];
            if ([_fromModuleStr isEqualToString:From_TrustAuditing])
            {
                // 从委托审核
                [_dataBaseOperation insertSearchResult:TrustAuditingSearchType andValue:jsonStr];
            }
            else if ([_fromModuleStr isEqualToString:From_Calendar])
            {
                // 从日历行程
                [_dataBaseOperation insertSearchResult:PropCalendarSearchList andValue:jsonStr];
            }
            else
            {
                [_dataBaseOperation insertSearchResult:PropListSearchType andValue:jsonStr];
            }
        }
    }

    [_textfield resignFirstResponder];

    NSString *extendAttr = searchPropDetailEntity.extendAttr;
    NSInteger extendAttrNmuber = 0 ;
    if ([extendAttr isEqualToString:@"楼盘"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_ESTATENAME;
    }
    else if ([extendAttr isEqualToString:@"行政区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_DISTRICTNAME;
    }
    else if ([extendAttr isEqualToString:@"地理片区"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_REGIONNAME;
    }
    else if ([extendAttr isEqualToString:@"楼栋"])
    {
        extendAttrNmuber = EstateSelectTypeEnum_BUILDINGBELONG;
    }
    
    NSString *extendAttrNmubeStr = [NSString stringWithFormat:@"%ld",(long)extendAttrNmuber];

    if ( _fromModuleStr.length == 0)
    {
        // 搜索通盘房源
        if ([extendAttr isEqualToString:@"楼盘"])
        {
            //  楼盘 跳到房号textfield框
            _searchEntity = searchPropDetailEntity;
            _buildingName = searchPropDetailEntity.itemText;
            _extendAttr = extendAttrNmubeStr;
            [self changeNavViewName:searchPropDetailEntity.itemText andHasRoomNumber:YES];
            
            if ([NSString isNilOrEmpty:searchPropDetailEntity.houseNo])
            {
                UIColor *color = [UIColor whiteColor];
                _searchRoomNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"房号" attributes:@{NSForegroundColorAttributeName: color}];
    
                [_textfield becomeFirstResponder];
                return;
            }
        }
        else
        {
            // 非楼盘 保存历史搜索条件
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:searchPropDetailEntity];
            NSString *jsonStr = [jsonDic JSONString];
            [_dataBaseOperation insertSearchResult:PropListSearchType andValue:jsonStr];
        }
    }
    
    NSString *houseNo = searchPropDetailEntity.houseNo;
    
    
    if (_isFromMainPage)
    {
        // 从首页进入到搜索，进入房源列表
        _textfield.text = @"";
        [self changeNavViewName:@"" andHasRoomNumber:NO];
        
        AllRoundVC *allRoundVC = [[AllRoundVC alloc] initWithNibName:@"AllRoundVC" bundle:nil];
        allRoundVC.isPropList = YES;
        allRoundVC.propType = WARZONE;
        allRoundVC.isHomePageSearch = YES;
        allRoundVC.isFromSearchPage = YES;
        allRoundVC.searchKeyWord = searchPropDetailEntity.itemText;
        allRoundVC.estateSelectType = extendAttrNmubeStr;
        allRoundVC.houseNo = houseNo;
        
       
            if (![NSString isNilOrEmpty:houseNo])
            {
                 allRoundVC.searchKeyWord = [NSString stringWithFormat:@"%@，%@",searchPropDetailEntity.itemText,houseNo];
            }
        
        
        [self.navigationController pushViewController:allRoundVC animated:YES];
    }
    else
    {
        // 从其他页面进入搜索，这种情况直接返回列表
        if ([_delegate respondsToSelector:@selector(searchResultWithKeyword:andExtendAttr:andItemValue:andHouseNum:)])
        {
            if ([_fromModuleStr isEqualToString:From_Calendar])
            {
                // 跳转到根据楼盘搜索所有栋座界面
                SearchBuildingVC *vc = [[SearchBuildingVC alloc] init];
                vc.estateName = searchPropDetailEntity.itemText;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if([_fromModuleStr isEqualToString:From_TrustAuditing])
            {
                [self back];
                [self.delegate searchResultWithKeyword:searchPropDetailEntity.itemText andExtendAttr:extendAttrNmubeStr andItemValue:searchPropDetailEntity.itemValue  andHouseNum:houseNo];
            }
            else
            {
                [self.delegate searchResultWithKeyword:searchPropDetailEntity.itemText andExtendAttr:extendAttrNmubeStr andItemValue:searchPropDetailEntity.itemValue  andHouseNum:houseNo];
                [self back];
            }
        }
    }
    
    [_searchRoomNumberTextField resignFirstResponder];
    [_textfield resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - searchBarNotification

- (void)searchBarChangeInput:(NSNotification *)notificationObj
{
    UITextField *searchTextfield = (UITextField *)notificationObj.object;
    
    if (searchTextfield.tag == RoomNumberTextFieldTag)
    {
        if (searchTextfield.text.length > 15)
        {
            searchTextfield.text = [searchTextfield.text substringToIndex:15];
        }
    }
    else
    {
        if (![searchTextfield.text isEqualToString:_buildingName])
        {
            _searchRoomNumberTextField.text = @"";
        }
        if ([searchTextfield.text isEqualToString:_searchKeyWordsStr])
        {
            // 防止点击确认后又发送一次同样的请求
            return;
        }
        
        NSString *str = searchTextfield.text;
        _searchKeyWordsStr = str;
        
        if ([NSString isNilOrEmpty:str])
        {
            _isSearching = NO;
            [self changeSearchState];
        }
        else
        {
            if (!_isSearching)
            {
                _isSearching = YES;
                [self changeSearchState];
            }
            [self searchPropMethod];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([NSString isNilOrEmpty:_buildingName])
    {
        showMsg(@"请在智能提示中选择!");
        return NO;
    }
    
    if (![_textfield.text isEqualToString:_buildingName])
    {
        showMsg(@"请在智能提示中选择!");
        return NO;
    }
    
    // 保存搜索条件
    
        _searchEntity.houseNo = _searchRoomNumberTextField.text;
    
    
    if ([self deptIdInputShouldAlphaNum:_searchRoomNumberTextField.text])
    {
        showMsg(@"只能搜索字母或数字");
        return NO;
    }
    
    NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:_searchEntity];
    NSString *jsonStr = [jsonDic JSONString];
    if ([_fromModuleStr isEqualToString:From_TrustAuditing])
    {
        // 从委托审核
        [_dataBaseOperation insertSearchResult:TrustAuditingSearchType andValue:jsonStr];
    }
    else if ([_fromModuleStr isEqualToString:From_Calendar])
    {
        // 从日历行程
        [_dataBaseOperation insertSearchResult:PropCalendarSearchList andValue:jsonStr];
    }
    else
    {
        [_dataBaseOperation insertSearchResult:PropListSearchType andValue:jsonStr];
    }

    if (!_isFromMainPage)
    {
        [_delegate searchResultWithKeyword:_buildingName
                             andExtendAttr:_extendAttr
                              andItemValue:@""
                               andHouseNum:_searchRoomNumberTextField.text];
        [self back];
    }
    else
    {
        AllRoundVC *allRoundVC = [[AllRoundVC alloc] initWithNibName:@"AllRoundVC" bundle:nil];
        allRoundVC.isPropList = YES;    // LJS 首页房号搜索权限
        allRoundVC.propType = WARZONE;
        allRoundVC.isHomePageSearch = YES;  // LJS 首页搜索权限
        allRoundVC.isFromSearchPage = YES;
        allRoundVC.searchKeyWord = _buildingName;
        allRoundVC.estateSelectType = _extendAttr;
        
        
            NSString *houseNo;
            
            if (![NSString isNilOrEmpty:_searchRoomNumberTextField.text])
            {
                houseNo = _searchRoomNumberTextField.text;
                allRoundVC.searchKeyWord = [NSString stringWithFormat:@"%@，%@",_buildingName,houseNo];
            }
            
            allRoundVC.houseNo = houseNo;
        
        
        [self.navigationController pushViewController:allRoundVC animated:YES];
    }
    
    [_searchRoomNumberTextField resignFirstResponder];
    [_textfield resignFirstResponder];
    
    return YES;
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不输入表情
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }

    // 不输入空格或某些特殊字符
    if ([string isEqualToString:@" "] || [string isEqualToString:@"'"])
    {
        return NO;
    }

   
        if (textField.tag != RoomNumberTextFieldTag)
        {
            _searchRoomNumberTextField.text = @"";
            _buildingName = @"";
            
            [self recoveryNavigation];
        }
    

    if ([string isEqualToString:@""])
    {
        return YES;
    }
    
    
        if (textField.tag == RoomNumberTextFieldTag)
        {
            // 房号---正整数  最多15位
            if (textField.text.length > 14)
            {
                return NO;
            }
            
            if ([string isEqualToString:@" "])
            {
                return NO;
            }
        }
        else
        {
          _searchRoomNumberTextField.text = @"";
        }
    
    
    // 不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)deptIdInputShouldAlphaNum:(NSString *)text
{
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if (![pred evaluateWithObject:text])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - <IFlyRecognizerViewDelegate>

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
    
    if (resultArray.count == 0)
    {
        return;
    }
    
    /**
     *  语音输入后返回的内容格式...
     *
     *  {
     bg = 0;
     ed = 0;
     ls = 0;
     sn = 1;
     ws =     (
     {
     bg = 0;
     cw =
     (
     {
     sc = "-101.93";
     w = "\U5582";
     }
     );
     },
     );
     }
     */
    
    NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
    NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error];
    
    NSMutableString *vcnMutlResultValue = [[NSMutableString alloc]init];
    
    // 语音结果最外层的数组
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
    
    for (int i = 0; i < vcnWSArray.count; i ++)
    {
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""] && vcnMutlResultValue)
    {
        if (_searchKeyWordsStr)
        {
            _searchKeyWordsStr = [_searchKeyWordsStr stringByAppendingString:vcnMutlResultValue];
        }
        else
        {
            _searchKeyWordsStr = vcnMutlResultValue;
        }
        
        _textfield.text = _searchKeyWordsStr;
        
        if (!_isSearching)
        {
            _isSearching = YES;
            [self changeSearchState];
        }
        
        [self searchPropMethod];
    }
}

/// 识别会话错误
- (void)onError: (IFlySpeechError *) error
{
    
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[SearchPropEntity class]] && _isSearching)
    {
        SearchPropEntity * searchPropEntity = [DataConvert convertDic:data toEntity:modelClass];;
        [_searchResultArr removeAllObjects];
        [_searchResultArr addObjectsFromArray:searchPropEntity.propPrompts];

        if (searchPropEntity.propPrompts.count == 0)
        {
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:_mainTableView andShow:YES];
        }
        else
        {
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2 andOnView:_mainTableView andShow:NO];
        }
        //是否需要加载更多
        [self searchLoadMore];
        [_mainTableView reloadData];
    }
}


@end
