//
//  MyClientFilterVC.m
//  PanKeTong
//
//  Created by 乔书超 on 2017/11/3.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "MyClientFilterVC.h"
#import "SearchRemindPersonViewController.h"

@interface MyClientFilterVC ()<UITableViewDelegate, UITableViewDataSource, SearchRemindPersonDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    NSArray *_dataSource;
    
    SearchRemindType selectRemindType;
    RemindPersonDetailEntity *_remindPersonDetailEntity1;   // 部门
    RemindPersonDetailEntity *_remindPersonDetailEntity2;   // 人员
}

@end

@implementation MyClientFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];
    [self initData];
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)initNav {
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
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
    UIButton *againSetting = [self customBarItemButton:@"重置"
                                       backgroundImage:nil
                                            foreground:nil
                                                   sel:@selector(againSetClick)];
    
    UIBarButtonItem *againSettingItem = [[UIBarButtonItem alloc] initWithCustomView:againSetting];
    self.navigationItem.rightBarButtonItems = @[commitBtnItem,againSettingItem];
}

- (void)initData {
    _dataSource = @[@"部门",@"人员"];
}

#pragma mark - ItemEvent

- (void)commitClick {
    if ([self.delegate respondsToSelector:@selector(finishFilter:)]) {
        [self.delegate finishFilter:_remindPersonDetailEntity1];
    }
    [self back];
}

- (void)againSetClick {
    _remindPersonDetailEntity1 = nil;
    _remindPersonDetailEntity2 = nil;
    [_mainTableView reloadData];
}

#pragma mark - <UITableViewDelegate && DataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    UILabel *detailLabel = [cell.contentView viewWithTag:100];
    if (detailLabel == nil)
    {
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 250, 7, 200, 30)];
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.tag = 100;
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detailLabel];
    }
    
    if (indexPath.row == 0)
    {
        detailLabel.text = _remindPersonDetailEntity1.departmentName;
    }
    else
    {
        detailLabel.text = _remindPersonDetailEntity2.resultName;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label =[[UILabel alloc]init];
    label.text = @"客源归属";
    label.textColor = LITTLE_BLACK_COLOR;
    label.font = [UIFont fontWithName:FontName size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchRemindPersonViewController *vc = [[SearchRemindPersonViewController alloc] init];
    if (indexPath.row == 0)
    {
        //部门
        selectRemindType = DeparmentType;
        vc.selectRemindTypeStr = ClientFilterDepartmentType;
    }
    else
    {
        //人员
        if (_remindPersonDetailEntity1.departmentKeyId.length > 0)
        {
            vc.departmentKeyId = _remindPersonDetailEntity1.departmentKeyId;
        }
        selectRemindType = PersonType;
        vc.selectRemindTypeStr = ClientFilterPersonType;
    }
    
    vc.selectRemindType = selectRemindType;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-<SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem {
    
    NSIndexPath *indexPth;
    if (selectRemindType == DeparmentType)
    {
        // 部门改变，人员置空
        indexPth = [NSIndexPath indexPathForRow:0 inSection:0];
        _remindPersonDetailEntity1 = selectRemindItem;
        _remindPersonDetailEntity2 = nil;
    }
    else
    {
        // 人员改变，部门联动
        indexPth = [NSIndexPath indexPathForRow:1 inSection:0];
        _remindPersonDetailEntity2 = selectRemindItem;
        _remindPersonDetailEntity1 = selectRemindItem;
    }
    
    [_mainTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
