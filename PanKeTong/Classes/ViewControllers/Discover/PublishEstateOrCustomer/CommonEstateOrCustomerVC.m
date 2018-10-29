//
//  PublishEstateOrCustomerViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CommonEstateOrCustomerVC.h"
#import "PublishEstOrCusCell.h"
#import "PublishEstEntity.h"
#import "PublishCusEntity.h"
#import "PublishCustomerListCell.h"
#import "PublishEstDetailViewController.h"
#import "PublishCusDetailViewController.h"
#import "PublishEstOrCustomerApi.h"


@interface CommonEstateOrCustomerVC ()<UITableViewDataSource,UITableViewDelegate,PublishCusDetailDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    NSMutableArray *_publishEstOrCusArray;
}

@end

@implementation CommonEstateOrCustomerVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkPermission:^(NSString *permission)
    {
        [self initView];
        [self initData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - init

- (void)initView
{
    NSString *navTitleStr;
    
    if (_isPublishEstate)
    {
        navTitleStr = @"抢公盘";
    }
    else
    {
        navTitleStr = @"抢公客";
    }
    
    [self setNavTitle:navTitleStr
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
   
    _mainTableView.tableFooterView = [[UIView alloc]init];
}

- (void)checkPermission:(HaveMenuPermissionBlock)block
{
    if(_isPublishEstate)
    {
        [self checkShowViewPermission:MENU_PROPERTY_PUBLIC_ESTATE andHavePermissionBlock:block];
    }
    else
    {
        [self checkShowViewPermission:MENU_CUSTOMER_PUBLIC_CUSTOMER andHavePermissionBlock:block];
    }
}

- (void)initData
{
    _publishEstOrCusArray = [[NSMutableArray alloc]init];
    
    [self headerRefreshMethod];
}

#pragma mark - <RefreshMethod>

- (void)headerRefreshMethod
{
    [self showLoadingView:@""];
    
    if (_isPublishEstate)
    {
        // 公盘
        PublishEstOrCustomerApi *publishEstOrCustomerApi = [[PublishEstOrCustomerApi alloc] init];
        publishEstOrCustomerApi.requestType = GetPublishEstateList;
        [_manager sendRequest:publishEstOrCustomerApi];
    }
    else
    {
        // 公客
        PublishEstOrCustomerApi *publishEstOrCustomerApi = [[PublishEstOrCustomerApi alloc] init];
        publishEstOrCustomerApi.requestType = GetPublishCustomerList;
        [_manager sendRequest:publishEstOrCustomerApi];
    }
}

#pragma mark - <PublishCusDetailDelegate>

- (void)backToPublishEstateOrCusDetail:(NSString *)publishCusKeyId
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < _publishEstOrCusArray.count; i++) {
        PublishCusDetailEntity *entity = (PublishCusDetailEntity *)_publishEstOrCusArray[i];
        if (entity.keyId != publishCusKeyId)
        {
            [array addObject:entity];
        }
    }
    
    [_publishEstOrCusArray removeAllObjects];
    _publishEstOrCusArray = [NSMutableArray arrayWithArray:array];
    
    [_mainTableView reloadData];
}


#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _publishEstOrCusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *publishEstCellId = @"publishEstOrCusCell";
    static NSString *publishCusCellId = @"publishCustomerListCell";
    
    PublishEstOrCusCell *publishEstCell = [tableView dequeueReusableCellWithIdentifier:publishEstCellId];
    PublishCustomerListCell *publishCusCell = [tableView dequeueReusableCellWithIdentifier:publishCusCellId];
    
    id publishDetailEntity = [_publishEstOrCusArray objectAtIndex:indexPath.row];
    
    if ([publishDetailEntity isKindOfClass:[PublishEstDetailEntity class]])
    {
        if (!publishEstCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublishEstOrCusCell"
                                                  bundle:nil]
            forCellReuseIdentifier:publishEstCellId];
            
            publishEstCell = [tableView dequeueReusableCellWithIdentifier:publishEstCellId];
        }
        
        // 公盘
        PublishEstDetailEntity *pubEstDetailEntity = [_publishEstOrCusArray objectAtIndex:indexPath.row];
        
        /**
         *  显示内容：楼盘名、栋座单元
         */
        publishEstCell.leftDetailLabel.text = pubEstDetailEntity.estateName;
        publishEstCell.leftSecondDetailLabel.text = pubEstDetailEntity.buildingName;
        
        publishEstCell.rightFirstEstTypeImageView.hidden = YES;
        publishEstCell.rightSecondEstTypeImageView.hidden = YES;
        
        switch (pubEstDetailEntity.trustType.integerValue) {
            case TrustTypeSale:
            {
                // 出售
                publishEstCell.rightFirstEstTypeImageView.hidden = NO;
                [publishEstCell.rightFirstEstTypeImageView setImage:[UIImage imageNamed:@"publishEstSaleType_icon"]];
            }
                break;
            case TrustTypeRent:
            {
                // 出租
                publishEstCell.rightFirstEstTypeImageView.hidden = NO;
                [publishEstCell.rightFirstEstTypeImageView setImage:[UIImage imageNamed:@"publishEstRentType_icon"]];
            }
                break;
            case TrustTypeBoth:
            {
                // 租售
                publishEstCell.rightFirstEstTypeImageView.hidden = NO;
                publishEstCell.rightSecondEstTypeImageView.hidden = NO;
                
                [publishEstCell.rightFirstEstTypeImageView setImage:[UIImage imageNamed:@"publishEstSaleType_icon"]];
                [publishEstCell.rightSecondEstTypeImageView setImage:[UIImage imageNamed:@"publishEstRentType_icon"]];
            }
                break;
                
            default:
                break;
        }
        
        return publishEstCell;
        
    }
    else if ([publishDetailEntity isKindOfClass:[PublishCusDetailEntity class]])
    {
        if (!publishCusCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublishCustomerListCell"
                                                  bundle:nil]
            forCellReuseIdentifier:publishCusCellId];
            publishCusCell = [tableView dequeueReusableCellWithIdentifier:publishCusCellId];
        }
        
        // 公客
        PublishCusDetailEntity *pubCusDetailEntity = [_publishEstOrCusArray objectAtIndex:indexPath.row];
        
        /**
         *  显示内容：客户名、城区、目标楼盘
         */
        publishCusCell.leftDetailLabel.text = pubCusDetailEntity.customerName;
        
        NSMutableString *leftSecondMutlStr = [[NSMutableString alloc]init];
        
        if (pubCusDetailEntity.districts &&
            ![pubCusDetailEntity.districts isEqualToString:@""])
        {
            [leftSecondMutlStr appendFormat:@"%@",pubCusDetailEntity.districts];
        }
        if (pubCusDetailEntity.targetEstateName &&
            ![pubCusDetailEntity.targetEstateName isEqualToString:@""])
        {
            [leftSecondMutlStr appendFormat:@"%@",pubCusDetailEntity.targetEstateName];
        }
        
        publishCusCell.leftSecondDetailLabel.text = leftSecondMutlStr;
        
        publishCusCell.customerTypeLabel.text = pubCusDetailEntity.inquiryTradeType;
        
        if ([pubCusDetailEntity.inquiryTradeType isEqualToString:@"求购"])
        {
            publishCusCell.customerTypeLabel.backgroundColor = RED_COLOR;
            
        }
        else if ([pubCusDetailEntity.inquiryTradeType isEqualToString:@"求租"])
        {
            publishCusCell.customerTypeLabel.backgroundColor = GREEN_COLOR;
            
        }
        else if ([pubCusDetailEntity.inquiryTradeType isEqualToString:@"租购"])
        {
            publishCusCell.customerTypeLabel.backgroundColor = LITTLE_BLUE_COLOR;
        }
        
        return publishCusCell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (_isPublishEstate)
    {
        // 公盘列表
        PublishEstDetailEntity *pubEstDetailEntity = [_publishEstOrCusArray objectAtIndex:indexPath.row];
        
        PublishEstDetailViewController *publishEstDetailVC = [[PublishEstDetailViewController alloc]
                                                              initWithNibName:@"PublishEstDetailViewController"
                                                              bundle:nil];
        publishEstDetailVC.publishEstId = pubEstDetailEntity.keyId;
        publishEstDetailVC.selectTrustType = pubEstDetailEntity.trustType.integerValue;
        
        [self.navigationController pushViewController:publishEstDetailVC
                                             animated:YES];
    }
    else
    {
        // 公客列表
        PublishCusDetailEntity *pubCusDetailEntity = [_publishEstOrCusArray objectAtIndex:indexPath.row];
        
        PublishCusDetailViewController *publishCusDetailVC = [[PublishCusDetailViewController alloc]
                                                              initWithNibName:@"PublishCusDetailViewController"
                                                              bundle:nil];
        publishCusDetailVC.publishCusKeyId = pubCusDetailEntity.keyId;
        publishCusDetailVC.tradeType = pubCusDetailEntity.inquiryTradeType;
        publishCusDetailVC.selectCusName = pubCusDetailEntity.customerName;
        publishCusDetailVC.delegate = self;
        
        [self.navigationController pushViewController:publishCusDetailVC
                                             animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0)
        {
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[PublishEstEntity class]])
    {
        // 公盘
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];

        PublishEstEntity *publishEstEntity = [DataConvert convertDic:data toEntity:modelClass];

        [_publishEstOrCusArray removeAllObjects];
        [_publishEstOrCusArray addObjectsFromArray:publishEstEntity.publishEstates];

        [_mainTableView reloadData];
    }
    else if ([modelClass isEqual:[PublishCusEntity class]])
    {
        // 公客
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];

        PublishCusEntity *publishCusEntity = [DataConvert convertDic:data toEntity:modelClass];

        [_publishEstOrCusArray removeAllObjects];
        [_publishEstOrCusArray addObjectsFromArray:publishCusEntity.publicCustomers];

        [_mainTableView reloadData];
    }

    if (_publishEstOrCusArray.count == 0)
    {
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:YES];
    }
    else
    {
        [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                            andOnView:_mainTableView
                              andShow:NO];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
}

@end
