//
//  WJDealProgressController.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/22.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJDealProgressController.h"

@interface WJDealProgressController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_mainTableView;
}

@property (nonatomic, strong) NSMutableArray<ZYCodeName *> * stateArr;

@end

static NSString *const CELLID = @"Cell";

@implementation WJDealProgressController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
}


#pragma mark - 建立视图
- (void)setUpView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"成交进度"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    //添加tableView
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
   
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    
}

#pragma mark - tableView代理事件
/**
 * tableView的分区数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/**
 * tableView分区里的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stateArr.count;
    
}

/**
 * tableViewCell的相关属性
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    
    //修改cell属性，使其在选中时无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.stateArr[indexPath.row].name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    cell.textLabel.textColor = YCTextColorBlack;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
}
/**
 * tableViewCell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


/**
 * 分区头的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

/**
 * 分区脚的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

/**
 * tableViewCell的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //传值
    if ([self.delegate respondsToSelector:@selector(selectProgressSuccss:)]) {
        
        [self.delegate selectProgressSuccss:self.stateArr[indexPath.row]];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - getter
- (NSMutableArray *)stateArr{
    
    if (!_stateArr) {
        
        _stateArr = [ZYCodeName codeNameArrWithFileName:@"deal_screen_progress.plist"];
        
    }
    
    return _stateArr;
    
}

@end
