//
//  MyLiangHuaViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/24.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MyLiangHuaViewController.h"
#import "MyLiangHuaTableViewCell.h"
#import "MyQuantificationEntity.h"
#import "getQuantificationEntitiy.h"
#import "getQuantificationItemEntitiy.h"
#import "GetQuantificationSubEntitiy.h"
#import "GetTJQuantificationSubEntity.h"
#import "MyQuantificationApi.h"
#import "HQMyLiangHuaEntity.h"
#import "MyLiangHuaBJPresenter.h"
#import "MyLiangHuaNJPresenter.h"
#import "MyLiangHuaTJPresenter.h"
#import "MyLiangHuaSZPresenter.h"
#import "MyLiangHuaGZPresenter.h"
#import "MyLiangHuaCQPresenter.h"
#import "MyLiangHuaAMPresenter.h"
#import "MyLiangHuaCSPresenter.h"


@interface MyLiangHuaViewController ()<UITableViewDelegate,UITableViewDataSource,MyLiangHuaViewProtocol>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    NSArray * _nameArray;
    BOOL  _isHidden;        //是否隐藏
    NSDictionary *_responseData;
    MyQuantificationEntity * _myInfoEntity;
    GetQuantificationEntitiy *_getOpmQuantificationEntity;
    GetQuantificationItemEntitiy *_getOpmQuantificationItemEntity;//深圳二级实体
    GetQuantificationSubEntitiy *_getQuantificationSubEntitiy;//北京二级实体
    GetTJQuantificationSubEntity *_getTJQuantificationSubEntity;//天津二级实体
    HQMyLiangHuaEntity *_hqQuantificationEntity;
    NSString *_singedText;
    
    MyLiangHuaBasePresenter *_liangHuaBasePresenter;
}
@end

@implementation MyLiangHuaViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self initPresenter];
    [self initArray];
    [self initNavTitleView];
    [self getMyQuantificationInfo];
    _mainTableView.tableFooterView=[[UIView alloc]init];
    _isHidden=YES;
}

- (void)initPresenter
{
    if ([CityCodeVersion isShenZhen]) {
        _liangHuaBasePresenter = [[MyLiangHuaSZPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isNanJing]) {
        _liangHuaBasePresenter = [[MyLiangHuaNJPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isTianJin]) {
        _liangHuaBasePresenter = [[MyLiangHuaTJPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isBeiJing]) {
        _liangHuaBasePresenter = [[MyLiangHuaBJPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isGuangZhou]) {
        _liangHuaBasePresenter = [[MyLiangHuaGZPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isChongQing]) {
        _liangHuaBasePresenter = [[MyLiangHuaCQPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isAoMenHengQin]) {
        _liangHuaBasePresenter = [[MyLiangHuaAMPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isChangSha]) {
        _liangHuaBasePresenter = [[MyLiangHuaCSPresenter alloc] initWithDelegate:self];
    }else{
        _liangHuaBasePresenter = [[MyLiangHuaBasePresenter alloc] initWithDelegate:self];
    }
}

- (void)initNavTitleView
{
    [self setNavTitle:@"我的量化"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initArray
{
    _singedText = [_liangHuaBasePresenter getAddOnlyTrustName];
    _nameArray=[[NSArray alloc]initWithObjects:@"新增房源",_singedText,@"新增实勘",@"新增客源",@"客源跟进",@"新增钥匙",@"房源跟进",@"新增带看", nil];
}

#pragma mark - <Request>
- (void)getMyQuantificationInfo
{
    [self showLoadingView:@""];
    MyQuantificationApi *myQuantificationApi = [[MyQuantificationApi alloc] init];
    NSString *departId = [AgencyUserPermisstionUtil getIdentify].departId;
    NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
    myQuantificationApi.userKeyId = userKeyId;
    myQuantificationApi.DepartmentKeyId = departId;
    [_manager sendRequest:myQuantificationApi];
}


#pragma mark - <TableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 50)];
    imageView.image = [UIImage imageNamed:@"MyLiHua_bg.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 150, 30)];
    label.text = [NSString stringWithFormat:@"%@%@，",self.userDepartMent,self.userName];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:FontName size:15.0];
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/237.0 blue:102.0/237.0 alpha:1.0];
    label.width = [label.text widthWithLabelFont:[UIFont systemFontOfSize:15]] + 5;
    
    if (label.width >= 150) {
        label.width = 150;
    }
    
    [view addSubview:label];
    
    UILabel *hellolabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right + 5, 10, 150, 30)];
    hellolabel.text = @"你好";
    hellolabel.numberOfLines = 0;
    hellolabel.font = [UIFont fontWithName:FontName size:15.0];
    hellolabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/237.0 blue:102.0/237.0 alpha:1.0];
    [view addSubview:hellolabel];

      return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"liangHuaCell";
    MyLiangHuaTableViewCell *messageCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!messageCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"MyLiangHuaTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        
        messageCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    messageCell.valueLabel.hidden = _isHidden;
    NSString *nameString = _nameArray[indexPath.row];
    messageCell.nameLabel.text = nameString;
    
    NSString *newPropertysString = @"";//新增房源
    NSString *newOnlyTrustsString = @"";//新增独家
    NSString *newRealsString = @"";//新增实勘
    NSString *newInquirysString = @"";//新增客源
    NSString *newyInquiryFollowsString = @"";//客源跟进
    NSString *newKeysString = @"";//新增钥匙
    NSString *newPropertyFollowsString = @"";//房源跟进
    NSString *newTakeSeesString = @"";//新增带看
    
    //新增房源
    newPropertysString = [_liangHuaBasePresenter getNewPropertysString:_responseData];
    //签约---新增独家
    newOnlyTrustsString = [_liangHuaBasePresenter getNewOnlyTrustsString:_responseData];
    //新增实勘
    newRealsString = [_liangHuaBasePresenter getNewRealsString:_responseData];
    ///新增客源
    newInquirysString = [_liangHuaBasePresenter getNewInquirysString:_responseData];
    //客源跟进
    newyInquiryFollowsString = [_liangHuaBasePresenter getNewInquiryFollowsString:_responseData];
    //新增钥匙
    newKeysString = [_liangHuaBasePresenter getNewKeysString:_responseData];
    //房源跟进
    newPropertyFollowsString = [_liangHuaBasePresenter getNewPropertyFollowsString:_responseData];
    //新增带看
    newTakeSeesString = [_liangHuaBasePresenter getNewTakeSeesString:_responseData];
   
    
    
    if ([nameString isEqualToString:@"新增房源"])
    {
        if (_getQuantificationSubEntitiy == nil) {
            messageCell.valueLabel.text = @"0";
        }
        messageCell.valueLabel.text = newPropertysString;
    }
    if ([nameString isEqualToString:_singedText])
    {
        messageCell.valueLabel.text = (newOnlyTrustsString == nil) ?  @"0" : newOnlyTrustsString;
    }
    if ([nameString isEqualToString:@"新增实勘"])
    {
        messageCell.valueLabel.text = (newRealsString == nil) ? @"0" : newRealsString;
    }
    if ([nameString isEqualToString:@"新增客源"])
    {
        messageCell.valueLabel.text = (newInquirysString == nil) ? @"0" : newInquirysString;
    }
    if ([nameString isEqualToString:@"客源跟进"])
    {
        messageCell.valueLabel.text = (newyInquiryFollowsString == nil) ? @"0" : newyInquiryFollowsString;
    }
    if ([nameString isEqualToString:@"新增钥匙"])
    {
        messageCell.valueLabel.text = (newKeysString == nil) ? @"0" : newKeysString;
    }
    if ([nameString isEqualToString:@"房源跟进"])
    {
        messageCell.valueLabel.text = (newPropertyFollowsString == nil) ? @"0" : newPropertyFollowsString;
    }
    if ([nameString isEqualToString:@"新增带看"])
    {
        messageCell.valueLabel.text = (newTakeSeesString == nil) ? @"0" : newTakeSeesString;
    }

    return messageCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0) {
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
    
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    _responseData = (NSDictionary *)data;
    
    if ([modelClass isEqual:[MyQuantificationEntity class]]) {
        //天津/南京/重庆
        [self hiddenLoadingView];
        _myInfoEntity = [DataConvert convertDic:data toEntity:modelClass];
    }
    if ([modelClass isEqual:[GetQuantificationEntitiy class]]){
        [self hiddenLoadingView];
        _getOpmQuantificationEntity = [DataConvert convertDic:data toEntity:modelClass];

        if (_getOpmQuantificationEntity.workStats.count > 0) {
            //深圳
            if ([_getOpmQuantificationEntity.workStats[0] isKindOfClass:[GetQuantificationItemEntitiy class]]) {
                _getOpmQuantificationItemEntity = (GetQuantificationItemEntitiy *)_getOpmQuantificationEntity.workStats[0];
            }
            else if ([_getOpmQuantificationEntity.workStats[0] isKindOfClass:[GetQuantificationSubEntitiy class]]){
                //北京
                _getQuantificationSubEntitiy = (GetQuantificationSubEntitiy *)_getOpmQuantificationEntity.workStats[0];
            }
            else if ([_getOpmQuantificationEntity.workStats[0] isKindOfClass:[GetTJQuantificationSubEntity class]]){
                //天津
                _getTJQuantificationSubEntity = (GetTJQuantificationSubEntity *)_getOpmQuantificationEntity.workStats[0];
            }
            else if ([_getOpmQuantificationEntity.workStats[0] isKindOfClass:[HQMyLiangHuaEntity class]]){
                //横琴
                _hqQuantificationEntity = (HQMyLiangHuaEntity *)_getOpmQuantificationEntity.workStats[0];
            }
        }

    }

    _isHidden = NO;
    [_mainTableView reloadData];
}

/// 新增独家/新增签约
- (NSString *)getAddOnlyTrustName
{
    return @"新增签约";
}

@end
