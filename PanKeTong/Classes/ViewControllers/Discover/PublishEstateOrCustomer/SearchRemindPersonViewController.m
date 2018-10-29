//
//  SearchRemindPersonViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/29.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SearchRemindPersonViewController.h"
#import "SearchRemindPersonApi.h"
#import "DataBaseOperation.h"
#import "SearchRemindPersonCell.h"

#define SearchRemindPersonTextFieldTag  10010

@interface SearchRemindPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    UITextField *_textfield;    //搜索输入框
    __weak IBOutlet UIButton *_clearSearchHisBtn;
    
    NSMutableArray *_searchResultArr;   //搜索结果、搜索历史
    BOOL _isSearching;  //是否正在搜索
    
    DataBaseOperation *_dataBaseOperation;
    NSString *_searchRemindKeyword;    //搜索关键字
    NSString *_searchRemindTypeStr;       //搜索类型：部门、人员
    
}

@end

@implementation SearchRemindPersonViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:nil
                                            sel:nil]];
    // 添加搜索框监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    _searchRemindTypeStr = [NSString stringWithFormat:@"%@",@(_selectRemindType)];
    
    
    [self initNavView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
//    [_textfield becomeFirstResponder];
}

- (void)back
{
    [super back];
    
    if ([_textfield isFirstResponder]) {
        
        [_textfield resignFirstResponder];
    }
}

#pragma mark - init

- (void)initNavView
{
    
    UIView *topSearchView = [[UIView alloc] init];
    [topSearchView setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-100, 30)];
    UIImageView * searchIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Shape"]];
    searchIconImage.frame=CGRectMake(10, 7, 16, 16);
    
    UIImageView *searchBarBgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索框背景"]];
    [searchBarBgImage setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-100, 30)];
    
    _textfield=[[UITextField alloc]initWithFrame:CGRectMake(35, 0, APP_SCREEN_WIDTH-180, 30)];
    
    _textfield.placeholder=@"输入关键字";
    _textfield.tag = SearchRemindPersonTextFieldTag;
    _textfield.delegate=self;
    _textfield.textColor = YCTextColorAuxiliary;
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.textAlignment = NSTextAlignmentLeft;
    _textfield.enablesReturnKeyAutomatically = YES;
    _textfield.font=[UIFont systemFontOfSize:13.0];
    _textfield.clearButtonMode=UITextFieldViewModeNever;
    [_textfield setBackgroundColor:[UIColor clearColor]];
    
    [topSearchView addSubview:searchBarBgImage];
    [topSearchView addSubview:searchIconImage];
    [topSearchView addSubview:_textfield];
    
    self.navigationItem.titleView = topSearchView;
    
    [_clearSearchHisBtn addTarget:self
                           action:@selector(removeSearchRemindResultMethod)
                 forControlEvents:UIControlEventTouchUpInside];
}


- (void)initData {
    
    if (!_isFromOtherModule)
    {
        if (_isExceptMe)
        {
            _isExceptMe = NO;
        }
    }
    
    if(!_departmentKeyId || _selectRemindType == DeparmentType )
    {
        _departmentKeyId = @"";
    }
    
    _searchResultArr = [[NSMutableArray alloc]init];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    
    _isSearching = NO;
    [self changeSearchState];
}

- (void)searchRemindPersonMethod {
    
    SearchRemindPersonApi *searchRemindPersonApi = [[SearchRemindPersonApi alloc] init];
    searchRemindPersonApi.autoCompleteType = _searchRemindTypeStr;
    searchRemindPersonApi.keyWords = _searchRemindKeyword?_searchRemindKeyword:@"";
    searchRemindPersonApi.exceptMe = _isExceptMe;
    searchRemindPersonApi.departmentKeyId = _departmentKeyId;
    [_manager sendRequest:searchRemindPersonApi];
}

/**
 *  切换搜索列表显示的内容：搜索历史、搜索结果
 */
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
        }
    }
    
    [_mainTableView reloadData];
}

/**
 *  获取搜索历史数据
 */
- (void)getSearchHisData
{
      if (![CityCodeVersion isBeiJing] && ![CityCodeVersion isTianJin])
      {
          if(_departmentKeyId && ![_departmentKeyId isEqualToString:@""])
          {
              return;
          }
      }
    
	NSArray *searchHisArr = [[NSArray alloc]initWithArray:[[_dataBaseOperation selectSearchRemindResult:NO]
                                                           objectForKey:_selectRemindTypeStr]];
    [_searchResultArr removeAllObjects];
    
    for (NSInteger i = searchHisArr.count-1; i >= 0; i--)
    {
        [_searchResultArr addObject:[searchHisArr objectAtIndex:i]];
    }
}

/**
 *  清空搜索历史
 */
#pragma mark - <ClearSearchRemindResultMethod>

- (void)removeSearchRemindResultMethod
{
    
    [_dataBaseOperation deleteSearchRemindPersonResultWithType:_selectRemindTypeStr];
    
    [self getSearchHisData];
    
    _isSearching = YES;
    [self changeSearchState];
    
    [_mainTableView reloadData];
}

#pragma mark - <搜索框监听的回调方法>

- (void)searchBarChangeInput:(NSNotification *)notificationObj
{

    UITextField *searchTextfield = (UITextField *)notificationObj.object;
    
    if (searchTextfield.tag != SearchRemindPersonTextFieldTag)
    {
        return;
    }
    
    if ([searchTextfield.text isEqualToString:_searchRemindKeyword])
    {
        //防止点击确认后又发送一次同样的请求
        return;
    }
    
    _searchRemindKeyword = searchTextfield.text;
    
    if (!searchTextfield.text ||
        [searchTextfield.text isEqualToString:@""])
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
        
        [self searchRemindPersonMethod];
    }
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchRemindPersonIdentifier = @"SearchRemindPersonCell";
    
    SearchRemindPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:searchRemindPersonIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SearchRemindPersonCell"
                                              bundle:nil]
        forCellReuseIdentifier:searchRemindPersonIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:searchRemindPersonIdentifier];
    }
    
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
    
    NSString *searchResultStr ;
    
    cell.searchRemindPersonWidth.constant = 150;
    
    switch (_selectRemindType) {
        case PersonType:
        {
            // 提醒人
            cell.departmentLabel.hidden = NO;
            cell.personLabel.text = remindPersonDetailEntity.resultName;
            cell.departmentLabel.text = remindPersonDetailEntity.departmentName;
            
        }
            break;
            
        case DeparmentType:
        {
            // 提醒部门
            cell.searchRemindPersonWidth.constant = APP_SCREEN_WIDTH - 10;
            cell.personLabel.text = remindPersonDetailEntity.resultName;
            cell.departmentLabel.hidden = YES;
        }
            break;
            
        default:
            break;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    RemindPersonDetailEntity *selectRemindPersonEntity = [_searchResultArr objectAtIndex:indexPath.row];
    
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
        [_dataBaseOperation insertSearchRemindPersonResult:_selectRemindTypeStr  
                                                  andValue:jsonStr];
    }
    
    // 已经选择的提醒人
    RemindPersonDetailEntity *selectedRemindPersonEntity ;
    
    for (int i = 0; i < _selectedRemindPerson.count; i ++)
    {
        selectedRemindPersonEntity = [_selectedRemindPerson objectAtIndex:i];
        
        if ([selectedRemindPersonEntity.resultKeyId isEqualToString:
             selectRemindPersonEntity.resultKeyId])
        {
            NSString *errorMsg = [NSString stringWithFormat:@"您已添加[%@],不可重复添加\n\n",
                                  selectedRemindPersonEntity.resultName];
            [CustomAlertMessage showAlertMessage:errorMsg
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            
            return;
        }
    }
    
    [_delegate selectRemindPersonOrDepWithItem:selectRemindPersonEntity];
    
    [self back];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*NewRatio;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    //去掉两端的空格   //判断输入内容是否全是空格
    NSString *trimedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isEmpty = [NSString isEmptyWithLineSpace:textField.text];
    if (isEmpty) {
        showMsg(@"请输入要搜索的名字！");
        return YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(returnText:)]) {
        
        if (self.isPropKeyVC) {
            
            showMsg(@"请从智能提示中选择收钥匙人！");
            
        }else{
            
            [self.delegate returnText:trimedString];
            [self back];
            
        }
        
    }
    
    return YES;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[RemindPersonListEntity class]] && _isSearching)
    {
        RemindPersonListEntity *remindPersonEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_searchResultArr removeAllObjects];
        for (int i = 0; i<remindPersonEntity.userDepartments.count; i++) {
            RemindPersonDetailEntity * rpse = remindPersonEntity.userDepartments[i];
            rpse.type = _searchRemindTypeStr;
        }
        [_searchResultArr addObjectsFromArray:remindPersonEntity.userDepartments];

        [_mainTableView reloadData];
    }
}

@end
