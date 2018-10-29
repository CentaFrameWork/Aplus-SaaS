//
//  JMSelectPropertyViewController.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMSelectPropertyViewController.h"

#import "JMSelectPropertySearchHeaderView.h"

#import "JMSelectPropertyCell.h"

#import "GetPropDetailApi.h"
#import "GetPropListApi.h"

#import "PropPageDetailEntity.h"
#import "PropListEntity.h"

#import "UITableView+Category.h"

@interface JMSelectPropertyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) JMSelectPropertySearchHeaderView * headerView;

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, weak) UILabel * noDatalabel;      // 暂无数据的提示;

@property (nonatomic, strong) PropertysModelEntty *propertysModelEntty;
@property (nonatomic, strong) PropPageDetailEntity *propPageDetailEntity;

@end

@implementation JMSelectPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    JMSelectPropertySearchHeaderView * headerView = [JMSelectPropertySearchHeaderView viewFromXib];
    headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 72);
    [headerView.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    UILabel * noDatalabel = [[UILabel alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 200) / 2, 200, 200, 200)];
    noDatalabel.text = @"没有找到您需要的房源～";
    noDatalabel.textAlignment = NSTextAlignmentCenter;
    noDatalabel.textColor = YCTextColorBlack;
    noDatalabel.hidden = YES;
    [self.view addSubview:noDatalabel];
    self.noDatalabel = noDatalabel;
    
}

- (void)loadNavigationBar{
    
    [self setNavTitle:self.searchText leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
    
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _propPageDetailEntity == nil ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"JMSelectPropertyCell";
    
    JMSelectPropertyCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.entity = self.propertysModelEntty;
    
    cell.detailEntity = self.propPageDetailEntity;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择房源---(关闭当前页面返回新增约看)
    NSArray *vcArr = self.navigationController.viewControllers;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectProperty" object:_propertysModelEntty];
    [self.navigationController popToViewController:[vcArr objectAtIndex:vcArr.count - 4] animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 235;
    
}

#pragma mark - reuqest
- (void)searchBtnClick{
    
    [self.view endEditing:YES];
    
    if (self.headerView.textField.text.length == 0){
        showMsg(@"请输入房号");
        return;
    }
    [self showLoadingView:nil];
    
    SysParamItemEntity *propStatus = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_STATUS];
    NSArray *listArr = propStatus.itemList;
    NSString *statusStr;
    for (SelectItemDtoEntity *entity in listArr){
        
        if ([entity.itemText isEqualToString:@"有效"]){
            
            statusStr = entity.itemValue;
            
            break;
        }
    }
    GetPropListApi *getPropListApi = [[GetPropListApi alloc] init];
    
    getPropListApi.keywordType = @"楼盘";
    
    NSArray *textArr = [_searchText componentsSeparatedByString:@"-"];
    getPropListApi.searchKeyWord = textArr[0];
    getPropListApi.buildingNames = textArr[1];
    getPropListApi.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ESTATENAME];
    NSString *searchNo = self.headerView.textField.text;
    getPropListApi.houseNo = searchNo;
    getPropListApi.propertyTypes = @[];
    getPropListApi.popStatus = @[statusStr];
    getPropListApi.houseDirection = @[];
    getPropListApi.propertyboolTag = @[];
    getPropListApi.buildTypes = @[];
    getPropListApi.hasPropertyKey = @"false";
    getPropListApi.propListTyp = @"1";
    getPropListApi.isNewProInThreeDay = @"false";
    getPropListApi.isOnlyTrust = @"false";
    getPropListApi.pageIndex = @"1";
    getPropListApi.isRecommend = @"false";
    NSString *propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    getPropListApi.scope = propScopeStr;
    [_manager sendRequest:getPropListApi];
    
}

- (void)requestData {
    
    if (self.propertysModelEntty.keyId.length > 0){
        
        GetPropDetailApi *getPropDetailApi = [[GetPropDetailApi alloc] init];
        getPropDetailApi.propKeyId = self.propertysModelEntty.keyId;
        [_manager sendRequest:getPropDetailApi];
        
    } else {
        
        self.noDatalabel.hidden = NO;
        self.propPageDetailEntity = nil;
        [self hiddenLoadingView];
        
    }
}

- (void)dealData:(id)data andClass:(id)modelClass {
    
    if ([modelClass isEqual:[PropListEntity class]]){
        
        PropListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.propertysModel.count > 0){
            
            self.noDatalabel.hidden = YES;
            self.propertysModelEntty = entity.propertysModel[0];
            // 加载房源详情
            [self requestData];
        } else {
            // 没有该房源消息
            self.noDatalabel.hidden = NO;
            self.propPageDetailEntity = nil;
            [self.tableView reloadData];
            [self hiddenLoadingView];
        }
    }
    
    if ([modelClass isEqual:[PropPageDetailEntity class]]){
        
        self.propPageDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [self hiddenLoadingView];
        [self.tableView reloadData];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];
}

@end
