//
//  SelectCustomerVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/7.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SelectCustomerVC.h"
#import "AddEventView.h"
#import "MyClientTableViewCell.h"
#import "MyClientApi.h"
#import "CustomerListEntity.h"
#import "AccessModelScopeEnum.h"

#define Search_Tel          @"search_Tel"           // 按手机号搜索
#define Search_CustomerName @"search_CustomerName"  // 按客户姓名搜索

@interface SelectCustomerVC ()<CustomTextFieldDelegate,AddEventDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
//    CustomTextField *_searchTF;
    UIButton *_selectBtn;
    AddEventView *_selectView;
    UITableView *_tabeView;
    UILabel *_noDatalabel;
    UIView *_shadowView;

//    MyClientApi *_myClientApi;

    
    NSString *_searchType;          // 当前搜索类型
}

@property (nonatomic, strong)UIButton * buttonZ;
@property (nonatomic, strong)UILabel *labelZ;
@property (nonatomic, strong)UIView *viewZ;
@property (nonatomic, strong)UIButton * buttonY;
@property (nonatomic, strong)UILabel *labelY;
@property (nonatomic, strong)UIView *viewY;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UITableView *tabeView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSString *textStr;

@end

@implementation SelectCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"检索" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    

    _dataArr = [NSMutableArray array];
    _textStr = [[NSString alloc] init];
    
//    [self initData];

//    // 导航栏TitleView
//    [self initNavView];

//    // 设置UI
//    [self initView];
    
    [self initView2];
    
    _tabeView.backgroundColor = UICOLOR_RGB_Alpha(0xF1F1F1,1.0);
}

- (void)initView2 {
    
    // 手机号
    _buttonZ = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH/2, 50*NewRatio)];
    _buttonZ.selected = YES;
    [[_buttonZ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 手机号
        _textField.placeholder = @"请输入手机号";
        if (_buttonY.selected) {
            _textField.text = @"";
            _textStr = @"";
            [_dataArr removeAllObjects];
            [_tabeView reloadData];
        }
        _labelZ.textColor = YCButtonColorGreen;
        _viewZ.backgroundColor = YCButtonColorGreen;
        _labelY.textColor = YCTextColorBlack;
        _viewY.backgroundColor = [UIColor whiteColor];
        _buttonZ.selected = YES;
        _buttonY.selected = NO;
    }];
    [self.view addSubview:_buttonZ];
    _labelZ = [[UILabel alloc] initWithFrame:CGRectMake(74*NewRatio, 3*NewRatio, 88*NewRatio, 44*NewRatio)];
    _labelZ.font = [UIFont systemFontOfSize:14*NewRatio];
    _labelZ.textColor = YCButtonColorGreen;
    _labelZ.textAlignment = NSTextAlignmentCenter;
    _labelZ.text = @"手机号";
    [self.view addSubview:_labelZ];
    _viewZ = [[UIView alloc] initWithFrame:CGRectMake(74*NewRatio, 47*NewRatio, 88*NewRatio, 3*NewRatio)];
    _viewZ.backgroundColor = YCButtonColorGreen;
    [self.view addSubview:_viewZ];
    
    
    // 客户姓名
    _buttonY = [[UIButton alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH/2, 0, APP_SCREEN_WIDTH/2, 50*NewRatio)];
    _buttonY.selected = NO;
    [[_buttonY rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 客户名
        _textField.placeholder = @"请输入客户名";
        if (_buttonZ.selected) {
            _textField.text = @"";
            _textStr = @"";
            [_dataArr removeAllObjects];
            [_tabeView reloadData];
        }
        _labelZ.textColor = YCTextColorBlack;
        _viewZ.backgroundColor = [UIColor whiteColor];
        _labelY.textColor = YCButtonColorGreen;
        _viewY.backgroundColor = YCButtonColorGreen;
        _buttonZ.selected = NO;
        _buttonY.selected = YES;
    }];
    [self.view addSubview:_buttonY];
    _labelY = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-162*NewRatio, 3*NewRatio, 88*NewRatio, 44*NewRatio)];
    _labelY.font = [UIFont systemFontOfSize:14*NewRatio];
    _labelY.textColor = YCTextColorBlack;
    _labelY.textAlignment = NSTextAlignmentCenter;
    _labelY.text = @"客户姓名";
    [self.view addSubview:_labelY];
    _viewY = [[UIView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-162*NewRatio, 47*NewRatio, 88*NewRatio, 3*NewRatio)];
    _viewY.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewY];
    
    UIView *viewTF = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, CGRectGetMaxY(_viewZ.frame)+12*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, 50*NewRatio)];
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-24*NewRatio, 50*NewRatio)];
    top.backgroundColor = [UIColor whiteColor];
    top.layer.shadowColor = RGBColor(210, 210, 210).CGColor;
    top.layer.shadowOffset = CGSizeMake(0, 4);
    top.layer.shadowOpacity = 0.8;
    top.layer.shadowRadius = 4;
    top.layer.cornerRadius = 5;
    [viewTF addSubview:top];
    [self.view addSubview:viewTF];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12*NewRatio, 18*NewRatio, 14*NewRatio, 14*NewRatio)];
    imageView.image = [UIImage imageNamed:@"Shape"];
    [viewTF addSubview:imageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(44*NewRatio, 0, 250*NewRatio, 50*NewRatio)];
    _textField.font = [UIFont systemFontOfSize:14*NewRatio];
    _textField.textColor = YCTextColorBlack;
    _textField.placeholder = @"请输入手机号";
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(inputLenth3:) forControlEvents:UIControlEventAllEvents];
    [viewTF addSubview:_textField];
    
    _tabeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 124*NewRatio, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight-124*NewRatio-64) style:UITableViewStylePlain];
    _tabeView.delegate = self;
    _tabeView.dataSource = self;
    _tabeView.separatorStyle = NO;
    [self.view addSubview:_tabeView];
}

- (void)inputLenth3:(UITextField *)textField {
    
    // 判断请求数据还是清空数据
    if (textField.text.length > 0) {
        // 如果是手机号则只能输入数字
        if (_buttonZ.selected) {
            if (isPureInt(textField.text)) {
                if (![textField.text isEqualToString:_textStr]) {
                    _textStr = textField.text;
//                    [self headerRefresh];
                }
            }else {
                textField.text = _textStr;
            }
        }else {
//            [self headerRefresh];
        }
    } else {
//        [_dataArr removeAllObjects];
//        [_tabeView reloadData];
    }
}

// return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self headerRefresh];
    // 隐藏键盘
    [self.view endEditing:YES];
    return YES;
}

- (void)back {
    [self.view endEditing:YES];
    // 取消所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSArray *vcArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[vcArr objectAtIndex:vcArr.count - 2] animated:YES];

}

#pragma mark - 背景视图点击手势

- (void)tapAction:(UITapGestureRecognizer *)tap {
    _shadowView.hidden = YES;
    _selectView.hidden = YES;
}

#pragma mark - <CustomTextFieldDelegate>

//- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField {
//    _noDatalabel.hidden = YES;
//    _selectView.hidden = YES;
//    _shadowView.hidden = YES;
//    return YES;
//}
//
//- (void)customTextFieldShouldReturn:(UITextField *)textField {
//    [_searchTF resignFirstResponder];
//
//    if (_searchTF.text.length > 0)
//    {
//        [self headerRefresh];
//    }
//    else
//    {
//        [_dataArr removeAllObjects];
//        _noDatalabel.hidden = YES;
//        [_tabeView reloadData];
//    }
//}

#pragma mark - 头/尾视图刷新

- (void)headerRefresh {
    
    [_dataArr removeAllObjects];
    if (_textField.text.length == 0) {
        return;
    }

    NSString *privateInquiryRange = [self getSearchPermission];
    if (privateInquiryRange.length <= 0 || privateInquiryRange == nil) {
        // 无权限查看，退出当前视图
        showMsg(@"您没有查看客户权限！");
        return;
    }

//    if (_buttonZ.selected) {
//        // 按手机号搜索
//        _myClientApi.contactType = @"mobile";
//        _myClientApi.contactContent = _textField.text;
//        _myClientApi.searchKey = @"";
//    } else {
//        // 按客户名搜索
//        _myClientApi.contactType = @"";
//        _myClientApi.contactContent = @"";
//        _myClientApi.searchKey = _textField.text;
//    }
//
//    _myClientApi.privateInquiryRange = privateInquiryRange;
//    _myClientApi.inquiryStatusKeyIds = @[];
//    _myClientApi.houseTypeKeyIds = @[];
//    _myClientApi.inquiryTag = @"";
//    _myClientApi.isExpire30Day = @"false";
//    _myClientApi.inquiryTradeTypeKeyId = @"";
//    _myClientApi.salePriceFrom = @"";
//    _myClientApi.salePriceTo = @"";
//    _myClientApi.rentPriceFrom = @"";
//    _myClientApi.rentPriceTo = @"";
//    _myClientApi.pageIndex = @"1";
//    _myClientApi.pageSize = @"30";
//    _myClientApi.sortField = @"";
//    _myClientApi.ascending = @"true";
//    [_manager sendRequest:_myClientApi];
    
    NSDictionary *dict;
    if (_buttonZ.selected) {
        dict= @{
                @"PrivateInquiryRange":privateInquiryRange==nil?@"":privateInquiryRange,
                @"IsExpire30Day":@"false",
                @"PageIndex":@"1",
                @"Ascending":@"true",
                @"ContactType":@"mobile",
                @"PageSize":@"100",
                @"ContactContent":_textField.text,
                @"SearchKey":@""
                };
    }else {
        dict= @{
                @"PrivateInquiryRange":privateInquiryRange==nil?@"":privateInquiryRange,
                @"IsExpire30Day":@"false",
                @"PageIndex":@"1",
                @"Ascending":@"true",
                @"ContactType":@"",
                @"PageSize":@"100",
                @"ContactContent":@"",
                @"SearchKey":_textField.text
                };
    }
    
    NSString *string = [dict JSONString];
//    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@":", kCFStringEncodingUTF8));
    NSDictionary *dictt = @{@"urlParams":string};
    
    [self showLoadingView:nil];
    [AFUtils GET:ApiInquiryAll parameters:dictt controller:self successfulDict:^(NSDictionary *successfuldict) {
        [self hiddenLoadingView];
        
        CustomerListEntity *entity = [DataConvert convertDic:successfuldict toEntity:[CustomerListEntity class]];
        if (entity.inquirys.count > 0) {
            [_dataArr addObjectsFromArray:entity.inquirys];
        }
        [_tabeView reloadData];
    } failureDict:^(NSDictionary *failuredict) {
        [self hiddenLoadingView];
    } failureError:^(NSError *failureerror) {
        [self hiddenLoadingView];
    }];
    
    

    
}

//- (void)footerRefresh {
//
//    NSString *privateInquiryRange = [self getSearchPermission];
//    if (privateInquiryRange.length <= 0 || privateInquiryRange == nil)
//    {
//        // 无权限查看，退出当前视图
//        showMsg(@"您没有查看客户权限！");
//        return;
//    }
//
//    if (_buttonZ.selected)
//    {
//        // 按手机号搜索
//        _myClientApi.contactType = @"mobile";
//        _myClientApi.contactContent = _searchTF.text;
//        _myClientApi.searchKey = @"";
//    }
//    else if ([_searchType isEqualToString:Search_CustomerName])
//    {
//        // 按客户名搜索
//        _myClientApi.contactType = @"";
//        _myClientApi.contactContent = @"";
//        _myClientApi.searchKey = _searchTF.text;
//    }
//
//    if (_searchTF.text == nil || _searchTF.text.length == 0) {
//        return;
//    }
//
//    _myClientApi.privateInquiryRange = privateInquiryRange;
//    _myClientApi.inquiryStatusKeyIds = @[];
//    _myClientApi.houseTypeKeyIds = @[];
//    _myClientApi.inquiryTag = @"";
//    _myClientApi.isExpire30Day = @"false";
//    _myClientApi.inquiryTradeTypeKeyId = @"";
//    _myClientApi.salePriceFrom = @"";
//    _myClientApi.salePriceTo = @"";
//    _myClientApi.rentPriceFrom = @"";
//    _myClientApi.rentPriceTo = @"";
//    _myClientApi.pageIndex = [NSString stringWithFormat:@"%ld",_currentPage];
//    _myClientApi.pageSize = @"10";
//    _myClientApi.sortField = @"";
//    _myClientApi.ascending = @"true";
//    [_manager sendRequest:_myClientApi];
//}

- (NSString *)getSearchPermission {
    if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYSELF])
    {
        // 本人 4
        return [NSString stringWithFormat:@"%d",MYSELF];
    }
    else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        // 本部 3
        return [NSString stringWithFormat:@"%d",MYDEPARTMENT];
    }
    else if([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_ALL])
    {
        // 全部 1
        return [NSString stringWithFormat:@"%d",ALL];
    }
    else
    {
        return nil;
    }
}

#pragma mark - 选择手机号/客户名称

- (void)selectAction:(UIButton *)btn {
    _selectView.hidden = !_selectView.hidden;
    _shadowView.hidden = !_shadowView.hidden;
    btn.selected = !btn.selected;
}

#pragma mark - <AddEventDelegate>

//- (void)addEventClickWithBtnTitle:(NSString *)title {
//    [_dataArr removeAllObjects];
//    _searchTF.text = nil;
//
//    if ([title contains:@"手机号"])
//    {
//        // 手机号
//        _searchTF.limitCondition = ONLY_NUMBER;
//        _searchTF.limitLength = 11;
//        [_selectBtn setTitle:@"手机号码" forState:UIControlStateNormal];
//        _searchTF.placeholder = @"请输入手机号";
//        _searchTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        _searchType = Search_Tel;
//    }
//    else
//    {
//        // 客户名
//        _searchTF.limitLength = 30;
//        _searchTF.limitCondition = nil;
//        [_selectBtn setTitle:@"客户姓名" forState:UIControlStateNormal];
//        _searchTF.placeholder = @"请输入客户名";
//        _searchTF.keyboardType = UIKeyboardTypeDefault;
//        _searchType = Search_CustomerName;
//
//    }
//
//    _selectView.hidden = YES;
//    _shadowView.hidden = YES;
//    _selectBtn.selected = NO;
//
//    // 收起键盘
//    [_searchTF endEditing:YES];
//}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyClientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myClientCell"];

    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyClientTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
      cell.customerEntity = _dataArr[indexPath.row];
  

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选择客户
    if (_dataArr.count > 0)
    {
        CustomerEntity *entity = _dataArr[indexPath.row];
        // 选择客户---(关闭当前页面返回新增约看)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectCustomer" object:entity];
        [self.view endEditing:YES];
        // 取消所有通知
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSArray *vcArr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[vcArr objectAtIndex:vcArr.count - 2] animated:YES];
    }

}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    [self hiddenLoadingView];
//    [_tabeView headerEndRefreshing];
//    [_tabeView footerEndRefreshing];
//    [_tabeView.mj_header endRefreshing];
//    [_tabeView.mj_footer endRefreshing];

    if ([modelClass isEqual:[CustomerListEntity class]])
    {
        CustomerListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];

        if (entity.inquirys.count > 0)
        {
            [_dataArr addObjectsFromArray:entity.inquirys];
        }

        if (_dataArr.count == entity.recordCount)
        {
            // 没有更多数据了
//            _tabeView.footerHidden = YES;
//             _tabeView.mj_footer.hidden = YES;
        }

        [_tabeView reloadData];

        // 没有搜索记录
        if (_dataArr.count == 0)
        {
            _noDatalabel.hidden = NO;
        }
        else
        {
            _noDatalabel.hidden = YES;
        }
    }
}

// 滑动调用
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}

- (void)respFail:(NSError *)error andRespClass:(id)cls {
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];

//    [_tabeView footerEndRefreshing];
//    [_tabeView.mj_footer endRefreshing];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _shadowView.hidden = YES;
    _selectView.hidden = YES;
}

@end
