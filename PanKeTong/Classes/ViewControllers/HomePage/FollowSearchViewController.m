//
//  FollowSearchViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/4/25.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "FollowSearchViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "SearchRemindPersonApi.h"
#import "RemindPersonListEntity.h"
#import "SelectBtnView.h"
@interface FollowSearchViewController ()<UITextFieldDelegate,UIPopoverPresentationControllerDelegate,
IFlyRecognizerViewDelegate,UITableViewDelegate,UITableViewDataSource,SelectBtnDelegate>
{
    UITextField *_textfield;
    
    IFlyRecognizerView  *_iflyRecognizerView;
    
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *_clearSearchHisBtn;
    
    DataBaseOperation *_dataBaseOperation;
    NSMutableArray *_searchResultArr;
    NSString *_searchSalesmanKeyword;           // 搜索关键字
    NSString *_searchSalesmanStr;               // 搜索类型：关键字、业务员
    NSString *_departmentKeyId;                 // 部门Id
    
    BOOL _showSearchHistory;                    // 显示搜索历史
    BOOL _isSearching;                          // 是否正在搜索的操作
}
@property (nonatomic,strong) SelectBtnView *selectView;
@end

@implementation FollowSearchViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavView];
    [self initData];
    
    // 添加搜索框监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    [self.view endEditing:YES];
}


#pragma mark - ********视图*********

-(void)initNavView {
    
    
    [self setNavTitle:@"检索"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    _selectView = [[SelectBtnView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 120) andTitleArr:@[@"业务员",@"关键字"]];
    
    _selectView.selectBtnDelegate = self;
    
    
    [self.view addSubview:_selectView];
    
    
    
    // 中间的Navview
    UIView *topSearchView = [[UIView alloc] initWithFrame:CGRectMake(12, 60, APP_SCREEN_WIDTH-24, 50)];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-24, 50)];
    top.backgroundColor = [UIColor whiteColor];
    top.layer.shadowColor = RGBColor(210, 210, 210).CGColor;
    top.layer.shadowOffset = CGSizeMake(0, 4);
    top.layer.shadowOpacity = 0.8;
    top.layer.shadowRadius = 4;
    top.layer.cornerRadius = 5;
    [topSearchView addSubview:top];
    
    UIImageView * searchIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    searchIconImage.frame = CGRectMake(12, 14, 22, 22);
    
    
    
    
    UIButton *rightVoiceButton = [[UIButton alloc] initWithFrame:CGRectMake(topSearchView.width-60, 0, 50, 50)];
    
    
    [rightVoiceButton setImage:[UIImage imageNamed:@"top_right_04"]
                      forState:UIControlStateNormal];
    [rightVoiceButton addTarget:self
                         action:@selector(createVoiceSearch)
               forControlEvents:UIControlEventTouchUpInside];
    
    _textfield = [[UITextField alloc]initWithFrame:CGRectMake(searchIconImage.right+10, 10, APP_SCREEN_WIDTH-163, 30)];
    _textfield.placeholder = @"请输入业务员";
    _textfield.delegate = self;
    _textfield.textColor = YCTextColorAuxiliary;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.enablesReturnKeyAutomatically = YES;
    _textfield.font = [UIFont systemFontOfSize:16.0];
    
    
    
    
    
    [topSearchView addSubview:searchIconImage];
    [topSearchView addSubview:rightVoiceButton];
    [topSearchView addSubview:_textfield];
    
    [_selectView addSubview:topSearchView];
    
    
    
    [_clearSearchHisBtn addTarget:self
                           action:@selector(removeSearchRemindResultMethod)
                 forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (_searchType == TopVoidSearchType)
    {
        // 语音搜索
        [self createVoiceSearch];
        
    }else if (_searchType == TopTextSearchType)
    {
        // 文字搜索
        [_textfield becomeFirstResponder];
    }
    
    
}

- (void)didSelectWithBtnIndex:(NSInteger)selectBtnIndex {
    
    
    if (!selectBtnIndex) {
        _isKeyword = NO;
        _textfield.placeholder = @"请输入业务员";
        [self changeSearchState];
        
    }else{
        
        _isKeyword = YES;
        _textfield.placeholder = @"请输入关键字";
        [self changeSearchState];
    }
    
    _textfield.text = @"";
    _searchSalesmanKeyword = @"";
    
}


-(void)initData {
    if(!_departmentKeyId)
    {
        _departmentKeyId = @"";
    }
    
    _searchResultArr = [[NSMutableArray alloc]init];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    
    _isSearching = NO;
    [self changeSearchState];
}

-(void)searchInfoMethod
{
    SearchRemindPersonApi *searchRemindPersonApi = [[SearchRemindPersonApi alloc] init];
    searchRemindPersonApi.autoCompleteType = @"1";
    searchRemindPersonApi.keyWords = _searchSalesmanKeyword?_searchSalesmanKeyword:@"";
    searchRemindPersonApi.exceptMe = NO;
    searchRemindPersonApi.departmentKeyId = _followDeptKeyId?_followDeptKeyId:@"";
    [_manager sendRequest:searchRemindPersonApi];
}

/**
 *  切换搜索列表显示的内容：搜索历史、搜索结果
 */
- (void)changeSearchState
{
    
    [_searchResultArr removeAllObjects];
    
    _clearSearchHisBtn.hidden = YES;
    if (!_isSearching)
    {
        [self getSearchHisData:_isKeyword];
        _clearSearchHisBtn.hidden = (_searchResultArr.count == 0);// 是否隐藏“清空搜索历史”按钮
    }
    
    [_mainTableView reloadData];
    
}

/**
 *  获取搜索历史数据
 */
-(void)getSearchHisData:(BOOL)isKeywords
{
    if (isKeywords)
    {
        //FIXME: 获取关键字数据库数据
        NSArray *searchHisArr = [[NSArray alloc]initWithArray:[[_dataBaseOperation selectSearchRemindResult:YES]
                                                               objectForKey:@"KeywordsRemindType"]];
        [_searchResultArr removeAllObjects];
        
        for (NSInteger i = searchHisArr.count-1; i>=0; i--) {
            
            [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
        }
        
    }
    else
    {
        if(_departmentKeyId && ![_departmentKeyId isEqualToString:@""])
        {
            return;
        }
        
        NSArray *searchHisArr = [[NSArray alloc]initWithArray:[[_dataBaseOperation selectSearchRemindResult:NO]
                                                               objectForKey:@"PersonRemindType"]];
        [_searchResultArr removeAllObjects];
        
        RemindPersonDetailEntity *remindPersonDetailEntity;
        
        for (NSInteger i = searchHisArr.count-1; i>=0; i--) {
            
            remindPersonDetailEntity = [searchHisArr objectAtIndex:i];
            
            
            NSString *searchHisValueStr = [searchHisArr objectAtIndex:i];
            
            remindPersonDetailEntity = [MTLJSONAdapter modelOfClass:[RemindPersonDetailEntity class]
                                                 fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                              error:nil];
            if ([remindPersonDetailEntity.departmentKeyId isEqualToString:_followDeptKeyId])
            {
                
                [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
            }
            
            if (_followDeptKeyId.length < 1)
            {
                
                [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
            }
        }
    }
}

/**
 *  清空搜索历史
 */
#pragma mark - ClearSearchRemindResultMethod
-(void)removeSearchRemindResultMethod
{
    if (_isKeyword)
    {
        
        [_dataBaseOperation deleteSearchRemindPersonResultWithType:@"KeywordsRemindType"];
        
        [self getSearchHisData:NO];
        
        [self changeSearchState];
        
        [_mainTableView reloadData];
        
    }
    else
    {
        [_dataBaseOperation deleteSearchRemindPersonResultWithType:@"PersonRemindType"];
        
        [self getSearchHisData:NO];
        
        //		_isSearching = YES;
        [self changeSearchState];
        
        [_mainTableView reloadData];
    }
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellString = @"CellString";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellString];
    
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellString];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"icon_im_search_record"];
    cell.textLabel.textColor = YCTextColorGray;
    cell.textLabel.font = [UIFont fontWithName:FontName
                                          size:14.0];
    
    RemindPersonDetailEntity *remindPersonDetailEntity;
    
    if (_isSearching)
    {
        remindPersonDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
        
    }
    else
    {
        
        NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];
        
        remindPersonDetailEntity = [MTLJSONAdapter modelOfClass:[RemindPersonDetailEntity class]
                                             fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                          error:nil];
    }
    
    NSString *searchResultStr;
    
    if (_isKeyword)
    {
        searchResultStr = [NSString stringWithFormat:@"%@",
                           remindPersonDetailEntity.resultName];
    }
    else
    {
        
        searchResultStr = [NSString stringWithFormat:@"%@(%@)",
                           remindPersonDetailEntity.resultName,
                           remindPersonDetailEntity.departmentName];
    }
    
    cell.textLabel.text = searchResultStr;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    RemindPersonDetailEntity *selectRemindPersonEntity = [_searchResultArr objectAtIndex:indexPath.row];
    
    if (_isKeyword)
    {
        
        if (_isSearching)
        {
            // 保存搜索记录
            selectRemindPersonEntity = [_searchResultArr objectAtIndex:indexPath.row];
            
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:selectRemindPersonEntity];
            NSString *jsonStr = [jsonDic JSONString];
            [_dataBaseOperation insertSearchRemindPersonResult:@"KeywordsRemindType"
                                                      andValue:jsonStr];
        }
        else
        {
            // FIXME: 点击返回上个页面，并显示结果
            // 取出数据库中的数据
            NSArray *searchHisArr = [[NSArray alloc]initWithArray:[[_dataBaseOperation selectSearchRemindResult:YES]
                                                                   objectForKey:@"KeywordsRemindType"]];
            NSInteger index = searchHisArr.count-1-indexPath.row;
            NSString *jsonStr = searchHisArr[index];
            RemindPersonDetailEntity *selectRemindPersonEntity = [MTLJSONAdapter modelOfClass:[RemindPersonDetailEntity class]
                                                                           fromJSONDictionary:[jsonStr jsonDictionaryFromJsonString]
                                                                                        error:nil];
            
            if ([_delegate respondsToSelector:@selector(searchResultWithItem:)])
            {
                
                [_delegate performSelector:@selector(searchResultWithItem:)
                                withObject:selectRemindPersonEntity];
                [self back];
            }
        }
        
        return;
    }
    
    if (!_isSearching)
    {
        // 直接使用历史搜索的结果
        NSString *searchHisValueStr = [_searchResultArr objectAtIndex:indexPath.row];
        
        selectRemindPersonEntity = [MTLJSONAdapter modelOfClass:[RemindPersonDetailEntity class]
                                             fromJSONDictionary:[searchHisValueStr jsonDictionaryFromJsonString]
                                                          error:nil];
        
    }
    else
    {
        // 保存搜索记录
        selectRemindPersonEntity = [_searchResultArr objectAtIndex:indexPath.row];
        
        NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:selectRemindPersonEntity];
        NSString *jsonStr = [jsonDic JSONString];
        [_dataBaseOperation insertSearchRemindPersonResult:@"PersonRemindType"
                                                  andValue:jsonStr];
    }
    
    [_textfield resignFirstResponder];
    
    //从其他页面进入搜索，这种情况直接返回列表
    if ([_delegate respondsToSelector:@selector(searchResultWithItem:)])
    {
        
        [_delegate performSelector:@selector(searchResultWithItem:)
                        withObject:selectRemindPersonEntity];
        [self back];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark - SearchBarNotification搜索框监听的回调方法

-(void)searchBarChangeInput:(NSNotification *)notificationObj
{
    
    UITextField *searchTextfield = (UITextField *)notificationObj.object;
    
    if ([searchTextfield.text isEqualToString:_searchSalesmanKeyword])
    {
        //防止点击确认后又发送一次同样的请求
        return;
    }
    
    _searchSalesmanKeyword = searchTextfield.text;
    
    if (_isKeyword)
    {
        return;
    }
    if (!searchTextfield.text
        ||[searchTextfield.text isEqualToString:@""] )
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
        
        [self searchInfoMethod];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_isKeyword == NO)
    {
        showMsg(@"请在智能提示中选择!");
    }
    else
    {
        
        // 保存关键字到数据库中
        RemindPersonDetailEntity *selectRemindPersonEntity = [[RemindPersonDetailEntity alloc] init];
        selectRemindPersonEntity.resultName = textField.text;
        NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:selectRemindPersonEntity];
        NSString *jsonStr = [jsonDic JSONString];
        
        [_dataBaseOperation insertSearchRemindPersonResult:@"KeywordsRemindType"
                                                  andValue:jsonStr];
        
        if ([_delegate respondsToSelector:@selector(searchResultWithItem:)])
        {
            [_delegate performSelector:@selector(searchResultWithItem:)
                            withObject:selectRemindPersonEntity];
            [self back];
        }
        
    }
    
    return YES;
}

-(void)back
{
    [super back];
    
    if ([_textfield isFirstResponder])
    {
        [_textfield resignFirstResponder];
    }
}


-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return  UIModalPresentationNone;
}

#pragma mark - 语音搜索
-(void)createVoiceSearch
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
            if (!_iflyRecognizerView) {
                
                
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(APP_SCREEN_WIDTH * 0.5, APP_SCREEN_HEIGHT * 0.5)];
                
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm"
                                           forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
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

#pragma mark - IFlyRecognizerViewDelegate
/** 识别结果返回代理
 *  @param resultArray  识别结果
 *  @param isLast       表示是否最后一次结果
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
    
    for (int i = 0; i<vcnWSArray.count; i++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""]
        && vcnMutlResultValue)
    {
        
        _textfield.text = vcnMutlResultValue;
        _searchSalesmanKeyword = vcnMutlResultValue;
        
        // FIXME: 语音输入口直接跳转页面，搜索关键字
        if (!_isSearching)
        {
            _isSearching = YES;
            [self changeSearchState];
        }
        
        [self searchPropMethod];
        
        [_textfield becomeFirstResponder];
    }
}

-(void)searchPropMethod
{
    
    if (!_isSearching)
    {
        _isSearching = YES;
        [self changeSearchState];
    }
    
    [self searchInfoMethod];
}

/** 识别会话错误返回代理
 *  @param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass{
    if ([modelClass isEqual:[RemindPersonListEntity class]] && _isSearching)
    {
        RemindPersonListEntity *remindPersonEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_searchResultArr removeAllObjects];
        [_searchResultArr addObjectsFromArray:remindPersonEntity.userDepartments];
        
        [_mainTableView reloadData];
        
    }
}



@end
