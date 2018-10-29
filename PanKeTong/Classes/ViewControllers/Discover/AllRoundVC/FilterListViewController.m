//
//  FilterListViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "FilterListViewController.h"
#import "DataBaseOperation.h"
#import "FilterListTableViewCell.h"
#import "DataFilterEntity.h"

#define RemoveAlertTag      100000

#define SetDataNameTag      200000

#define CueAlertTag         10000000     //提示alertViewTag

@interface FilterListViewController ()<UITableViewDataSource,UITableViewDelegate,FilterListDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    NSString * _string;
    DataBaseOperation * _dataBaseOperation;
    DataFilterEntity * _currentSelectEntity;
    NSMutableArray * _dataArray;    //数据源数组
    BOOL _isEstCurrent[20];    //默认筛选
    BOOL _isSendService;    //是否发送请求
    BOOL _isSettingName;    //是否修改名字了
    BOOL _isPresentOption;  //是否是当前选项
    
    NSInteger _presentSelect;   //当前选中的
    NSInteger _number;        //选中的第几个为默认
    
}

@property (nonatomic, strong)UIView *maskView;  // 黑色透明
@property (nonatomic, strong)UIView *viewdibu;  // 白色
@property (nonatomic, strong)UITextField *textField;

@end

@implementation FilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘落下的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initData];
    [self initNavTitleView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    
    //遍历默认选项 找到默认
    for (NSInteger i = 0; i <_dataArray.count; i++) {
        
        DataFilterEntity * entity=_dataArray[i];
        FilterEntity * filterEntity=[MTLJSONAdapter modelOfClass:[FilterEntity class]
                                              fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                           error:nil];
        if (filterEntity.isCurrent)
        {
            _currentSelectEntity=entity;
            continue;
        }
        _isEstCurrent[i] = YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    // 修改搜索名
    [self PopUpView];
}

// 修改搜索名
- (void)PopUpView {
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _maskView.hidden = YES;
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[[UIApplication sharedApplication] delegate].window addSubview:_maskView];
    
    // 底部view
    _viewdibu = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, (APP_SCREEN_HEIGHT-223*NewRatio)/2, APP_SCREEN_WIDTH-24*NewRatio, 217*NewRatio)];
    _viewdibu.userInteractionEnabled = YES;
    _viewdibu.layer.cornerRadius = 5*NewRatio;
    _viewdibu.clipsToBounds = YES;
    _viewdibu.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *dateTapgg = [[UITapGestureRecognizer alloc] init];
    [[dateTapgg rac_gestureSignal]subscribeNext:^(id x) {
        
    }];
    [_viewdibu addGestureRecognizer:dateTapgg];
    [_maskView addSubview:_viewdibu];
    
    // 修改搜索名
    UILabel *labelstr = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 24*NewRatio, 300*NewRatio, 24*NewRatio)];
    labelstr.textColor = YCTextColorBlack;
    labelstr.font = [UIFont systemFontOfSize:24*NewRatio];
    labelstr.text = @"修改搜索名";
    [_viewdibu addSubview:labelstr];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(labelstr.frame)+24*NewRatio, CGRectGetWidth(_viewdibu.frame)-24*2*NewRatio, 35*NewRatio)];
    _textField.backgroundColor = YCOtherColorBackground;
    _textField.layer.cornerRadius = 5*NewRatio;
    _textField.delegate=self;
    _textField.clipsToBounds = YES;
    _textField.clearButtonMode=UITextFieldViewModeAlways;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 5)];
    [_viewdibu addSubview:_textField];
    
    
    // 取消按钮
    UIButton * buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(_textField.frame)+25*NewRatio, 140*NewRatio, 50*NewRatio)];
    buttonCancel.layer.cornerRadius = 5*NewRatio;
    buttonCancel.clipsToBounds = YES;
    buttonCancel.backgroundColor = YCTextColorRentOrange;
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:17*NewRatio];
    [_viewdibu addSubview:buttonCancel];
    [[buttonCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        _maskView.hidden = YES; // 影子点击事件
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }];
    
    UIButton * buttonDetermine = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame)+24*NewRatio, CGRectGetMaxY(_textField.frame)+25*NewRatio, 140*NewRatio, 50*NewRatio)];
    buttonDetermine.layer.cornerRadius = 5*NewRatio;
    buttonDetermine.clipsToBounds = YES;
    buttonDetermine.backgroundColor = YCThemeColorGreen;
    [buttonDetermine setTitle:@"确定" forState:UIControlStateNormal];
    [buttonDetermine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonDetermine.titleLabel.font = [UIFont systemFontOfSize:17*NewRatio];
    [_viewdibu addSubview:buttonDetermine];
    [[buttonDetermine rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        _maskView.hidden = YES; // 影子点击事件
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString * nameString = [_textField.text stringByTrimmingCharactersInSet:whitespace];
        
        NSMutableArray * allInfoArray =[NSMutableArray arrayWithCapacity:0];
        NSArray * array=[_dataBaseOperation selectAllFilterCondition];
        for (NSInteger i = array.count-1; i>=0; i--) {
            
            [allInfoArray addObject:[array objectAtIndex:i]];
        }
        DataFilterEntity * entity= allInfoArray[_number];
        if ([entity.nameString isEqualToString:nameString])
        {
            [CustomAlertMessage showAlertMessage:@"保存成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            return;
        }
        for (int i=0; i<allInfoArray.count; i++)
        {
            DataFilterEntity * entity= allInfoArray[i];
            if ([entity.nameString isEqualToString:nameString])
            {
                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"为方便您区分搜索条件,请不要保存重复的别名"
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"确定", nil];
                alertView.tag=CueAlertTag;
                [alertView show];
                return;
            }
        }
        DataFilterEntity * dataEntity=_dataArray[_number];
        if ([nameString isEqualToString:@""]||[self isBlankString:nameString])
        {
            [CustomAlertMessage showAlertMessage:@"搜索名不可为空\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
        }
        else
        {
            
            //去除字符串前端的空格
            
            [_dataBaseOperation updateFilterConditionName:nameString from:dataEntity.nameString];
            [_dataArray removeAllObjects];
            NSArray * array=[_dataBaseOperation selectAllFilterCondition];
            _dataArray=[NSMutableArray arrayWithCapacity:0];
            for (NSInteger i = array.count-1; i>=0; i--) {
                
                [_dataArray addObject:[array objectAtIndex:i]];
            }
            
            _isSettingName=YES;
        }
        
        if (_isPresentOption) {
            [CommonMethod setUserdefaultWithValue:nameString forKey:NameString];
        }
        
        [_mainTableView reloadData];
    }];
    
}

//把输入框给顶上去了
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    if ((APP_SCREEN_HEIGHT-CGRectGetMaxY(_viewdibu.frame)) < height) {
        CGRect frame = _viewdibu.frame;
        frame.origin.y = APP_SCREEN_HEIGHT-(height+frame.size.height);
        _viewdibu.frame = frame;
    }
}
//把输入框给降下来的
- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect frame = _viewdibu.frame;
    frame.origin.y = (APP_SCREEN_HEIGHT-frame.size.height)/2;
    _viewdibu.frame = frame;
}

-(void)textFiledChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *resultStr = textField.text;
    
    if (textField.text.length>15)
    {
        resultStr = [resultStr substringToIndex:15];
        textField.text=resultStr;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (MODEL_VERSION >= 7.0) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (MODEL_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    // 取消所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initData
{
    _isPresentOption = NO;
    
    _dataBaseOperation=[DataBaseOperation sharedataBaseOperation];
    NSArray * array=[_dataBaseOperation selectAllFilterCondition];
    _dataArray=[NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = array.count-1; i>=0; i--) {
        
        [_dataArray addObject:[array objectAtIndex:i]];
    }
}
-(void)initNavTitleView
{
    [self setNavTitle:@"所有搜索条件"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"清空"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(removeAllFilter)]];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getFilterListEntity:_currentSelectEntity?_currentSelectEntity:nil
                         isSendService:_isSendService
                         isSettingName:_isSettingName];
}
//清空提示alert
-(void)removeAllFilter
{
    if (_dataArray.count==0)
    {
        showMsg(@"暂无搜索条件")
    }
    else
    {
        UIAlertView * removeAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                            message:@"您确定要清空所有的筛选条件?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        removeAlert.tag=RemoveAlertTag;
        [removeAlert show];
    }
    
}
#pragma mark TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DataFilterEntity * entity=_dataArray[section];
    NSArray * array=[entity.showText componentsSeparatedByString:@","];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    FilterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[FilterListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_dataArray.count>0)
    {
        DataFilterEntity * entity=_dataArray[indexPath.section];
        NSString * showText=[entity.showText substringWithRange:NSMakeRange(0,entity.showText.length)];
        NSArray * array=[showText componentsSeparatedByString:@","];
        cell.string = array[indexPath.row];
        return cell.Max;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *viewwer = [[UIView alloc] initWithFrame:CGRectMake(0, 12*NewRatio-1, APP_SCREEN_WIDTH, 1)];
    viewwer.backgroundColor = YCOtherColorDivider;
    [view addSubview:viewwer];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (_dataArray.count>0)
    {
        DataFilterEntity * entity=_dataArray[section];
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        UILabel * headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(12*NewRatio, 0, 300*NewRatio, 43*NewRatio)];
        headerLabel.font=[UIFont fontWithName:FontName size:14.0*NewRatio];
        headerLabel.textColor=YCTextColorBlack;
        headerLabel.text=entity.nameString;
        [view addSubview:headerLabel];
        
        UILabel * currentLabel=[[UILabel alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH-62*NewRatio, 0, 50*NewRatio, 43*NewRatio)];
        currentLabel.text=@"默认";
        currentLabel.textColor=YCTextColorGray;
        currentLabel.font=[UIFont fontWithName:FontName size:14.0*NewRatio];
        currentLabel.textAlignment = NSTextAlignmentRight;
        currentLabel.hidden=_isEstCurrent[section];
        [view addSubview:currentLabel];
        
        UILabel * line=[[UILabel alloc]initWithFrame:CGRectMake(12*NewRatio, 43*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, 1)];
        line.backgroundColor=YCOtherColorDivider;
        [view addSubview:line];
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, APP_SCREEN_WIDTH, 43*NewRatio);
        button.tag=section;
        [button addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    return nil;
}
-(void)headerButtonClick:(UIButton *)button
{
    NSString * settingString;
    
    if (_isEstCurrent[button.tag])
    {
        settingString=@"设为默认";
        
    }
    else
    {
        settingString=@"取消默认";
    }
    
    NSArray * listArr = @[@"修改搜索名",settingString,@"设为默认并立即查询",@"删除"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        _number = optionValue;
        _isSendService=NO;
        _isSettingName=NO;
        DataFilterEntity * entity  =_dataArray[_number];
        switch (optionValue)
        {
            case 0:
                [weakSelf setDataNameAlert];
                break;
            case 1:
                [weakSelf setCurrent:_number];
                break;
            case 2:
                _isSendService=YES;
                [weakSelf setCurrent:_number];
                
                [weakSelf back];
                
                break;
            case 3:
                [_dataBaseOperation deleteFilterConditionName:entity.nameString];
                if (entity==_currentSelectEntity)
                {
                    _currentSelectEntity=nil;
                    for (NSInteger i = 0; i <_dataArray.count; i++) {
                        _isEstCurrent[i] = YES;
                    }
                    
                    [CommonMethod setUserdefaultWithValue:nil forKey:NameString];
                    
                }
                [_dataArray removeObjectAtIndex:optionValue];
                if (_dataArray.count==0)
                {
                    [weakSelf noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                        andOnView:_mainTableView
                                          andShow:YES];
                }else{
                    
                    [weakSelf noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                        andOnView:_mainTableView
                                          andShow:NO];
                }
                
                [CommonMethod setUserdefaultWithValue:nil forKey:KeyWord];
                
                break;
            case 4:
                
                break;
                
            default:
                break;
        }
        [_mainTableView reloadData];
        
    }];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count>0)
    {
        return 56*NewRatio;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12*NewRatio;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier=@"filterListCell";
    FilterListTableViewCell * filterListCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!filterListCell) {
        
        filterListCell = [[FilterListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        filterListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataArray.count>0)
    {
        DataFilterEntity * entity=_dataArray[indexPath.section];
        NSString * showText=[entity.showText substringWithRange:NSMakeRange(0,entity.showText.length)];
        NSArray * array=[showText componentsSeparatedByString:@","];
        
        filterListCell.string = array[indexPath.row];
        
    }
    return filterListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _presentSelect = indexPath.section;
    
    NSString * settingString;
    
    if (_isEstCurrent[indexPath.section])
    {
        settingString=@"设为默认";
        
    }
    else
    {
        settingString=@"取消默认";
    }
    
    
    NSArray * listArr = @[@"修改搜索名",settingString,@"设为默认并立即查询",@"删除"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        _number=indexPath.section;
        _isSendService=NO;
        _isSettingName=NO;
        DataFilterEntity * entity  =_dataArray[_number];
        switch (optionValue)
        {
            case 0:
                [weakSelf setDataNameAlert];
                break;
            case 1:
                [weakSelf setCurrent:_number];
                break;
            case 2:
                _isSendService=YES;
                [weakSelf setCurrent:_number];
                
                [weakSelf back];
                
                break;
            case 3:
                [_dataBaseOperation deleteFilterConditionName:entity.nameString];
                if (entity==_currentSelectEntity)
                {
                    _currentSelectEntity=nil;
                    for (NSInteger i = 0; i <_dataArray.count; i++) {
                        _isEstCurrent[i] = YES;
                    }
                    
                    [CommonMethod setUserdefaultWithValue:nil forKey:NameString];
                    
                }
                [_dataArray removeObjectAtIndex:indexPath.section];
                if (_dataArray.count==0)
                {
                    [weakSelf noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                        andOnView:_mainTableView
                                          andShow:YES];
                }else{
                    
                    [weakSelf noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                        andOnView:_mainTableView
                                          andShow:NO];
                }
                
                [CommonMethod setUserdefaultWithValue:nil forKey:KeyWord];
                
                break;
            case 4:
                
                break;
                
            default:
                break;
        }
        [_mainTableView reloadData];
        
    }];

    
//    BYActionSheetView *actionSheetView = [[BYActionSheetView alloc] initWithTitle:nil
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"取消"
//                                                                otherButtonTitles:@"修改搜索名",settingString,@"设为默认并立即查询",@"删除",  nil];
//    actionSheetView.tag = indexPath.section+1000;
//
//    [actionSheetView show];
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma  mark - UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0&&alertView.tag==CueAlertTag)
    {
        [self setDataNameAlert];
    }
    if (buttonIndex==1)
    {
        if (alertView.tag==RemoveAlertTag)
        {
            _currentSelectEntity=nil;
            [CommonMethod setUserdefaultWithValue:nil forKey:KeyWord];
            [_dataBaseOperation deleteAllFilterCondition];
            [_dataArray removeAllObjects];
            [CustomAlertMessage showAlertMessage:@"已清空\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            
            [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                andOnView:_mainTableView
                                  andShow:YES];
            
            [CommonMethod setUserdefaultWithValue:nil forKey:NameString];
        }
    }
    [_mainTableView reloadData];
}
//名字为空格时 也为空
- (BOOL) isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) { return YES; }
    if ([string isKindOfClass:[NSNull class]]) { return YES; }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

//遍历默认选项 找到默认
-(void)setCurrent:(NSInteger)count
{
    for (NSInteger i = 0; i <_dataArray.count; i++) {
        
        DataFilterEntity * entity=_dataArray[i];
        FilterEntity * filterEntity=[MTLJSONAdapter modelOfClass:[FilterEntity class]
                                              fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString]
                                                           error:nil];
        if (i == count)
        {
            
            NSString * showText=[entity.showText substringWithRange:NSMakeRange(0,entity.showText.length-2)];
            NSArray * array=[showText componentsSeparatedByString:@","];
            NSString *firstKey = [array[0] substringWithRange:NSMakeRange(0,3)];
            NSString *keyWord;
            
            // 房源编号
            if (filterEntity.propertyNo.length > 0)
            {
                keyWord = filterEntity.propertyNo;
            }
            
            if ([firstKey isEqualToString:@"关键字"]) {
                 keyWord = [array[0] substringFromIndex:4];
            }
        
            
            if (_isSendService)
            {
                _isEstCurrent[i]=NO;
                filterEntity.isCurrent=YES;
                NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:filterEntity];
                NSString * valueString=[jsonDic JSONString];
                [_dataBaseOperation updateFilterConditionIsCurrent:valueString fromFilterName:entity.nameString];
                entity.entity=valueString;
                _currentSelectEntity=entity;
                
                
                [CommonMethod setUserdefaultWithValue:keyWord forKey:KeyWord];
                [CommonMethod setUserdefaultWithValue:entity.nameString forKey:NameString];
            }
            else
            {
                if (!_isEstCurrent[i])
                {
                    //取消默认
                    _isEstCurrent[i]=YES;
                    filterEntity.isCurrent=NO;
                    NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:filterEntity];
                    NSString * valueString=[jsonDic JSONString];
                    [_dataBaseOperation updateFilterConditionIsCurrent:valueString fromFilterName:entity.nameString];
                    _currentSelectEntity=nil;
                    
                    [CommonMethod setUserdefaultWithValue:nil forKey:KeyWord];
                    [CommonMethod setUserdefaultWithValue:nil forKey:NameString];
                    
                    continue;
                }
                //设置默认
                _isEstCurrent[i]=NO;
                filterEntity.isCurrent=YES;
                NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:filterEntity];
                NSString * valueString=[jsonDic JSONString];
                [_dataBaseOperation updateFilterConditionIsCurrent:valueString fromFilterName:entity.nameString];
                
                [CommonMethod setUserdefaultWithValue:entity.nameString forKey:NameString];
                [CommonMethod setUserdefaultWithValue:keyWord forKey:KeyWord];
              
                
                continue;
            }
        }
        else
        {
            _isEstCurrent[i] = YES;
            filterEntity.isCurrent = NO;
            NSDictionary *jsonDic = [MTLJSONAdapter JSONDictionaryFromModel:filterEntity];
            NSString * valueString=[jsonDic JSONString];
            [_dataBaseOperation updateFilterConditionIsCurrent:valueString fromFilterName:entity.nameString];
            

        }
    }
    [_dataArray removeAllObjects];
    NSArray * array=[_dataBaseOperation selectAllFilterCondition];
    _dataArray=[NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = array.count-1; i>=0; i--) {
        
        [_dataArray addObject:[array objectAtIndex:i]];
    }
}
//重命名提示alert
-(void)setDataNameAlert {
    
    _isPresentOption = NO;
    
    _textField.text = @"";
    _maskView.hidden = NO;
    
    for (NSInteger i = 0; i <_dataArray.count; i++) {
        DataFilterEntity * entity=_dataArray[i];
        FilterEntity * filterEntity = [MTLJSONAdapter modelOfClass:[FilterEntity class] fromJSONDictionary:[entity.entity jsonDictionaryFromJsonString] error:nil];
        if (filterEntity.isCurrent) {
            // 给默认修改搜索名
            if (i == _presentSelect) {
                _isPresentOption = YES;
            }
        }
    }
    
    
    DataFilterEntity *entity=_dataArray[_number];
    _textField.text=entity.nameString;
    _textField.tag = _number;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 0 && range.location>=14)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                 textField.text,
                                 string];
        NSString *resultString=[inputString substringToIndex:15];
        textField.text=resultString;
        
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
