//
//  PublishEstDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PublishEstDetailViewController.h"
#import "ArrowSignTextCell.h"
#import "PublishEstDetailPageMsgEntity.h"
#import "PublishEstDetailBasicMsgCell.h"
#import "ApplyTransferPubEstViewController.h"
#import "DataBaseOperation.h"
#import "PublishEstOrCustomerApi.h"
#import "NSDate+Format.h"


#define CheckHouseNoActionTag       1000

@interface PublishEstDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    PublishEstDetailPageMsgEntity *_publishEstDetailEntity;
    DataBaseOperation *_dataBaseOperation;
    NSString *_propTitleStr;                                        // 拼接房号
    
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_basicTitleArray;
    
    BOOL _isCheckedHouseNum;                                        // 是否已查看过房号
    BOOL _isAllHouseNum;                                            // 是否显示全部房号
    
}

@end

@implementation PublishEstDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"公盘详情"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"申请转盘"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(applyTransferPubEstMethod)]];
    
    [self initData];
}

#pragma mark - init

- (void)initData
{
    [self showLoadingView:nil];
    
    _basicTitleArray = [[NSMutableArray alloc]initWithObjects:
                        @"售       价：",
                        @"售  单  价：",
                        @"租       价：",
                        @"交易类型：",
                        @"房       型：",
                        @"建筑面积：",
                        @"实用面积：",
                        @"楼       层：",
                        @"朝       向：",
                        @"产权性质：",
                        @"产权日期：",
                        @"房屋现状：",
                        @"来       源：",nil];
    _isAllHouseNum = NO;
    // 检查是否查看过房号
    [self haveCheckedRoomNum];
    
    PublishEstOrCustomerApi *publishEstOrCustomerApi = [[PublishEstOrCustomerApi alloc] init];
    publishEstOrCustomerApi.requestType = GetPublishEstDetail;
    publishEstOrCustomerApi.keyId = _publishEstId;
    [_manager sendRequest:publishEstOrCustomerApi];
}

/**
 *  遍历已查看过房号的房源id，看当前房源是否查看过房号
 */
- (void)haveCheckedRoomNum
{
    if (_isAllHouseNum)
    {
        _isCheckedHouseNum = YES;
    }
    else
    {
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        NSString *curStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        NSMutableArray *checkedHouseNumList = [_dataBaseOperation selectAllKeyIdOfCheckedRoomNumWithStaffNo:curStaffNo
                                                                                                    andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        
        for (NSString *keyIdStr in checkedHouseNumList) {
            
            if ([keyIdStr isEqualToString:_publishEstId])
            {
                // 当前房源已查看过房号
                _isCheckedHouseNum = YES;
                break;
            }
        }
        
        if (checkedHouseNumList.count == 0 ||
            !_isCheckedHouseNum)
        {
            // 当前房源未查看过房号
            _isCheckedHouseNum = NO;
        }
    }
}

/// 申请转盘
- (void)applyTransferPubEstMethod
{
    BOOL isCancanTrun = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOWTURN_ADD];
    if(isCancanTrun)
    {
        ApplyTransferPubEstViewController *applyTransferPubEstVC = [[ApplyTransferPubEstViewController alloc]
                                                                    initWithNibName:@"ApplyTransferPubEstViewController"
                                                                    bundle:nil];
        applyTransferPubEstVC.propEstKeyId = _publishEstId;
        applyTransferPubEstVC.propertyStatus = _publishEstDetailEntity.propertyStatus;
        [self.navigationController pushViewController:applyTransferPubEstVC
                                             animated:YES];
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
    }
}

/// 转换日期格式：年-月-日
- (NSString *)transDataFormatWithDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:DateAndTimeFormat];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setTimeZone:timeZone];
    
    NSDate *formatDate = [formatter dateFromString:dateStr];
    
    [formatter setDateFormat:OnlyDateFormat];
    
    NSString *formatResultTime = [formatter stringFromDate:formatDate];
    
    return formatResultTime;
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_publishEstDetailEntity)
    {
        return 2;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return _basicTitleArray.count;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ArrowSignTextCellId = @"arrowSignTextCell";
    static NSString *BasicMsgCellId = @"publishEstDetailBasicMsgCell";
    
    ArrowSignTextCell *arrowSignTextCell = [tableView dequeueReusableCellWithIdentifier:ArrowSignTextCellId];
    PublishEstDetailBasicMsgCell *basicMsgCell = [tableView dequeueReusableCellWithIdentifier:BasicMsgCellId];
    
    if (indexPath.section == 0)
    {
        if (!arrowSignTextCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                  bundle:nil]
            forCellReuseIdentifier:ArrowSignTextCellId];
            arrowSignTextCell = [tableView dequeueReusableCellWithIdentifier:ArrowSignTextCellId];
        }
        
        if (_publishEstDetailEntity)
        {
            NSString *estTitleStr ;
            
            /**
             *  查看过房号后隐藏查看房号“按钮”
             */
            if (_isCheckedHouseNum)
            {
                arrowSignTextCell.rightArrowImageView.hidden = YES;
                arrowSignTextCell.rightTextLabel.text = @"";
                
                estTitleStr = [NSString stringWithFormat:@"%@%@%@",
                               _publishEstDetailEntity.estateName,
                               _publishEstDetailEntity.buildingName,
                               _publishEstDetailEntity.houseNo];
            }
            else
            {
                arrowSignTextCell.rightArrowImageView.hidden = NO;
                arrowSignTextCell.rightTextLabel.text = @"查看房号";
                
                estTitleStr = [NSString stringWithFormat:@"%@%@",
                               _publishEstDetailEntity.estateName,
                               _publishEstDetailEntity.buildingName];
            }
            arrowSignTextCell.leftTextLabel.text = estTitleStr;
        }
        
        return arrowSignTextCell;
    }
    else if (indexPath.section == 1)
    {
        if (!basicMsgCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PublishEstDetailBasicMsgCell"
                                                  bundle:nil]
            forCellReuseIdentifier:BasicMsgCellId];
            basicMsgCell = [tableView dequeueReusableCellWithIdentifier:BasicMsgCellId];
        }
        
        basicMsgCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
        
        if ([_publishEstDetailEntity.trustTypeName isEqualToString:@"出售"])
        {
            // 出售
            if (indexPath.row == 2)
            {
                basicMsgCell.hidden = YES;
            }
        }
        if ([_publishEstDetailEntity.trustTypeName  isEqualToString:@"出租"])
        {
            // 出租
            if (indexPath.row == 0 ||
                indexPath.row == 1)
            {
                basicMsgCell.hidden = YES;
            }
            
        }
        
        NSString *rightValueStr;
        
        basicMsgCell.leftTitleLabel.text = [_basicTitleArray objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0)
        {
            // 售价
            if (_publishEstDetailEntity.salePrice.intValue != 0)
            {
                // 售价超过“亿”，转换单位，数据是以“万”为单位
                NSString *propSalePriceResultStr;
                NSString *propSalePriceUnitStr;
                
                if (_publishEstDetailEntity.salePrice.floatValue >= 10000)
                {
                    propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                              _publishEstDetailEntity.salePrice.floatValue/10000];
                    propSalePriceUnitStr = @"亿";
                }
                else
                {
                    propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                              _publishEstDetailEntity.salePrice.floatValue];
                    propSalePriceUnitStr = @"万";
                }
                if ([propSalePriceResultStr rangeOfString:@".00"].location != NSNotFound)
                {
                    // 不是有效的数字，去除小数点后的0
                    propSalePriceResultStr = [propSalePriceResultStr
                                              substringToIndex:propSalePriceResultStr.length - 3];
                }
                
                rightValueStr = [NSString stringWithFormat:@"%@%@",
                                 propSalePriceResultStr,
                                 propSalePriceUnitStr];
                
                basicMsgCell.rightValueLabel.textColor = RED_COLOR;
            }
            
        }
        else if (indexPath.row == 1)
        {
            // 单价
            if (_publishEstDetailEntity.saleUnitPrice.intValue != 0)
            {
                rightValueStr = [NSString stringWithFormat:@"%d元/㎡",
                                 _publishEstDetailEntity.saleUnitPrice.intValue];
                
                basicMsgCell.rightValueLabel.textColor = RED_COLOR;
            }
        }
        else if (indexPath.row == 2)
        {
            // 租价
            rightValueStr = [NSString stringWithFormat:@"%g元/月",
                             [_publishEstDetailEntity.rentPrice floatValue]];
            
            basicMsgCell.rightValueLabel.textColor = GREEN_COLOR;
        }
        else if (indexPath.row == 3)
        {
            // 交易类型
            rightValueStr = _publishEstDetailEntity.trustTypeName;
        }
        else if (indexPath.row == 4)
        {
            // 房型
            rightValueStr = _publishEstDetailEntity.houseType;
        }
        else if (indexPath.row == 5)
        {
            // 建筑面积
            rightValueStr = [NSString stringWithFormat:@"%g㎡",
                             _publishEstDetailEntity.square.floatValue];
        }
        else if (indexPath.row == 6)
        {
            // 实用面积
            rightValueStr = [NSString stringWithFormat:@"%g㎡",
                             _publishEstDetailEntity.squareUse.floatValue];
        }
        else if (indexPath.row == 7)
        {
            // 楼层
            rightValueStr = [NSString stringWithFormat:@"%@层",
                             _publishEstDetailEntity.floor];
        }
        else if (indexPath.row == 8)
        {
            // 朝向
            rightValueStr = _publishEstDetailEntity.houseDirection;
        }
        else if (indexPath.row == 9)
        {
            // 产权性质
            rightValueStr = _publishEstDetailEntity.propertyRightNature;
        }
        else if (indexPath.row == 10)
        {
            // 产权日期
            rightValueStr = [self transDataFormatWithDateStr:
                             _publishEstDetailEntity.propertyCardDate];
        }
        else if (indexPath.row == 11)
        {
            // 房屋现状
            rightValueStr = _publishEstDetailEntity.propertySituation;
        }
        else if (indexPath.row == 12)
        {
            // 来源
            rightValueStr = _publishEstDetailEntity.propertySourceName;
        }
        
        basicMsgCell.rightValueLabel.text = rightValueStr;
        
        return basicMsgCell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // 查看房号
        [self clickCheckHouseNoMethod];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return 50.0;
    }
    else if (indexPath.section == 1)
    {
        if ([_publishEstDetailEntity.trustTypeName isEqualToString:@"出售"])
        {
            if (indexPath.row == 2)
            {
                return 0.0;
            }
        }
        
        if ([_publishEstDetailEntity.trustTypeName isEqualToString:@"出租"])
        {
            // 出租
            if (indexPath.row == 0 ||
                indexPath.row == 1)
            {
                return 0.0;
            }
        }
        
    }

    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 35;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *headerView = [[UIView alloc]init];
        [headerView setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 35)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *basicTitleLabel = [[UILabel alloc]init];
        basicTitleLabel.text = @"基本信息";
        [basicTitleLabel setBackgroundColor:[UIColor clearColor]];
        [basicTitleLabel setFont:[UIFont fontWithName:FontName
                                                 size:14.0]];
        [basicTitleLabel setTextColor:LITTLE_GRAY_COLOR];
        [basicTitleLabel setFrame:CGRectMake(15, 15, APP_SCREEN_WIDTH, 15)];
        
        [headerView addSubview:basicTitleLabel];
        
        return headerView;
    }
    
    return nil;
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

#pragma mark - <CheckRoomNoMethod>
/**
 *  查看房号
 */
- (void)clickCheckHouseNoMethod
{
    if (!_isCheckedHouseNum)
    {
        NSInteger checkHouseNoTimes = [CheckRoomNumUtil timesOfCheckNum];

        if (checkHouseNoTimes == 0)
        {
            showMsg(@"您今天浏览房号次数已用完！");
        }
        else
        {
            NSString *actionTitleStr = [NSString stringWithFormat:@"您今天剩余查看次数：%@，是否继续查看?",
                                        @(checkHouseNoTimes)];
            
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:actionTitleStr message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            av.tag = CheckHouseNoActionTag;
            
            [av show];
            
//            BYActionSheetView *checkHouseNoAction = [[BYActionSheetView alloc]initWithTitle:actionTitleStr
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"取消"
//                                                                          otherButtonTitles:@"确定", nil];
//            checkHouseNoAction.tag = CheckHouseNoActionTag;
//
//            [checkHouseNoAction show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == CheckHouseNoActionTag) {
        
        // 查看房号action
        if (buttonIndex == 1)
        {
            _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
            
            NSString *staffNo = [[NSUserDefaults standardUserDefaults] stringForKey:UserStaffNumber];
            
            // 保存到本地查看过的房号
            [_dataBaseOperation insertKeyIdOfCheckedRoomNum:_publishEstId
                                                 andStaffNo:staffNo
                                                    andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
            // 查看房号
            [CheckRoomNumUtil useCheckRoomNumLimit];
            
            _isCheckedHouseNum = YES;
            
            [_mainTableView reloadData];
        }
        
    }
    
}
//
//#pragma mark - <BYActionSheetDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//    if (alertView.tag == CheckHouseNoActionTag)
//    {
//        // 查看房号action
//        if (buttonIndex == 1)
//        {
//            _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
//
//            NSString *staffNo = [[NSUserDefaults standardUserDefaults] stringForKey:UserStaffNumber];
//
//            // 保存到本地查看过的房号
//            [_dataBaseOperation insertKeyIdOfCheckedRoomNum:_publishEstId
//                                                 andStaffNo:staffNo
//                                                    andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
//            // 查看房号
//            [CheckRoomNumUtil useCheckRoomNumLimit];
//
//            _isCheckedHouseNum = YES;
//
//            [_mainTableView reloadData];
//        }
//    }
//}

#pragma mark-<ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[PublishEstDetailPageMsgEntity class]])
    {
        [self hiddenLoadingView];
        _publishEstDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
    
        [_mainTableView reloadData];
    }
}

@end
