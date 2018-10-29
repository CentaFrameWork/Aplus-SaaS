//
//  SettingImgViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SettingImgViewController.h"
#import "SettingChatSwitchCell.h"


@interface SettingImgViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
}

@end

@implementation SettingImgViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"图片设置"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingChatSwitchCellId = @"settingChatSwitchCell";
    
    SettingChatSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:settingChatSwitchCellId];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SettingChatSwitchCell"
                                              bundle:nil]
        forCellReuseIdentifier:settingChatSwitchCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:settingChatSwitchCellId];
    }
    
    BOOL onlyWifiShowImg = [[NSUserDefaults standardUserDefaults] boolForKey:ShowImageOnlyWIFI];
    
    cell.rightSwitchItem.on = onlyWifiShowImg;
    [cell.rightSwitchItem addTarget:self
                             action:@selector(setOnlyWifiShowImg:)
                   forControlEvents:UIControlEventValueChanged];
    
    cell.leftTextLabel.text = @"仅Wi-Fi网络显示图片";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    [headerView setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 35)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"图片显示设置"];
    [titleLabel setFont:[UIFont fontWithName:FontName
                                        size:13.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:LITTLE_BLACK_COLOR];
    [titleLabel setFrame: CGRectMake(15, 0, APP_SCREEN_WIDTH-15, 35)];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

/**
 *  设置是否只有在wifi情况下显示图片
 */
- (void)setOnlyWifiShowImg:(UISwitch *)sender
{
    [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:sender.isOn]
                                   forKey:ShowImageOnlyWIFI];
}

@end
