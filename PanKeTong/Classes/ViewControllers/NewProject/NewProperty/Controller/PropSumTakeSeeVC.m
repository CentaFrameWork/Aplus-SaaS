//
//  PropSumTakeSeeVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/12.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "PropSumTakeSeeVC.h"

#import "PropTakeSeeCell.h"

#import "AllTakeSeesApi.h"
#import "SubTakingSeeEntity.h"

#import "UITableView+Category.h"

@interface PropSumTakeSeeVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_mainTableView;
    IBOutlet UIView *_headerView;

    AllTakeSeesApi *_allTakeSeesApi;
    NSMutableArray *_dataArr;
}

@end

@implementation PropSumTakeSeeVC

- (void)viewDidLoad {
    _isNewVC = YES;
    [super viewDidLoad];

    [self setNavTitle:@"房源带看量" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"back" sel:@selector(back)] rightButtonItem:nil];

    _allTakeSeesApi = [[AllTakeSeesApi alloc] init];
    _dataArr = [NSMutableArray array];

    [self initView];

    [self requestData];

}

- (void)initView{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.separatorColor = YCOtherColorDivider;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
}

- (void)requestData{
    _allTakeSeesApi.keyId = _propKeyId;
    [_manager sendRequest:_allTakeSeesApi];

    [self showLoadingView:nil];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"PropTakeSeeCell";
    
    PropTakeSeeCell *cell = [tableView tableViewCellByNibWithIdentifier:identifier];

    SubTakingSeeEntity *subEntity = _dataArr[indexPath.row];
    
    cell.firstLabel.text = [subEntity.takeSeeTime substringToIndex:10]; // 带看日期
    cell.secondLabel.text = subEntity.takingUserName;   // 带看人
    cell.thirdLabel.text = subEntity.departmentName;    // 部门
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 50);
    return _headerView;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass{
    
    [super dealData:data andClass:modelClass];

    if ([modelClass isEqual:[TakingSeeEntity class]]){
        TakingSeeEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        [_dataArr addObjectsFromArray:entity.takeSees];
        [_mainTableView reloadData];

        if (_dataArr.count == 0){
            _mainTableView.hidden = YES;
            [CustomAlertMessage showAlertMessage:@"该房源没有带看记录\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
        }
        else{
            _mainTableView.hidden = NO;
        }
    }
}

@end
