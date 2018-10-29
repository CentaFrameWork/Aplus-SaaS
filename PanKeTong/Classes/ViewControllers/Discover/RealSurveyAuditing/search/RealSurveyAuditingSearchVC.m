//
//  SearchViewController.m
//  PanKeTong
//
//  Created by 王雅琦 on 15/9/24.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingSearchVC.h"
#import <iflyMSC/iflyMSC.h>
#import "RealSurveySearchApi.h"
#import "SearchPropEntity.h"
#import "DataBaseOperation.h"
#import "AllRoundVC.h"


@interface RealSurveyAuditingSearchVC ()<UITextFieldDelegate,IFlyRecognizerViewDelegate,
UITableViewDelegate,UITableViewDataSource>
{
    
    UITextField *_textfield;
    IFlyRecognizerView  *_iflyRecognizerView;
    BOOL _isFirstAppear;

    NSMutableArray *_searchResultArr;   //搜索结果、搜索历史
    
    NSString *_searchKeyWordsStr;   //搜索关键字
    __weak IBOutlet UITableView *_mainTableView;
    
    DataBaseOperation *_dataBaseOperation;  //数据库操作类
    
    BOOL _isSearching;  //是否正在搜索的操作
    __weak IBOutlet UIButton *_clearSearchHisBtn;   //清空搜索历史按钮
}

@end

@implementation RealSurveyAuditingSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    [self initNavView];
    
    /*
     *添加搜索框监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    [self.view endEditing:YES];
    _isFirstAppear = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFirstAppear) {
        
        _isFirstAppear = NO;
        
        [self initView];
    }
    
    [self initData];
}

- (void)initView
{
    
    [_clearSearchHisBtn addTarget:self
                           action:@selector(removeSearchResultMethodAndLoadMore)
                 forControlEvents:UIControlEventTouchUpInside];
    
    if (_searchType == TopVoidSearchType) {
        
        //语音搜索
        [self createVoiceSearch];
        
    }else if (_searchType == TopTextSearchType){
        //文字搜索
        
        //陈行修改107bug
//        [_textfield becomeFirstResponder];
    }
    
    
}

- (void)initData
{
    
    if (self.isNoShowHistoryRecord == YES) {//不显示历史记录，请求最新记录
        
        _isSearching = YES;
        
        [self searchPropMethodWithTopCount:10];
        
        return;
        
    }
    
    /**
     *  如果输入框中没有输入文字的时候，每次进入页面时需要刷新搜索历史记录
     */
    if (!_searchKeyWordsStr ||
        [_searchKeyWordsStr isEqualToString:@""]) {
        
        _searchResultArr = [[NSMutableArray alloc]init];
        
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        _isSearching = NO;
        [self changeSearchState];
    }
}

/**
 *  切换搜索列表显示的内容：搜索历史、搜索结果
 */
-(void)changeSearchState
{
    [_searchResultArr removeAllObjects];
    
    if (_isSearching) {
        
        _clearSearchHisBtn.hidden = YES;
        
    }else{
        
        [self getSearchHisData];
        
        if (_searchResultArr.count > 0) {
            
            _clearSearchHisBtn.hidden = NO;
            [_clearSearchHisBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        }else
        {
            _clearSearchHisBtn.hidden = YES;
            if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
                //没有数据的情况下先请求十个
                _isSearching = YES;
                [self searchPropMethodWithTopCount:10];
            }
        }
        
    }
    
    [_mainTableView reloadData];
    
}


/**
 *  检测是否需要加载更多
 */
- (void)searchLoadMore
{
    if (_searchResultArr.count == 10) {
        _clearSearchHisBtn.hidden = NO;
        [_clearSearchHisBtn setTitle:@"加载更多" forState:UIControlStateNormal];
        
    }else
    {
        _clearSearchHisBtn.hidden = YES;
    }
}


/**
 *  获取搜索历史数据
 */
- (void)getSearchHisData
{
    NSArray *searchHisArr;
    
    if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
        //楼盘
       searchHisArr = [[NSArray alloc]initWithArray:[[_dataBaseOperation selectRealSurveySearchResult] objectForKey:RealSurveyAuditingSearch]];
       
    }else if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG){
        //栋座
        searchHisArr = [_dataBaseOperation selectRealSurveyEstateBuildingName:_estateBuildingName];

    }

    [_searchResultArr removeAllObjects];
    
    for (NSInteger i = searchHisArr.count-1; i>=0; i--) {
        
        [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
    }
    
    
}

/**
 *  请求搜索结果
 */
- (void)searchPropMethodWithTopCount:(NSInteger)topCount
{
    RealSurveySearchApi *realSurveySearchApi = [[RealSurveySearchApi alloc] init];

    //陈行修改bug105、109
    if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
        //楼盘
        realSurveySearchApi.name = _searchKeyWordsStr;
        realSurveySearchApi.estateSelectType = [NSString stringWithFormat:@"%ld",_searchBuildingType];
        realSurveySearchApi.topCount = [NSString stringWithFormat:@"%ld", topCount];
        realSurveySearchApi.buildName = nil;
    }else if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG){
        //栋座
        realSurveySearchApi.name = _estateBuildingName;
        realSurveySearchApi.estateSelectType = [NSString stringWithFormat:@"%ld", _searchBuildingType];
        realSurveySearchApi.topCount = [NSString stringWithFormat:@"%ld", topCount];
        realSurveySearchApi.buildName = _searchKeyWordsStr;
    }

     [_manager sendRequest:realSurveySearchApi];
    
}



- (void)initNavView
{
    
    UIView *topSearchView = [[UIView alloc] init];
    [topSearchView setFrame:CGRectMake(0,
                                       0,
                                       APP_SCREEN_WIDTH-60,
                                       30)];
    [topSearchView setBackgroundColor:[UIColor clearColor]];
    UIImageView * searchIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    searchIconImage.frame=CGRectMake(10,
                                     7,
                                     16,
                                     16);
    
    UIImageView *searchBarBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框背景"]];
    [searchBarBgImage setFrame:CGRectMake(0,
                                          0,
                                          APP_SCREEN_WIDTH - 60 - 65,
                                          30)];
    
    UIButton *rightVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightVoiceButton setFrame:CGRectMake(topSearchView.bounds.size.width - 43,
                                          0,
                                          43,
                                          30)];
    
    [rightVoiceButton setImage:[UIImage imageNamed:@"voiceSearch_icon"]
                      forState:UIControlStateNormal];
    [rightVoiceButton setBackgroundColor:[UIColor clearColor]];
    [rightVoiceButton addTarget:self
                         action:@selector(createVoiceSearch)
               forControlEvents:UIControlEventTouchUpInside];
    
    _textfield=[[UITextField alloc]initWithFrame:CGRectMake(35,
                                                            0,
                                                            APP_SCREEN_WIDTH - 143,
                                                            30)];
    
    _textfield.placeholder = @"  输入楼盘名";
    _textfield.delegate = self;
    _textfield.textColor = YCTextColorAuxiliary;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.textAlignment = NSTextAlignmentLeft;
    _textfield.enablesReturnKeyAutomatically = YES;
    _textfield.font = [UIFont systemFontOfSize:13.0];
    _textfield.clearButtonMode = UITextFieldViewModeNever;
    [_textfield setBackgroundColor:[UIColor clearColor]];
    
    if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
        _textfield.placeholder = @"  输入栋座单元";

    }
    
    [topSearchView addSubview:searchBarBgImage];
    [topSearchView addSubview:searchIconImage];
    [topSearchView addSubview:rightVoiceButton];
    [topSearchView addSubview:_textfield];

    self.navigationItem.titleView = topSearchView;
    
}

- (void)back
{
    [super back];
    
    if ([_textfield isFirstResponder]) {
        
        [_textfield resignFirstResponder];
    }
    
}

- (void)createVoiceSearch
{
    if ([_textfield isFirstResponder]) {
        
        [_textfield resignFirstResponder];
    }
    __weak typeof (self) weakSelf = self;
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            //初始化语音识别控件
            if (!_iflyRecognizerView) {
                
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                //设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }
            
            _iflyRecognizerView.delegate = weakSelf;
            
            [_iflyRecognizerView start];
            
        }else{
            
            showMsg(SettingMicrophone);
        }
    }];
    
}

/**
 *  清空搜索历史
 */
#pragma mark - ClearSearchResultMethodAndLoadMore
- (void)removeSearchResultMethodAndLoadMore
{
    if ([_clearSearchHisBtn.titleLabel.text isEqualToString:@"清空搜索历史"] ) {
        if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
            [_dataBaseOperation deleteRealSurveySearchResultWithType:RealSurveyAuditingSearch];

        }
        if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
            [_dataBaseOperation deleteRealSurveySearchEstateBuildingName];
        }
        
        [self getSearchHisData];
        
        _isSearching = YES;
        [self changeSearchState];
        
        [_mainTableView reloadData];
    }
    if ([_clearSearchHisBtn.titleLabel.text isEqualToString:@"加载更多"] ) {
        //陈行修改bug105
        [self searchPropMethodWithTopCount:999];
        
//        RealSurveySearchApi *realSurveySearchApi = [[RealSurveySearchApi alloc] init];
//        if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
//            realSurveySearchApi.name = _estateBuildingName;
//            realSurveySearchApi.estateSelectType = [NSString stringWithFormat:@"%ld",_searchBuildingType];
//            realSurveySearchApi.topCount = @"999";
//            realSurveySearchApi.buildName = _searchKeyWordsStr;
//            [_manager sendRequest:realSurveySearchApi];
//        }
//        if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
//            realSurveySearchApi.name = _searchKeyWordsStr;
//            realSurveySearchApi.estateSelectType = [NSString stringWithFormat:@"%ld", _searchBuildingType];
//            realSurveySearchApi.topCount = @"999";
//            realSurveySearchApi.buildName = @"";
//            [_manager sendRequest:realSurveySearchApi];
//        }
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellString = @"searchResultCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellString];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellString];
    }
    cell.textLabel.font = [UIFont fontWithName:FontName size:14.0];
    cell.textLabel.textColor = LITTLE_GRAY_COLOR;
    
    SearchPropDetailEntity *searchDetailEntity;
    
    
    if (_isSearching) {
        
        searchDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
    }else{
        
        if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
            searchDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
        }
        
        if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
             NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];
            searchDetailEntity = [MTLJSONAdapter modelOfClass:[SearchPropDetailEntity class]
                                           fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                        error:nil];
        }
        
    }
    cell.textLabel.text = searchDetailEntity.itemText;
    
    //陈行修改104bug
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    SearchPropDetailEntity *searchPropDetailEntity;
    
    
    if (!_isSearching) {
        
        /**
         *  直接使用历史搜索的结果
         */
        if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
            //楼盘
            NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];
            
            searchPropDetailEntity = [MTLJSONAdapter modelOfClass:[SearchPropDetailEntity class]
                                               fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                            error:nil];
        }
        
         if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
             
             searchPropDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
             
         }

        
    }else{
        
        // 保存搜索记录
        if (_searchBuildingType == EstateSelectTypeEnum_ESTATENAME) {
            //楼盘
            searchPropDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
            
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:searchPropDetailEntity];
            NSString *jsonStr = [jsonDic JSONString];
            [_dataBaseOperation insertRealSurveySearchResult:RealSurveyAuditingSearch
                                                    andValue:jsonStr];
        }
        
        if (_searchBuildingType == EstateSelectTypeEnum_BUILDINGBELONG) {
            
            searchPropDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];

            
            [_dataBaseOperation insertRealSurveyEstateBuildingName:_estateBuildingName
                                                      BuildingName:searchPropDetailEntity.itemText
                                                       BuildingKey:searchPropDetailEntity.itemValue
                                                              time:[CommonMethod formatDateStrFromDate:[NSDate date]]];
            
        }
    }
    
    [_textfield resignFirstResponder];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(realSurveySearchWithKey:andValue:andSearchType:)])
    {
        [self.delegate realSurveySearchWithKey:searchPropDetailEntity.itemText andValue:searchPropDetailEntity.itemValue andSearchType:_searchBuildingType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - 搜索框监听的回调方法
- (void)searchBarChangeInput:(NSNotification *)notificationObj
{
    
    UITextField *searchTextfield = (UITextField *)notificationObj.object;
    
    if ([searchTextfield.text isEqualToString:_searchKeyWordsStr]) {
        
        //防止点击确认后又发送一次同样的请求
        return;
    }
    
    _searchKeyWordsStr = searchTextfield.text;
    
    if (!searchTextfield.text ||
        [searchTextfield.text isEqualToString:@""]) {
        
        _isSearching = NO;
        [self changeSearchState];
    }else{
        
        if (!_isSearching) {
            
            _isSearching = YES;
            [self changeSearchState];
        }
        
        
        [self searchPropMethodWithTopCount:10];
    }
    
}



#pragma mark - IFlyRecognizerViewDelegate
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
    
    if (resultArray.count == 0) {
        
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
    
    /**
     语音结果最外层的数组
     */
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
    
    for (int i = 0; i < vcnWSArray.count; i++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue) {
        
        if (_searchKeyWordsStr) {
            _searchKeyWordsStr = [_searchKeyWordsStr stringByAppendingString:vcnMutlResultValue];
        }else{
            _searchKeyWordsStr = vcnMutlResultValue;
        }
        
        _textfield.text = _searchKeyWordsStr;
        
        if (!_isSearching) {
            
            _isSearching = YES;
            [self changeSearchState];
        }
        
        [self searchPropMethodWithTopCount:10];
    }
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    if ([modelClass isEqual:[SearchPropEntity class]] && _isSearching) {
        SearchPropEntity *searchPropEntity = [DataConvert convertDic:data toEntity:modelClass];

        [_searchResultArr removeAllObjects];
        
        _searchResultArr = _searchResultArr ? : [[NSMutableArray alloc] init];
        
        [_searchResultArr addObjectsFromArray:searchPropEntity.propPrompts];

        if (searchPropEntity.propPrompts.count == 0) {

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
        }else{

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }
        //是否需要加载更多
        [self searchLoadMore];
        [_mainTableView reloadData];
    }

}

@end
