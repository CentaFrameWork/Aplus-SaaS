//
//  AutoCompleteTipViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/24.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "AutoCompleteTipViewController.h"

@interface AutoCompleteTipViewController ()
{
    UITextField *_textfield;
    BOOL _isFirstAppear;
    UserAndPublicAccountApi *_userAndPublicAccountApi;

    NSMutableArray *_searchResultArr;   //搜索结果、搜索历史
    
    NSString *_searchKeyWordsStr;   //搜索关键字
    
    DataBaseOperation *_dataBaseOperation;  //数据库操作类
    
    BOOL _isSearching;  //是否正在搜索的操作
    
    IFlyUtil *iflyUtil;
}

@end

@implementation AutoCompleteTipViewController

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
                           action:@selector(removeSearchResultMethod)
                 forControlEvents:UIControlEventTouchUpInside];
    
    if (_searchType == TopVoidSearchType) {
        
        //语音搜索
        [self createVoiceSearch];
        
    }else if (_searchType == TopTextSearchType){
        //文字搜索
        
        [_textfield becomeFirstResponder];
    }
    
    
}

- (void)initData
{
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
- (void)changeSearchState
{
    
    [_searchResultArr removeAllObjects];
    
    if (_isSearching) {
        
        _clearSearchHisBtn.hidden = YES;
        
    }else{
        
        [self getSearchHisData];
        
        if (_searchResultArr.count > 0) {
            
            _clearSearchHisBtn.hidden = NO;
        }
        
    }
    
    [_mainTableView reloadData];
    
}

/**
 *  获取搜索历史数据
 */
- (void)getSearchHisData
{
    
    NSArray *searchHisArr =[_dataBaseOperation selectChiefOrPublicAccount];
    [_searchResultArr removeAllObjects];
    
    for (NSInteger i = searchHisArr.count-1; i>=0; i--) {
        
        [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
    }
    
}

/**
 *  请求搜索结果
 */
- (void)searchPropMethod
{
    
    if ([CommonMethod content:_searchKeyWordsStr containsWith:@"'" ]) {
        _searchKeyWordsStr = [NSString stringWithFormat:@"%@",
                              [_searchKeyWordsStr stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    }
    
    _userAndPublicAccountApi = [[UserAndPublicAccountApi alloc] init];
    _userAndPublicAccountApi.keyWords = _searchKeyWordsStr;
    _userAndPublicAccountApi.topCount = @"10";
    [_manager sendRequest:_userAndPublicAccountApi];
    
}

- (void)initNavView
{
    
    UIView *topSearchView = [[UIView alloc] init];
    [topSearchView setFrame:CGRectMake(0,
                                       0,
                                       APP_SCREEN_WIDTH-65,
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
                                          APP_SCREEN_WIDTH-65,
                                          30)];
    
    UIButton *rightVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightVoiceButton setFrame:CGRectMake(topSearchView.bounds.size.width-43,
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
                                                            APP_SCREEN_WIDTH-143,
                                                            30)];
    
    _textfield.placeholder=@"原归属人或公共池";
//    [_textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textfield.delegate=self;
    _textfield.textColor = [UIColor whiteColor];
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.textAlignment = NSTextAlignmentLeft;
    _textfield.enablesReturnKeyAutomatically = YES;
    _textfield.font=[UIFont systemFontOfSize:13.0];
    _textfield.clearButtonMode=UITextFieldViewModeNever;
    [_textfield setBackgroundColor:[UIColor clearColor]];
    
    
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
    
    if(!iflyUtil)
    {
        iflyUtil = [IFlyUtil initWithDelegate:self];
    }
    [iflyUtil showAtPoint:self.view.center];
    
}

#pragma mark - IFlyUtilDelegate
- (void)ifFlyRecognizedResult:(NSString *)result
{
    if (_searchKeyWordsStr) {
        _searchKeyWordsStr = [_searchKeyWordsStr stringByAppendingString:result];
    }else{
       _searchKeyWordsStr = result;
    }
    
    _textfield.text = _searchKeyWordsStr;
    
    if (!_isSearching) {
        
        _isSearching = YES;
        [self changeSearchState];
    }
    
    [self searchPropMethod];
}

/**
 *  清空搜索历史
 */
#pragma mark - ClearSearchResultMethod
-(void)removeSearchResultMethod
{
    
    [_dataBaseOperation deleteAllChiefOrPublicAccount];
    
    [self getSearchHisData];
    
    _isSearching = YES;
    [self changeSearchState];
    
    [_mainTableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellString = @"searchResultCellId";
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellString];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellString];
    }
    cell.textLabel.font = [UIFont fontWithName:FontName size:14.0];
    cell.textLabel.textColor = LITTLE_GRAY_COLOR;
    
    RemindPersonDetailEntity *remindPersonDetailEntity;
    
    if (_isSearching) {
        
        remindPersonDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
    }else{
        
        //
        remindPersonDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
    }
    
    
    if(remindPersonDetailEntity.userOrDepart == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",
                               remindPersonDetailEntity.resultName,
                               remindPersonDetailEntity.departmentName];
    }else{
        cell.textLabel.text = remindPersonDetailEntity.resultName;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    RemindPersonDetailEntity *remindPersonDetailEntity;
    
    if (!_isSearching) {
        
        /**
         *  直接使用历史搜索的结果
         */
        remindPersonDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
        
    }else{
        
        /**
         *  保存搜索记录
         */
        remindPersonDetailEntity = [_searchResultArr objectAtIndex:indexPath.row];
        [_dataBaseOperation insertChiefOrPublicAccount:remindPersonDetailEntity];
    }
    
    [_textfield resignFirstResponder];
    
    
    
    //从其他页面进入搜索，这种情况直接返回列表
    
    if ([_delegate respondsToSelector:@selector(autoCompleteWithEntity:)]) {
                
        [_delegate performSelector:@selector(autoCompleteWithEntity:)
                        withObject:remindPersonDetailEntity];
        [self back];
    }
    
    
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
        
        [self searchPropMethod];
    }
    
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    if ([modelClass isEqual:[UserAndPublicAccountEntity class]] &&
        _isSearching) {

        UserAndPublicAccountEntity * userAndPublicAccountEntity = [DataConvert convertDic:data toEntity:modelClass];

        [_searchResultArr removeAllObjects];
        [_searchResultArr addObjectsFromArray:userAndPublicAccountEntity.userDepartmentDatas];

        if (userAndPublicAccountEntity.userDepartmentDatas.count == 0) {

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
        }else{

            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:NO];
        }
        
        [_mainTableView reloadData];
    }


}


@end
