//
//  PublishCusDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishCusDetailViewController.h"
#import "PublishCusDetailTitleCell.h"
#import "PublishEstDetailBasicMsgCell.h"
#import "PublishCusDetailPageMsgEntity.h"
#import "PublishEstOrCustomerApi.h"


#import "PublishCusDetailZJPresenter.h"


@interface PublishCusDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSArray *_publishCusTitleArray;
    
    PublishCusDetailPageMsgEntity *_publishCusDetailEntity;
    BOOL _isNowTransferPrivate; //是否正在请求转私客,防止多次点击
    BOOL _isTransferPrivate; // 是否已经转过私客
    
    PublishCusDetailBasePresenter *_publishCusDetailPresenter;
}


@end

@implementation PublishCusDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"公客详情"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"转私客"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(transPublishCusToPrivateCusMethod)]];
    
    [self initPresenter];
    [self initData];
    
    _isNowTransferPrivate = NO;
    _isTransferPrivate = NO;
}

#pragma mark - init

- (void)initData
{
    [self showLoadingView:nil];
    
    _publishCusTitleArray = [_publishCusDetailPresenter getPublishCusTitleArray:_tradeType];
    
    PublishEstOrCustomerApi *publishEstOrCustomerApi = [[PublishEstOrCustomerApi alloc] init];
    publishEstOrCustomerApi.requestType = GetPublishCustomerDetail;
    publishEstOrCustomerApi.keyId = _publishCusKeyId;
    publishEstOrCustomerApi.contactName = _selectCusName;
    [_manager sendRequest:publishEstOrCustomerApi];
}

- (void)initPresenter
{

        _publishCusDetailPresenter = [[PublishCusDetailBasePresenter alloc] initWithDelegate:self];
    
}

#pragma mark - ClickEvents

/// 公客转私客
- (void)transPublishCusToPrivateCusMethod
{
    // 是否需要验证权限
    if ([_publishCusDetailPresenter needCheckPermisstion])
    {
        if(![AgencyUserPermisstionUtil hasRight:CUSTOMER_PUBLICINQUIRY_MYSELF_OTHER])
        {
            showMsg(@(NotHavePermissionTip));
            return;
        }
    }
    
    if (_isNowTransferPrivate)
    {
        return;
    }
    
    [self showLoadingView:nil];

    PublishEstOrCustomerApi *publishEstOrCustomerApi = [[PublishEstOrCustomerApi alloc] init];
    publishEstOrCustomerApi.requestType = TransferPrivateInquiry;
    publishEstOrCustomerApi.inquiryKeyId = _publishCusKeyId;
    [_manager sendRequest:publishEstOrCustomerApi];

    _isNowTransferPrivate = YES;
    
}

- (void)back
{
    [super back];
    
    if (_isTransferPrivate)
    {
        if ([self.delegate respondsToSelector:@selector(backToPublishEstateOrCusDetail:)])
        {
            [self.delegate backToPublishEstateOrCusDetail:_publishCusKeyId];
        }
    }
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_publishCusDetailEntity)
    {
        return _publishCusTitleArray.count + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *publishCusTitleCellId = @"publishCusDetailTitleCell";
    static NSString *publishCusBasicCellId = @"publishEstDetailBasicMsgCell";
    
    PublishCusDetailTitleCell *publishCusTitleCell = [tableView dequeueReusableCellWithIdentifier:publishCusTitleCellId];
    PublishEstDetailBasicMsgCell *publishCusBasicCell = [tableView dequeueReusableCellWithIdentifier:publishCusBasicCellId];
    
    if (indexPath.row == 0)
    {
        if (!publishCusTitleCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublishCusDetailTitleCell" bundle:nil]
            forCellReuseIdentifier:publishCusTitleCellId];
            publishCusTitleCell = [tableView dequeueReusableCellWithIdentifier:publishCusTitleCellId];
        }
        
        publishCusTitleCell.cusDetailTitleLabel.text = _publishCusDetailEntity.customerName;
        
        return publishCusTitleCell;
    }
    else
    {
        if (!publishCusBasicCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublishEstDetailBasicMsgCell" bundle:nil]
            forCellReuseIdentifier:publishCusBasicCellId];
            publishCusBasicCell = [tableView dequeueReusableCellWithIdentifier:publishCusBasicCellId];
        }
        
        publishCusBasicCell.indexPath = indexPath;
        publishCusBasicCell.publishCusTitleArray = _publishCusTitleArray;
        publishCusBasicCell.publishCusDetailPageMsgEntity = _publishCusDetailEntity;
       
        return publishCusBasicCell;
    }
    
    return [[UITableViewCell alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 50.0;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
    [self hiddenLoadingView];
    if ([modelClass isEqual:[PublishCusDetailPageMsgEntity class]])
    {
        //公客详情
        _publishCusDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_mainTableView reloadData];
    }
    else if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        //公客转私客
        _isNowTransferPrivate = NO;
        AgencyBaseEntity *baseEntity = [DataConvert convertDic:data toEntity:modelClass];

        if (baseEntity.flag)
        {
            //转私客成功
            _isTransferPrivate = YES;
            [CustomAlertMessage showAlertMessage:@"已转为您的私客\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
        }
        else
        {
            //转私客失败
            [CustomAlertMessage showAlertMessage:baseEntity.errorMsg andButtomHeight:APP_SCREEN_HEIGHT/2];
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    
    if ([cls isEqual:[AgencyBaseEntity class]])
    {
        _isNowTransferPrivate = NO;
    }

}

@end
