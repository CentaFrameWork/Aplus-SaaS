//
//  CustomerFollowViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomerFollowViewController.h"
#import "AddCustomerFollowActivityVC.h"
#import "NewTakeLookRecordViewController.h"
#import "AddTakingSeeVC.h"

#import "JMMoreFollowListCell.h"

#import "CustomerFollowApi.h"
#import "CustomerFollowEntity.h"


#import "UITableView+Category.h"

@interface CustomerFollowViewController ()<ApplyTransferEstDelegate,AddTakeSeeDelegate,AddTakingSeeDelegate>
{
    NSMutableArray<CustomerFollowItemEntity *> *_tableViewSource;           //列表数据源
    NSMutableArray *_filterItemArray;           //跟进列表筛选项
    SelectItemDtoEntity *_selectFiltItem;       //当前选择的筛选项
    NSInteger _selectResultIndex;            //当前选择的筛选项索引
    UIPickerView *_selectItemPickerView;
    
    NSString *_curPageIndex;
    
    UIButton *_filtPropBtn;                 //筛选按钮
    
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation CustomerFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavTitleView];
    [self initView];
    [self initData];
    
    //默认筛选全部类型的跟进列表
    _selectResultIndex = 0;
}


#pragma mark - <初始化导航>


- (void)initNavTitleView
{
    [self setNavTitle:@"更多跟进"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    _filtPropBtn = [self customBarItemButton:@"筛选"
                             backgroundImage:nil
                                  foreground:nil
                                         sel:@selector(filterAction:)];
    _filtPropBtn.selected = NO;
    
    UIBarButtonItem *filtPropBarItem = [[UIBarButtonItem alloc]initWithCustomView:_filtPropBtn];
    
    self.navigationItem.rightBarButtonItems = @[filtPropBarItem];
    
    
}


- (void)initView
{
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = 0;
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
    _mainTableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)initData
{
    //跟进数据源
    if (!_tableViewSource)
    {
        _tableViewSource = [NSMutableArray array];
    }
    
    //筛选条件（自动添加“全部”筛选项）
    if (!_filterItemArray)
    {
        _filterItemArray = [NSMutableArray array];
        
        SelectItemDtoEntity *filtDefaultItem = [[SelectItemDtoEntity alloc]init];
        filtDefaultItem.itemValue = [NSString stringWithFormat:@""];
        filtDefaultItem.itemText = [NSString stringWithFormat:@"全部"];
        
        [_filterItemArray addObject:filtDefaultItem];
        
        SysParamItemEntity *customerFollowEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUSTOMER_FOLLOW_TYPE];
        
        for (SelectItemDtoEntity * obj in customerFollowEntity.itemList) {
            
            if (![obj.itemCode isEqualToString:@"100"]) {
                
                [_filterItemArray addObject:obj];
                
            }
            
        }
    }
    
    [_mainTableView.mj_header beginRefreshing];
}


- (void)headerRefreshMethod
{
    _curPageIndex = @"1";
    CustomerFollowApi *customerFollowApi = [[CustomerFollowApi alloc] init];
    customerFollowApi.inquiryKeyId = _customerEntity.customerKeyId;
    customerFollowApi.followTypeKeyId = _selectFiltItem.itemValue?_selectFiltItem.itemValue:@"";
    customerFollowApi.pageIndex = _curPageIndex;
    customerFollowApi.pageSize = @"10";
    customerFollowApi.sortField = @"";
    customerFollowApi.ascending = @"true";
    [_manager sendRequest:customerFollowApi];
}

- (void)footerRefreshMethod
{
    [self showLoadingView:nil];
    _curPageIndex = [NSString stringWithFormat:@"%ld", [_curPageIndex  integerValue] + 1];
    CustomerFollowApi *customerFollowApi = [[CustomerFollowApi alloc] init];
    customerFollowApi.inquiryKeyId = _customerEntity.customerKeyId;
    customerFollowApi.followTypeKeyId = _selectFiltItem.itemValue ? _selectFiltItem.itemValue:@"";
    customerFollowApi.pageIndex = _curPageIndex;
    customerFollowApi.pageSize = @"10";
    customerFollowApi.sortField = @"";
    customerFollowApi.ascending = @"true";
    [_manager sendRequest:customerFollowApi];
    
}

#pragma mark - ClickEvents

- (void)back
{
    if ([self.backDelegate respondsToSelector:@selector(customerFollowBack)]) {
        [self.backDelegate customerFollowBack];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)filterAction:(UIButton *)btn {
    
    if (btn.selected == YES)
    {
        return;
    }
    btn.selected = !btn.selected;
    
    _selectItemPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    _selectItemPickerView.dataSource = self;
    _selectItemPickerView.delegate = self;
    [_selectItemPickerView selectRow:_selectResultIndex inComponent:0 animated:YES];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_selectItemPickerView AndHeight:284+BOTTOM_SAFE_HEIGHT];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
}

/// go新增客户跟进
- (void)addMoreMethod
{
    NSArray * listArr = @[@"房源动态",@"客户需求",@"推荐反馈"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        NSString * buttonTitle = listArr[optionValue];
        
        if (buttonTitle.length < 1)
        {
            return;
        }
        
        else if ([buttonTitle isEqualToString:@"录入约看"])
        {
            AddTakingSeeVC *addTakingSeeVC = [[AddTakingSeeVC alloc] init];
            addTakingSeeVC.delegate = self;
            addTakingSeeVC.selectCustomerEntity = _customerEntity;
            addTakingSeeVC.isFromCustomerFollow = YES;
            [weakSelf.navigationController pushViewController:addTakingSeeVC animated:YES];
        }
        else if ([buttonTitle isEqualToString:@"录入带看"])
        {
            NewTakeLookRecordViewController * newTakeLookRecordVC = [[NewTakeLookRecordViewController alloc]
                                                                     initWithNibName:@"NewTakeLookRecordViewController" bundle:nil];
            newTakeLookRecordVC.delegate = self;
            //            newTakeLookRecordVC.customerEntity = _customerEntity;
            [weakSelf.navigationController pushViewController:newTakeLookRecordVC animated:YES];
        }
        else if ([buttonTitle isEqualToString:@"取消"]){
            
        }
        else
        {
            //客源动态/信息补充/客户需求/推荐反馈
            AddCustomerFollowActivityVC *addFollowActivityVC = [AddCustomerFollowActivityVC new];
            addFollowActivityVC.delegate = self;
            addFollowActivityVC.inquiryKeyId = _customerEntity.customerKeyId;
            addFollowActivityVC.titleName = buttonTitle;
            [weakSelf.navigationController pushViewController:addFollowActivityVC animated:YES];
        }
        
    }];
}

#pragma mark - CustomerFollowViewProtocol

/// 设置navBarButton
- (void)setNavigationBarButton
{
    UIButton *addNewBtn = [self customBarItemButton:@"新增"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(addMethod:)];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -10;
    
    UIBarButtonItem *addNewBarItem = [[UIBarButtonItem alloc]initWithCustomView:addNewBtn];
    UIBarButtonItem *filtPropBarItem = [[UIBarButtonItem alloc]initWithCustomView:_filtPropBtn];
    
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacer, addNewBarItem, filtPropBarItem];
}

- (void)addMethod:(UIButton *)btn{
    //    _sheetView = [[BYActionSheetView alloc] init];
    //    self.sheetView.delegate = self;
}

#pragma mark - ApplyTransferDelegate

- (void)transferEstSuccess
{
    [_tableViewSource removeAllObjects];
    [self headerRefreshMethod];
}


#pragma mark - <PickerViewDelegate>
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _filterItemArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    SelectItemDtoEntity *selectItemDtoEntity = [_filterItemArray objectAtIndex:row];
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    cusPicLabel.text = selectItemDtoEntity.itemText;
    [cusPicLabel setFont:[UIFont fontWithName:FontName size:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectResultIndex = row;
}

#pragma mark - DoneSelectDelegate

- (void)doneSelectItemMethod
{
    _selectFiltItem = [_filterItemArray objectAtIndex:_selectResultIndex];
    [self initData];
}

#pragma mark - <addTakeSeeSuccess>

-(void)addTakeSeeSuccess
{
    [self initData];
}

#pragma mark - <addTakingSeeSuccess>

-(void)addTakingSeeSuccess
{
    [self initData];
}

- (void)haveHidden{
    _filtPropBtn.selected = NO;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"JMMoreFollowListCell";
    
    JMMoreFollowListCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.customerEntity = _tableViewSource[indexPath.row];
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerFollowItemEntity * entity = [_tableViewSource objectAtIndex:indexPath.row];
    
    CGFloat width = APP_SCREEN_WIDTH - 26 - 12;;
    
    return [entity.followContent heightWithLabelFont:[UIFont systemFontOfSize:14 weight:UIFontWeightLight] withLabelWidth:width] + 16 + 26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[CustomerFollowEntity class]])
    {
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];
        
        CustomerFollowEntity *customerFollowEntity = [DataConvert convertDic:data toEntity:modelClass];
        if (_mainTableView.mj_header.isRefreshing)
        {
            [_tableViewSource removeAllObjects];
        }
        
        [_tableViewSource addObjectsFromArray:customerFollowEntity.inqFollows];
        
        _mainTableView.mj_footer.hidden = customerFollowEntity.recordCount == _tableViewSource.count;
        
        [_mainTableView reloadData];
    }
}

@end
