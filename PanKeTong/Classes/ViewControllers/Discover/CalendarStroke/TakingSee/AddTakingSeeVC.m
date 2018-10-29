//
//  AddTakingSeeVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AddTakingSeeVC.h"
#import "TakingSeeVC.h"
#import "NewTakeLookFourthCell.h"   // 添加提醒人cell
#import "NewAddtakingCell.h"        // 新增约看
#import "CustomerFedCell.h"         // 客户反馈
#import "SearchViewController.h"
#import "SelectCustomerVC.h"        // 选客户
#import "ApplyRemindPersonCollectionCell.h"
#import "TCPickView.h"
#import "CustomActionSheet.h"
//#import "NormalCell.h"
#import "JMRemindTimeCell.h"
#import "UITableView+Category.h"
#import "OpeningPersonCell.h"

#define DeleteRemindPersonBtnTag        2000

#define SelectSale  0
#define SelectRent  1

@interface AddTakingSeeVC ()<UITableViewDelegate,UITableViewDataSource,SearchResultDelegate,
SearchRemindPersonDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TCPickViewDelegate> {
    UITableView *_tableView;
    UICollectionView *_remindPersonCollectionView;

    NSMutableArray *_remindPersonsArr;          // 选择的提醒人／部门数组

    SearchRemindType _selectRemindType;          // 选择的提醒人类型（部门／人员）
    NSMutableArray *_remindPersons;             // 提醒人数组
    NSMutableArray *_remindDepts;               // 提醒部门数组
    NSString *_seeTime;                      // 约看时间

    NSInteger _sectionSum;                      // 表视图总组数

    BOOL _hasShowDataPicker;                    // 是否已显示时间选择器
    BOOL _isRequestNow;                         // 是否正在请求

    
}

//提醒时间
@property (nonatomic, copy) NSString * remindTime;
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, strong)NSString *takeSeeTime;

@end

@implementation AddTakingSeeVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"新增约看"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(commitAction:)]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectCustomerNotification:)
                                                 name:@"SelectCustomer"
                                               object:nil];
    
    _viewHeight = 0;
    _takeSeeTime = [[NSString alloc] init];
    _takeSeeTime = nil;
    
    
    [self initData];
    [self initView];
    
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    _isRequestNow = NO;
}

/// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat yHeight = _tableView.contentSize.height;
    if (yHeight > APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)
    {
        _tableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - height;
    }
    else
    {
        _tableView.bottom = yHeight  -  APP_NAV_HEIGHT;
    }
}

/// 当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    _tableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
}

#pragma mark - init



- (void)initData {
    _remindPersonsArr = [NSMutableArray array];
    _remindPersons = [NSMutableArray array];
    _remindDepts = [NSMutableArray array];
    _sectionSum = 5;
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView .dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    // 隐藏cell分割线
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = YCThemeColorBackground;
    [self.view addSubview:_tableView];
}


#pragma mark - 选择的客户

- (void)selectCustomerNotification:(NSNotification *)notifi {
    _selectCustomerEntity = (CustomerEntity *)notifi.object;
    [_tableView reloadData];
}

#pragma mark-提交

- (void)commitAction:(UIButton *)btn {
    [CommonMethod resignFirstResponder];
    
    // 判断客源是否为空
    if (_selectCustomerEntity == nil)
    {
        showMsg(@"请选择约看客户！");
        return;
    }

    if (_seeTime == nil) {
        showMsg(@"请选择约看时间！");
        return;
    }
    
    // 约看时间早于或等于当前时间 跟当前日期比较
    BOOL isEarly = [self isEarlyWithTimeStr:_seeTime];
    if (isEarly)
    {
        showMsg(@"约看不得早于或等于当前时间！");
        return;
    }

    if (_isRequestNow == YES)
    {
        return;
    }
    _isRequestNow = YES;

    AddTakingSeeApi *addTakingSeeApi = [[AddTakingSeeApi alloc] init];
    addTakingSeeApi.inquiryKeyId = _selectCustomerEntity.customerKeyId;     // 客户实体
    addTakingSeeApi.MsgDeptKeyIds = _remindDepts;
    addTakingSeeApi.msgUserKeyIds = _remindPersons;
    addTakingSeeApi.reserveTime = _seeTime;
    addTakingSeeApi.msgTime = _remindTime;
    [_manager sendRequest:addTakingSeeApi];
    [self showLoadingView:nil];
}

- (BOOL)isEarlyWithTimeStr:(NSString *)timeStr {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:YearToMinFormat];
    NSDate *nowDate = [NSDate date];
    NSString *startDateStr = [NSDate stringWithDate:nowDate];
    NSDate *startDate = [df dateFromString:[startDateStr substringToIndex:16]];
    NSDate *endDate = [df dateFromString:timeStr];

    NSTimeInterval starTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    CGFloat days = endTime - starTime;
    if (days < 60)
    {
        return YES;
    }
    return NO;
}

#pragma mark - <UITableViewDelegate>
// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 2) {
        // 添加提醒人
        CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
        
        if (remindPersonHeight != 0) {
            _viewHeight = remindPersonHeight;
        }
        
        if (_viewHeight > 50*NewRatio) {
            return _viewHeight+20*NewRatio;
        }
        
        return 70*NewRatio;
    }

    return 50*NewRatio;
}
// 每组多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        // 选择约看客户
        NewAddtakingCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NewAddtakingCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.section = indexPath.section;
        cell.content = _selectCustomerEntity.customerName;
        [[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            SelectCustomerVC *vc = [[SelectCustomerVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _selectCustomerEntity = nil;
            cell.content = nil;
            [_tableView reloadData];
        }];
        
        return cell;
    }

    else if(indexPath.row == 1)
    {
        // 选择约看房源
        NSString *identifier = @"JMRemindTimeCell";
        JMRemindTimeCell *normalcell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
        normalcell.selectionStyle = UITableViewCellSelectionStyleNone;
        normalcell.titleNameLabel.text = @"约看时间";
        
        // 约看时间
        if (_takeSeeTime != nil)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: YearToMinFormat];
            NSDate *destDate= [dateFormatter dateFromString:_takeSeeTime];
            NSString *weekStr = [CalendarLogic getWeekWithDate:destDate];
            normalcell.valueLabel.textColor = YCTextColorBlack;
            normalcell.valueLabel.text = [NSString stringWithFormat:@"%@%@",_takeSeeTime,weekStr];
        }else {
            normalcell.valueLabel.textColor = YCTextColorAuxiliary;
            normalcell.valueLabel.text = @"请选择约看时间";
        }
        return normalcell;
        
    }
    else if (indexPath.row == 2)
    {
        //提醒人
        NSString *identifier = @"openingPersonCell";
        OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!openingPersonCell) {
            [tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:identifier];
            openingPersonCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
        }
        
        [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
        openingPersonCell.leftPersonLabel.text = @"提醒人";
        _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
        [_remindPersonCollectionView registerNib:[UINib nibWithNibName:@"ApplyRemindPersonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
        _remindPersonCollectionView.delegate = self;
        _remindPersonCollectionView.dataSource = self;
        
        return openingPersonCell;
        
//        // 提醒人提醒人
//        UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
//                                                  bundle:nil];
//        NewTakeLookFourthCell *cell = [NewTakeLookFourthCell cellWithTableView:_tableView];
//        _remindPersonCollectionView = cell.reminPersonCollection;
//        [_remindPersonCollectionView registerNib:collectionCellNib
//                      forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
//        [openingPersonCell.addPersonBtn addTarget:self action:@selector(addrRemindPersonAction:)
//                    forControlEvents:UIControlEventTouchUpInside];
//        openingPersonCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        _remindPersonCollectionView.delegate = self;
//        _remindPersonCollectionView.dataSource = self;
//        return openingPersonCell;
        
    }else if (indexPath.row == 3){
        //提醒时间
        static NSString * identifier = @"JMRemindTimeCell";
        JMRemindTimeCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        if (_remindTime) {
            cell.valueLabel.textColor = YCTextColorBlack;
            cell.valueLabel.text = _remindTime;
        }else {
            cell.valueLabel.textColor = YCTextColorAuxiliary;
            cell.valueLabel.text = @"请选择提醒时间";
        }
        
        cell.titleNameLabel.text = @"提醒时间";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;

}
// cell回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // 新增约看--(增加一个分组)
        if (_sectionSum == 14)
        {
            showMsg(@"最多增加10条约看房源！");
            return;
        }
        _sectionSum += 1;
        [_tableView reloadData];
    }
    else if (indexPath.row == 1) {
        
        // 判断客源是否为空
        if (_selectCustomerEntity == nil)
        {
            showMsg(@"请选择约看客户！");
            return;
        }
        
        // 约看时间
        // 收起键盘
        [CommonMethod resignFirstResponder];
        
        if (_hasShowDataPicker == YES)
        {
            return;
        }
        
        TCPickView *pickView;
        NSDate *defaultDate;
        if (pickView == nil)
        {
            if (_takeSeeTime == nil)
            {
                defaultDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60];
            }
            else
            {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:YearToMinFormat];
                defaultDate = [df dateFromString:_takeSeeTime];
                
            }
            pickView = [[TCPickView alloc] initDatePickViewWithDate:defaultDate mode:UIDatePickerModeDateAndTime];
            pickView.myDelegate = self;
            [self.view addSubview:pickView];
        }
        
        __block UITableView * weakTableView = tableView;
        
        [pickView showPickViewWithResultBlock:^(id result)
         {
             NSLog(@"%@",result);
             // 跟当前日期比较
             BOOL isEarly = [self isEarlyWithTimeStr:result];
             if (isEarly)
             {
                 showMsg(@"约看不得早于或等于当前时间！");
                 return;
             }
             _takeSeeTime = result;
             _seeTime = result;
             [weakTableView reloadData];
         }];
        _hasShowDataPicker = YES;
        
    }else if (indexPath.row == 3){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:YearToMinFormat];
        NSDate *date = [formatter dateFromString:_remindTime];
        TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:date mode:UIDatePickerModeDateAndTime];
        [self.view addSubview:pickView];
        
        [pickView showPickViewWithResultBlock:^(id result) {
            
            if([CommonMethod compareCurrentTime:result andFormat:YearToMinFormat] < 0)
            {
                showMsg(@"提醒不得早于或等于当前时间！");
                return;
            }
            
            _remindTime = result;
            [_tableView reloadData];
        }];
        
    }

}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [CommonMethod resignFirstResponder];
//    _tableView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
//}


#pragma mark - <TCPickViewDelegate>

/// 点击取消按钮之后
- (void)pickViewRemove {
    _hasShowDataPicker = NO;
}

#pragma mark - <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _remindPersonsArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];

    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;

    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                                           size:14.0]
                                                                    Height:25.0
                                                                      size:14.0];

    resultStrWidth += 20;

    if (resultStrWidth > collectionViewWidth)
    {
        resultStrWidth = collectionViewWidth;
    }

    return CGSizeMake(resultStrWidth, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *collectionCellId = @"applyRemindPersonCollectionCell";

    ApplyRemindPersonCollectionCell *remindPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_remindPersonCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                                                                                                            forIndexPath:indexPath];

    remindPersonCollectionCell.rightDeleteBtn.tag = DeleteRemindPersonBtnTag+indexPath.row;
    [remindPersonCollectionCell.rightDeleteBtn addTarget:self
                                                  action:@selector(deleteRemindPersonMethod:)
                                        forControlEvents:UIControlEventTouchUpInside];

    RemindPersonDetailEntity *curRemindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    remindPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;

    return remindPersonCollectionCell;
}

#pragma mark - 增加约看客户

- (void)addCustomerAction:(UIButton *)btn {
    // 约看客户-（我的客户范围内）
    if (_selectCustomerEntity != nil)
    {
        showMsg(@"只能选择一个约看客户！");
        return;
    }

    [CommonMethod addLogEventWithEventId:@"New a_added customer r_Click" andEventDesc:@"新增约看-增加约看客户点击量"];

    SelectCustomerVC *vc = [[SelectCustomerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 增加/删除提醒人

//- (void)addrRemindPersonAction:(UIButton *)btn {
//    [CommonMethod resignFirstResponder];
//
//
//    NSArray * listArr = @[@"部门",@"人员"];
//
//    __block typeof(self) weakSelf = self;
//
//    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
//
//        NSString *selectRemindTypeStr;
//        if (optionValue == 0)
//        {
//            // 部门
//            _selectRemindType = DeparmentType;
//            selectRemindTypeStr = DeparmentRemindType;
//
//        }
//        else if (optionValue == 1)
//        {
//            // 人员
//            _selectRemindType = PersonType;
//            selectRemindTypeStr = PersonRemindType;
//        }
//        else
//        {
//            return;
//        }
//
//        [CommonMethod addLogEventWithEventId:@"New a_reminder_Click" andEventDesc:@"新增约看-提醒人点击量"];
//
//        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                                  initWithNibName:@"SearchRemindPersonViewController"
//                                                                  bundle:nil];
//        searchRemindPersonVC.selectRemindType = _selectRemindType;
//        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//        searchRemindPersonVC.isExceptMe = YES;
//        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//        searchRemindPersonVC.delegate = weakSelf;
//        [weakSelf.navigationController pushViewController:searchRemindPersonVC animated:YES];
//
//    }];
////    BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
////                                                                          delegate:self
////                                                                 cancelButtonTitle:@"取消"
////                                                                 otherButtonTitles:@"部门",@"人员", nil];
////    [byActionSheetView show];
//}

/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
    [NewUtils popoverSelectorTitle:@"请选择" listArray:@[@"部门",@"人员"] theOption:^(NSInteger optionValue) {
        //添加提醒人
        NSString *selectRemindTypeStr;
        
        switch (optionValue) {
            case 0:
            {
                //部门
                _selectRemindType = DeparmentType;
                selectRemindTypeStr = DeparmentRemindType;
            }
                break;
            case 1:
            {
                //人员
                _selectRemindType = PersonType;
                selectRemindTypeStr = PersonRemindType;
            }
                break;
                
            default:
            {
                return;
            }
                break;
        }
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                  initWithNibName:@"SearchRemindPersonViewController"
                                                                  bundle:nil];
        searchRemindPersonVC.selectRemindType = _selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.isExceptMe = NO;
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    }];
    
}


///**
// *  删除提醒人
// */
//- (void)deleteRemindPersonMethod:(UIButton *)button
//{
//
//    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
//
//    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
//
//    [_remindPersonCollectionView reloadData];
//
//    [self performSelector:@selector(reloadRemindCellHeight) withObject:nil afterDelay:0.2];
//}
//- (void)reloadRemindCellHeight
//{
//    [_tableView reloadData];
//}


- (void)deleteRemindPersonMethod:(UIButton *)btn {
    NSInteger deleteItemIndex = btn.tag - DeleteRemindPersonBtnTag;

    RemindPersonDetailEntity *entity = [_remindPersonsArr objectAtIndex:deleteItemIndex];
//    if (selectRemindType == DeparmentType)
//    {
        // 部门
        [_remindDepts removeObject:entity.resultKeyId];
//    }
//    else
//    {
        // 人员
        [_remindPersons removeObject:entity.resultKeyId];
//    }

    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    [_remindPersonCollectionView reloadData];

    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
}

#pragma mark - <SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem {
    if (_selectRemindType == DeparmentType)
    {
        //部门
        [_remindDepts addObject:selectRemindItem.resultKeyId];
    }
    else
    {
        //人员
        [_remindPersons addObject:selectRemindItem.resultKeyId];
    }

    [_remindPersonsArr addObject:selectRemindItem];
    [_remindPersonCollectionView reloadData];

    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        [CommonMethod addLogEventWithEventId:@"New a_success_Click" andEventDesc:@"新增约看-成功新增约看数量"];
        
        [CustomAlertMessage showAlertMessage:@"新增约看成功"
                             andButtomHeight:(APP_SCREEN_HEIGHT- 64)/2];
        
        if ([_delegate respondsToSelector:@selector(addTakingSeeSuccess)])
        {
            [_delegate performSelector:@selector(addTakingSeeSuccess)];
        }
        
        [self back];
    }
}

- (void)back {
    // 取消所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls {
    [super respFail:error andRespClass:cls];
    _isRequestNow = NO;
}


@end
