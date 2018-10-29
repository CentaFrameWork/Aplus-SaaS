//
//  AdjustThePriceVC.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AdjustThePriceVC.h"
#import "ReactiveCocoa.h"
#import "AdjustThePriceCell.h"

@interface AdjustThePriceVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSString *totalPriceStr;       // 总价
@property (nonatomic, strong)NSString *rentsStr;            // 租价

@end

@implementation AdjustThePriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"调价" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"提交" backgroundImage:nil foreground:nil sel:@selector(commitNewOpening)]];
    
    
    [self TableView];
}

- (void)TableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"cell";
    AdjustThePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[AdjustThePriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.type = _type;
    cell.textFieldPrice.tag = indexPath.row;
    [cell.textFieldPrice addTarget:self action:@selector(inputLenth:) forControlEvents:UIControlEventAllEvents];
    if (indexPath.row == 0) {
        if (_type == 1 || _type == 3) {
            cell.textLabel.text = _totalPriceStr;
        }
        else if (_type == 2) {
            cell.textLabel.text = _rentsStr;
        }
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = _rentsStr;
    }
    
    return cell;
}

// 返回每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == 3) {
        return 2;
    }
    return 1;
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80*ratio2;
}

- (void)inputLenth:(UITextField *)input {
    if (input.tag == 0) {
        if (_type == 1 || _type == 3) {
            _totalPriceStr = input.text;
        }
        else if (_type == 2) {
            _rentsStr = input.text;
        }
    }
    else if (input.tag == 1) {
        _rentsStr = input.text;
    }
    
}

// 提交
- (void)commitNewOpening {
    
    if (_type == 1) {
        if (_totalPriceStr.length == 0) {
            showMsg(@"请输入价格！");
        }
    }
    else if (_type == 2) {
        if (_rentsStr.length == 0) {
            showMsg(@"请输入价格！");
        }
    }
    else if (_type == 3) {
        if (_totalPriceStr.length == 0 || _rentsStr.length == 0) {
            showMsg(@"请输入价格！");
        }
    }
    
    NSDictionary *sict = @{
                           @"SalePrice":_totalPriceStr == nil?@"":_totalPriceStr,
                           @"RentPrice":_rentsStr == nil?@"":_rentsStr,
                           @"KeyId":_keyId,
                           @"TrustType":@(_type),
                           @"IsMobileRequest":@(1)
                           };
    
    [AFUtils POST:AipPropertyPriceModify parameters:sict controller:self successfulDict:^(NSDictionary *successfuldict) {
        [self.navigationController popViewControllerAnimated:YES];
        showMsg(@"提交成功！");
    } failureDict:^(NSDictionary *failuredict) {
        
    } failureError:^(NSError *failureerror) {
        
    }];
    
}

- (void)back {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃本次提交?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
        if (value.integerValue == 0) {
        }
        else if(value.integerValue == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
