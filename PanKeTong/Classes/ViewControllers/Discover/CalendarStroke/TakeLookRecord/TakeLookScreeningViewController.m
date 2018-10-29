//
//  TakeLookScreeningViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakeLookScreeningViewController.h"
#import "TakeLookScreeningCell.h"
#import "NSDate+Format.h"
#import "TCPickView.h"
#import "SearchRemindPersonViewController.h"
#import "TCPickView.h"
#import "CustomActionSheet.h"

@interface TakeLookScreeningViewController ()<UITableViewDelegate,UITableViewDataSource,TCPickViewDelegate,SearchRemindPersonDelegate,UIPickerViewDataSource,UIPickerViewDelegate,doneSelect>
{
    __weak IBOutlet UITableView *_mainTableView;
    BOOL _hasPickView;         //是否页面上存在时间选择器
    SearchRemindType _selectRemindType;
    NSInteger _selectType;
}

@end

@implementation TakeLookScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YCThemeColorBackground;
    _mainTableView.backgroundColor = YCThemeColorBackground;
    
    
    [self initView];
    [self initData];

}

-(void)initView
{
    [self setNavTitle:@"筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    UIButton *commitBtn = [self customBarItemButton:@"确定"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(commitClick)];
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    UIButton *againSetting = [self customBarItemButton:@"重置"
                                       backgroundImage:nil
                                            foreground:nil
                                                   sel:@selector(againSetClick)];
    
    UIBarButtonItem *againSettingItem = [[UIBarButtonItem alloc]initWithCustomView:againSetting];
    self.navigationItem.rightBarButtonItems = @[commitBtnItem,againSettingItem];
}

-(void)initData
{
    NSDate *nowDate = [NSDate date];
    NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate];//前30天
    
    if ([NSString isNilOrEmpty:_takeLookVO.dateTimeStart] && [NSString isNilOrEmpty:_takeLookVO.dateTimeEnd])
    {
        _takeLookVO = [[TakeLookScreeningVO alloc] init];
        
        _takeLookVO.dateTimeStart = [NSDate stringWithSimpleDate:startDay];
        _takeLookVO.dateTimeEnd = [NSDate stringWithSimpleDate:nowDate];
    }
    _hasPickView = NO;

    _selectType = 0;
}

-(void)commitClick
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:OnlyDateFormat];
    NSDate *startDate = [df dateFromString:_takeLookVO.dateTimeStart];
    NSDate *endDate = [df dateFromString:_takeLookVO.dateTimeEnd];
    NSTimeInterval time30Days = 30 * 24 * 60 * 60;
    NSTimeInterval starTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    CGFloat days = endTime - starTime;

    //判断筛选范围是否超过用户权限
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYSELF] ) {
        //本人
        IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
        if (_takeLookVO.employeeName != nil && _takeLookVO.employeeName.length > 0) {
            if (![_takeLookVO.employeeName isEqualToString:identifyEntity.uName]) {
                //不是本人
                showMsg(@"您已超出权限范围,请重新输入")
                return;
            }
        }

    }else if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT]){
        //本部
        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
        if (_takeLookVO.departmentKeyId != nil) {
            if (![departmentKeyIds containsString:_takeLookVO.departmentKeyId]) {
                //不是本部及下级
                showMsg(@"您已超出权限范围,请重新输入")
                return;
            }

        }

    }


    
    //判断开始时间是否晚于结束时间
    if (days < 0) {
        showMsg(@"开始时间不能晚于结束时间!");
        return;
    }
    
    //陈行解决298bug，按时间搜索无30天限制
//    //判断开始时间和结束时间是否大于一个月
//    if (days > time30Days) {
//        showMsg(@"为了保证查询速度，请查询少于30天的数据!");
//        return;
//    }
    
    if (self.block) {
        self.block(_takeLookVO);
    }
    [self back];
}

#pragma mark 重置按钮

- (void)againSetClick
{
    _takeLookVO = [[TakeLookScreeningVO alloc] init];
    
    NSDate *nowDate = [NSDate date];
    NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate];// 前30天
    _takeLookVO.dateTimeStart = [NSDate stringWithSimpleDate:startDay];
    _takeLookVO.dateTimeEnd = [NSDate stringWithSimpleDate:nowDate];
    
    [_mainTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 12.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TakeLookScreeningCell *cell = [TakeLookScreeningCell cellWithTableView:tableView];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.leftTitle.text = @"部门";
                cell.rightTitle.text = _takeLookVO.departmentName;
            }else if (indexPath.row == 1)
            {
                cell.leftTitle.text = @"人员";
                cell.rightTitle.text = _takeLookVO.employeeName;
            }
            
        }
            break;
        case 1:
        {
            cell.leftTitle.text = @"带看类型";
            if (!_takeLookVO.seePropertyType) {
                cell.rightTitle.text = @"全部";
            }else {
                cell.rightTitle.text = _takeLookVO.seePropertyType;
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.row == 0) {
                cell.leftTitle.text = @"开始时间";
                cell.rightTitle.text = _takeLookVO.dateTimeStart;
            }else if (indexPath.row == 1)
            {
                cell.leftTitle.text = @"结束时间";
                cell.rightTitle.text = _takeLookVO.dateTimeEnd;
            }
            
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasPickView) {
        return;
    }
    
    if (indexPath.section == 0) {
         SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] init];
        if (indexPath.row == 0) {
            //部门
            _selectRemindType = DeparmentType;
            searchRemindPersonVC.selectRemindTypeStr = CalendarDeparmentType;

        }else{
            //人员
            if (_takeLookVO.departmentKeyId.length > 0) {
                searchRemindPersonVC.departmentKeyId = _takeLookVO.departmentKeyId;
            }
            
            _selectRemindType = PersonType;
            searchRemindPersonVC.selectRemindTypeStr = CalendarPersonType;

        }
        searchRemindPersonVC.selectRemindType = _selectRemindType;
        searchRemindPersonVC.delegate = self;
        searchRemindPersonVC.isFromOtherModule = YES;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        
    }else if (indexPath.section == 1)
    {
        //带看类型
        //1,出售 2,出租 3,租售
        _hasPickView = YES;
        [NewUtils popoverSelectorTitle:nil listArray:@[@"全部",@"看售",@"看租"] theOption:^(NSInteger optionValue) {
            if (optionValue == 0) {
                _takeLookVO.seePropertyType = @"全部";
            }else if (optionValue == 1) {
                _takeLookVO.seePropertyType = @"看售";
            }else if (optionValue == 2) {
                _takeLookVO.seePropertyType = @"看租";
            }
            _hasPickView = NO;
            [_mainTableView reloadData];
        }];
        
        
    }
    else if (indexPath.section == 2)
    {
        _hasPickView = YES;
        
        if (indexPath.row == 0) {
            NSDate *startDate = [NSDate dateFromString:_takeLookVO.dateTimeStart];
            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:startDate?startDate:[NSDate date] mode:UIDatePickerModeDate];
            pickView.myDelegate = self;
            [pickView showPickViewWithResultBlock:^(id result) {
                
                NSString *time = [CommonMethod subTime:result];
                _hasPickView = NO;
                _takeLookVO.dateTimeStart = time;
                
                [_mainTableView reloadData];
            }];
        }else{
            
            NSDate *endDate = [NSDate dateFromString:_takeLookVO.dateTimeEnd];
            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:endDate?endDate:[NSDate date] mode:UIDatePickerModeDate];
            pickView.myDelegate = self;
            [pickView showPickViewWithResultBlock:^(id result) {
                
                NSString *time = [CommonMethod subTime:result];
                
                _hasPickView = NO;
                _takeLookVO.dateTimeEnd = time;
                
                [_mainTableView reloadData];
            }];
        }
    }
}

#pragma mark - [私有方法]
- (CustomActionSheet *)showPickView:(NSInteger)selectIndex
{

    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                               40,
                                                                               APP_SCREEN_WIDTH,
                                                                               180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    [mPickerView selectRow:selectIndex
               inComponent:0
                  animated:YES];

    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView
                                                             AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];

    return sheet;
}


#pragma mark-<doneSelect>
-(void)doneSelectItemMethod{
    if (_selectType == 0) {
        _hasPickView = NO;
        _takeLookVO.seePropertyType = @"全部";
    }else if(_selectType == 1){
        _takeLookVO.seePropertyType = @"看售";
    }else{
        _takeLookVO.seePropertyType = @"看租";

    }

    _selectType = 0;
    _hasPickView = NO;
    [_mainTableView reloadData];
}

- (void)haveHidden{
    _hasPickView = NO;
}

#pragma mark - <PickerViewDelegate>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];

    NSString *cusStr;
    if (row == 0) {
        cusStr = @"全部";
    }else if(row == 1){
        cusStr = @"看售";
    }else{
        cusStr = @"看租";
    }


    cusPicLabel.text = cusStr;
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
    _selectType = row;
}


#pragma mark-<SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem{
    
    if (_selectRemindType == DeparmentType) {
        //部门改变，人员置空
        _takeLookVO.departmentName = selectRemindItem.departmentName;
        _takeLookVO.employeeName = nil;
    }else{
        //人员改变，部门联动
        _takeLookVO.employeeName = selectRemindItem.resultName;
        _takeLookVO.departmentName = selectRemindItem.departmentName;
    }
    _takeLookVO.departmentKeyId = selectRemindItem.departmentKeyId;
    [_mainTableView reloadData];
}

#pragma mark - TCPickViewDelegate
- (void)pickViewRemove
{
    _hasPickView = NO;
}

@end
