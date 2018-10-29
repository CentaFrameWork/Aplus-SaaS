//
//  SendMessageVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/5.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SendMessageVC.h"
#import "ContactsCell.h"
#import "MessageContentCell.h"

@interface SendMessageVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSString *_sendMessageContent;//发送短信内容
}

@end

@implementation SendMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"发送带看短信"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"关闭"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(closeAction:)]];

    [self initView];

    
}


#pragma mark-<关闭>
- (void)closeAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-<设置UI>
- (void)initView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -35, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 19) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

#pragma mark-<提交>
- (void)commitAction:(UIButton *)btn{

    //弹框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功!"
                                                        message:@"等待短信服务商发送至用户"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
    [alertView show];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 50;
    }
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 200;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 50)];
        headLabel.backgroundColor = [UIColor whiteColor];
        headLabel.text = @"   联系人";
        headLabel.font = [UIFont systemFontOfSize:16.0];
        return headLabel;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 200)];

        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.frame = CGRectMake((APP_SCREEN_WIDTH - 190) / 2, 50, 190, 40);
        commitBtn.backgroundColor = RGBColor(234, 39, 11);
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:commitBtn];
        return footView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //房源信息
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        UILabel *LeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 30)];
        LeftLabel.textColor = [UIColor blackColor];
        LeftLabel.font = [UIFont systemFontOfSize:16.0];
        LeftLabel.text = @"小区";
        [cell.contentView addSubview:LeftLabel];

        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 320, 10, 300, 30)];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.font = [UIFont systemFontOfSize:16.0];
        rightLabel.text = @"306医院宿舍楼 01号楼 1114";
        [cell.contentView addSubview:rightLabel];
        return cell;
    }
    else if (indexPath.section == 1){
        //联系人
        ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    //短信内容
    MessageContentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageContentCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}







@end
