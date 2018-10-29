//
//  LookKeyViewController.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "LookKeyViewController.h"
#import "CheckTheKeysCell.h"
#import "CheckTheKeyPersonCell.h"
#import "CheckTheKeyThat.h"
#import "PropKeyViewController.h"

@interface LookKeyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSDictionary *dataDict;
@end

@implementation LookKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL isCanEdit = [AgencyUserPermisstionUtil hasRight:PROPERTY_KEY_MODIFY_ALL];
    if (isCanEdit) {
        [self setNavTitle:@"查看钥匙" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"编辑" backgroundImage:nil foreground:nil sel:@selector(theEditor)]];
    }else{
        [self setNavTitle:@"查看钥匙" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    }
    
    _dataDict = [[NSDictionary alloc] init];
        
    [self TableView];
    [self initData];
}

- (void)initData {
    
    NSString *string = [NSString stringWithFormat:@"%@?PropertyKeyId=%@",AipPropertyKey,_keyId];
    [AFUtils GET:string controller:self successfulDict:^(NSDictionary *successfuldict) {
        _dataDict = successfuldict;
        [_tableView reloadData];
    } failureDict:^(NSDictionary *failuredict) {
        
    } failureError:^(NSError *failureerror) {
        
    }];
}

- (void)TableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *reuseID = @"cell0";
        CheckTheKeysCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[CheckTheKeysCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // 状态  1无  2在店  3同行
        if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"1"]) {
            cell.label.text = @"无";
            cell.lineView.hidden = YES;
        }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"2"]) {
            cell.label.text = @"在店";
            cell.lineView.hidden = NO;
        }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"3"]) {
            cell.label.text = @"同行";
            cell.lineView.hidden = NO;
        }
        return cell;
    }
    if (indexPath.row == 1) {
        if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"2"]) {
            static NSString *reuseID = @"cell1";
            CheckTheKeyPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell) {
                cell = [[CheckTheKeyPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.label.text = _dataDict[@"Receiver"];
            
            return cell;
        }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"3"]) {
            static NSString *reuseID = @"cell2";
            CheckTheKeyThat *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell) {
                cell = [[CheckTheKeyThat alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.string = _dataDict[@"Remark"];
            return cell;
        }
    }
    if (indexPath.row == 2) {
        static NSString *reuseID = @"cell2";
        CheckTheKeyThat *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[CheckTheKeyThat alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.string = _dataDict[@"Remark"];
        return cell;
    }
    
    
    
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


// 返回每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"1"]) {
        return 1;
    }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"2"]) {
        return 3;
    }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"3"]) {
        return 2;
    }
    return 3;
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 257*NewRatio;
    }else if (indexPath.row == 1) {
        if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"2"]) {
            return 50*NewRatio;
        }else if ([[NSString stringWithFormat:@"%@",_dataDict[@"PropertyKeyStatus"]] isEqualToString: @"3"]) {
            CGSize size = CGSizeMake(APP_SCREEN_WIDTH-50*NewRatio, CGFLOAT_MAX);
            NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
            CGSize titleh = [_dataDict[@"Remark"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            CGFloat titleH = titleh.height;
            if (titleH > 200*NewRatio-24*NewRatio) {
                return titleH+150*NewRatio;
            }else {
                return 250*NewRatio;
            }
        }else {
            return 1;
        }
    }else if (indexPath.row == 2) {
        CGSize size = CGSizeMake(APP_SCREEN_WIDTH-50*NewRatio, CGFLOAT_MAX);
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
        CGSize titleh = [_dataDict[@"Remark"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat titleH = titleh.height;
        if (titleH > 200*NewRatio-24*NewRatio) {
            return titleH+150*NewRatio;
        }else {
            return 250*NewRatio;
        }
    }else {
        return 1;
    }
}

- (void)theEditor {
    PropKeyViewController *keyBoxVC = [[PropKeyViewController alloc] init];
    keyBoxVC.keyId = _keyId;
    keyBoxVC.theRefreshata = ^{
        showMsg(@"钥匙修改成功！");
        [self initData];
    };
    [self.navigationController pushViewController:keyBoxVC animated:YES];
}

@end
