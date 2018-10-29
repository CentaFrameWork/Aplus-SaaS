//
//  AutoLockTimeSpanSettingsViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/3/31.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AutoLockTimeSpanSettingsViewController.h"

@interface AutoLockTimeSpanSettingsViewController ()
{
    NSInteger _selectIndex;
}

@end

@implementation AutoLockTimeSpanSettingsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"自动锁定"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    _selectIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeSpan = [userDefault objectForKey:AutoGestureLockTimeSpan];
    
    _selectIndex = [timeSpan intValue]-1;
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *timeSpanCell = @"autoLockTimeSpanCell";
    AutoLockTimeSpanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeSpanCell];
    
    NSInteger row = indexPath.row;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"AutoLockTimeSpanTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:timeSpanCell];
        cell = [tableView dequeueReusableCellWithIdentifier:timeSpanCell];
    }
    
    cell.timeSpanLabel.text = [NSString stringWithFormat:@"%ld分钟",row+1];
    
    if(_selectIndex == row)
    {
        cell.selectImg.hidden = NO;
    }
    else
    {
        cell.selectImg.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [_mainTableView reloadData];
    
    NSString *value = [NSString stringWithFormat: @"%d",  (indexPath.row + 1)];
    [CommonMethod setUserdefaultWithValue:value forKey:AutoGestureLockTimeSpan];
}


@end
