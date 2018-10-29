//
//  ReminScreeningViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "ReminScreeningViewController.h"
#import "NewTakeLookSecondCell.h"
#import "ReminScreeningCell.h"
#import "NSDate+Format.h"
#import "TCPickView.h"
#import "SearchRemindPersonViewController.h"

@interface ReminScreeningViewController ()<UITableViewDelegate,UITableViewDataSource,TCPickViewDelegate,UITextFieldDelegate,SearchRemindPersonDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    BOOL _hasPickView;         //是否页面上存在时间选择器
}

@end

@implementation ReminScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    if (!_alertScreeningEntity) {
        _alertScreeningEntity = [[AlertApi alloc] init];
        
        _alertScreeningEntity.timeFrom = [NSDate stringWithSimpleDate:startDay];
        _alertScreeningEntity.timeTo = [NSDate stringWithSimpleDate:nowDate];
    }
    _hasPickView = NO;
}

#pragma mark - 提交按钮
-(void)commitClick
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:OnlyDateFormat];
    NSDate *startDate = [df dateFromString:_alertScreeningEntity.timeFrom];
    NSDate *endDate = [df dateFromString:_alertScreeningEntity.timeTo];
    NSTimeInterval time30Days = 30 * 24 * 60 * 60;
    NSTimeInterval starTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    CGFloat days = endTime - starTime;
    
    //判断开始时间是否晚于结束时间
    if (days < 0) {
        showMsg(@"开始时间不能晚于结束时间!");
        return;
    }
    
    //判断开始时间和结束时间是否大于一个月
    if (days > time30Days) {
        showMsg(@"为了保证查询速度，请查询少于30天的数据!");
        return;
    }
    
    if (self.block) {
        self.block(_alertScreeningEntity);
    }
    [self back];
}

#pragma mark - 重置按钮
-(void)againSetClick
{
    _alertScreeningEntity = [[AlertApi alloc] init];
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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else{
        return 20;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //WithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 20)
    UIView *footerView = [[UIView alloc] init];
    
    if (section == 1) {
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 180, 10, 180, 10)];
        footerLabel.text = @"20个字符串超过字数限制，无法输入";
        footerLabel.font = [UIFont fontWithName:FontName size:10];
        footerLabel.textColor = RGBColor(153, 153, 153);
        [footerView addSubview:footerLabel];
    }
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 8.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewTakeLookSecondCell *reminCell = [NewTakeLookSecondCell cellWithTableView:tableView];
    ReminScreeningCell * reminContent = [ReminScreeningCell cellWithTableView:tableView];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                reminCell.leftTitle.text = @"提醒人";
                reminCell.rightTitle.text = _alertScreeningEntity.employeeName;
            }else if (indexPath.row == 1)
            {
                reminCell.leftTitle.text = @"提醒时间";
                reminCell.rightTitle.text = _alertScreeningEntity.timeFrom;
            }
            reminCell.rightImage.hidden = NO;
            return reminCell;
        }
            break;
        case 1:
        {
            reminContent.reminContentField.text = _alertScreeningEntity.remark;
            reminContent.reminContentField.delegate = self;
            
            //添加监听，限制输入字数（20）
            [reminContent.reminContentField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            return reminContent;
        }
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasPickView) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] init];
            //人员
            searchRemindPersonVC.selectRemindType = PersonType;
            searchRemindPersonVC.delegate = self;
            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        }
        
        if (indexPath.row == 1) {
            _hasPickView = YES;
            TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:[NSDate date] mode:UIDatePickerModeDate];
            pickView.myDelegate = self;
            [pickView showPickViewWithResultBlock:^(id result) {
                
                NSString *time = [CommonMethod subTime:result];
                _hasPickView = NO;
                
                _alertScreeningEntity.timeFrom = time;
                [_mainTableView reloadData];
            }];

        }
     
    }
}

#pragma mark-<SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem{
    
    NSIndexPath *indexPth = [NSIndexPath indexPathForRow:0 inSection:0];
    _alertScreeningEntity.employeeKeyId = selectRemindItem.resultKeyId;
    _alertScreeningEntity.employeeName = selectRemindItem.resultName;
    [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TCPickViewDelegate
- (void)pickViewRemove
{
    _hasPickView = NO;
}

#pragma mark - TextFieldChangeEvent
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
    _alertScreeningEntity.remark = textField.text;
}


@end
