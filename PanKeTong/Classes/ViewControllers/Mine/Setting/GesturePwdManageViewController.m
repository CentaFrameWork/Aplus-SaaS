//
//  GesturePwdManageViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/3/31.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GesturePwdManageViewController.h"

@interface GesturePwdManageViewController ()
{
    NSString *_timeSpan;
}

@end

@implementation GesturePwdManageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"手势密码"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _timeSpan = [userDefault objectForKey:AutoGestureLockTimeSpan];
    
    [_mainTableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gestrueCell = @"arrowSignTextCell";
    ArrowSignTextCell *cell = [tableView dequeueReusableCellWithIdentifier:gestrueCell];
    
    NSInteger row = indexPath.row;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                              bundle:nil]
        forCellReuseIdentifier:gestrueCell];
        cell = [tableView dequeueReusableCellWithIdentifier:gestrueCell];
    }
    
    switch (row) {
        case 0:
        {
            cell.leftTextLabel.text = @"自动锁定";
            cell.rightTextLabel.text = [NSString stringWithFormat:@"%@分钟",_timeSpan];
        }
            break;
            
        case 1:
        {
            cell.leftTextLabel.text = @"修改手势密码";
            cell.rightTextLabel.text = @"";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == 0)
    {
        AutoLockTimeSpanSettingsViewController *autoLockTimeSpanSettings = [[AutoLockTimeSpanSettingsViewController alloc]initWithNibName:@"AutoLockTimeSpanSettingsViewController" bundle:nil];
        [self.navigationController pushViewController:autoLockTimeSpanSettings animated:YES];
    }
    else
    {
        [self showSetGesturePwd];
    }
}

- (void)showSetGesturePwd
{
    [CLLockVC showSettingLockVCInVC:self.navigationController.self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        
        NSLog(@"密码设置成功");
        [lockVC dismiss:1.0f];
    } isShowNavClose:YES];
}

@end
