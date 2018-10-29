//
//  WaitOnTheShelveViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "WaitOnTheShelveViewController.h"
#import "SunSegmentView.h"
#import "ReleaseEstManageApi.h"
#import "GetEstOnlineOrOfflineApi.h"
#import "GetEstAgentQuotaApi.h"
#import "SellAndRentTableViewCell.h"
#import "ReleaseEstListEntity.h"
#import "ReleaseEstListResultEntity.h"
#import "AgentQuotaEntity.h"
#import "EstReleaseOnLineOrOffLineEntity.h"



#define AlertViewTag    100000
@interface WaitOnTheShelveViewController ()<SunSegmentViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    
    SunSegmentView *_segmentView;
    ReleaseEstManageApi *_releaseEstManageApi;
    GetEstOnlineOrOfflineApi *_getEstOnlineOrOfflineApi;
    GetEstAgentQuotaApi *_getEstAgentQuotaApi;
    AgentQuotaEntity *_agentEntity;    //获取权限
    NSMutableArray *_dataSaleArray;
    NSMutableArray *_dataRentArray;

    NSInteger _saleStartIndex;  //出售点击页数
    NSInteger _rentStartIndex;  //出租点击页数
    NSInteger _allEstCount;     //经纪人可以上架套数
    NSInteger _currentIndex;    //默认点击出售或者出租
    NSString *_estType;    //出租或者出售
}
@end

@implementation WaitOnTheShelveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _saleStartIndex = 1;
    _rentStartIndex = 1;
    [self initArray];
    [self initSegment];
    [self initNavTitleView];
    [self createRefreshViewMethod];
    _mainTableView.rowHeight = 81.0;
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
    [self SunSegmentClick:0];
    [self getAgentQuota];
}

- (void)initArray
{
    _dataSaleArray = [NSMutableArray arrayWithCapacity:0];
    _dataRentArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)initNavTitleView
{
    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    self.navigationItem.titleView = _segmentView;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSegment
{
    _segmentView = [[SunSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, 30)
                                                            withViewCount:2
                                                          withNormalColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:0]
                                                          withSelectColor:[UIColor whiteColor]
                                                     withNormalTitleColor:[UIColor whiteColor ]
                                                     withSelectTitleColor:[UIColor colorWithRed:214.0/255.0 green:24.0/255.0 blue:37.0/255.0 alpha:1.0]];
    _segmentView.titleFont = [UIFont fontWithName:@"Helvetica"
                                              size:15.0];
    _segmentView.titleArray = @[@"出售",@"出租"];

    _segmentView.backgroundColor = [UIColor clearColor];
    _segmentView.titleFont = [UIFont boldSystemFontOfSize:15.0];
    [_segmentView.layer setMasksToBounds:YES];
    _segmentView.layer.borderWidth = 1.0;
    _segmentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentView.layer.cornerRadius = 5.0;
    _segmentView.segmentDelegate = self;
    _segmentView.selectIndex = _currentIndex;
}

#pragma  mark - <SunsegmentDelegate>
- (void)SunSegmentClick:(NSInteger)index;
{
    _currentIndex = index;
    [self headerRefreshMethod];
}

#pragma mark - <MJRefreshDelegate>
- (void)createRefreshViewMethod
{
//    [_mainTableView addHeaderWithTarget:self
//                                 action:@selector(headerRefreshMethod)];
//    [_mainTableView addFooterWithTarget:self
//                                 action:@selector(footerRefreshMethod)];

    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
}

- (void)headerRefreshMethod
{
    if ([_estType isEqualToString:@"S"])
    {
        _saleStartIndex = 1;
    }
    else
    {
        _rentStartIndex = 1;
    }
    [self getEstReleaseManageWithStartIndex:1];
}

- (void)footerRefreshMethod
{
    if ([_estType isEqualToString:@"S"])
    {
        _saleStartIndex++;
        [self getEstReleaseManageWithStartIndex:_saleStartIndex];
    }
    else
    {
        _rentStartIndex++;
        [self getEstReleaseManageWithStartIndex:_rentStartIndex];
    }

}

#pragma mark - <获取列表数据>
- (void)getEstReleaseManageWithStartIndex:(NSInteger)count
{

    [self showLoadingView:@""];
    if (_currentIndex == 0)
    {
        _estType=@"S";
    }
    else
    {
        _estType=@"R";
    }
    if (count == 1)
    {
        if ([_estType isEqualToString:@"S"])
        {
            [_dataSaleArray removeAllObjects];
        }
        else
        {
            [_dataRentArray removeAllObjects];
        }

    }

    NSString * staffNo=[[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    _releaseEstManageApi = [[ReleaseEstManageApi alloc] init];
    _releaseEstManageApi.ReleaseEstManageType = ReleaseEstManage;
    _releaseEstManageApi.ReleaseEstManageType = ReleaseEstManage;//放盘管理
    _releaseEstManageApi.staffno = staffNo;
    _releaseEstManageApi.pageindex = [NSString stringWithFormat:@"%@",@(count)];
    _releaseEstManageApi.posttype = _estType;
    _releaseEstManageApi.poststatus = @"offline";
    [_manager sendRequest:_releaseEstManageApi];

}

#pragma mark - <获取业务员配额>
- (void)getAgentQuota
{
    _getEstAgentQuotaApi = [[GetEstAgentQuotaApi alloc] init];
    [_manager sendRequest:_getEstAgentQuotaApi];
}

#pragma mark - <TableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_estType isEqualToString:@"S"])
    {
        return _dataSaleArray.count;
    }
    else
    {
        return _dataRentArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"SellAndRentCell";
    SellAndRentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SellAndRentTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    }
    
    cell.chooseButton.hidden = YES;
    cell.residualTimeLabel.hidden = YES;
    cell.reloadTimeLabel.hidden = YES;
    ReleaseEstListResultEntity *entity;
    if ([_estType isEqualToString:@"S"])
    {
        if (_dataSaleArray.count != 0)
        {
            entity = _dataSaleArray[indexPath.row];
        }
    }
    else
    {
        if (_dataRentArray.count != 0)
        {
            entity = _dataRentArray[indexPath.row];
        }
    }
    cell.estateNameLabel.text =entity.displayEstName;
    cell.estateAddressLabel.text = entity.displayAddress;
    /**
     *  售价超过“亿”，转换单位，数据是以“万”为单位
     *
     */

    if ([_estType isEqualToString:@"S"])
    {
        NSString *propSalePriceResultStr ;
        NSString *propSalePriceUnitStr;

        if (entity.sellPrice >= 10000) {

            propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      entity.sellPrice/10000];
            propSalePriceUnitStr = @"亿";
        }else{

            propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                      entity.sellPrice];
            propSalePriceUnitStr = @"万";
        }
        if ([propSalePriceResultStr rangeOfString:@".00"].location != NSNotFound) {

            //不是有效的数字，去除小数点后的0
            propSalePriceResultStr = [propSalePriceResultStr
                                      substringToIndex:propSalePriceResultStr.length - 3];
        }

        cell.estateInfoLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫 %g平米 %@%@",@(entity.roomCnt),@(entity.hallCnt ),@(entity.toiletCnt),entity.gArea?entity.gArea:entity.nArea,propSalePriceResultStr,propSalePriceUnitStr];
    }
    else
    {
        cell.estateInfoLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫 %g平米 %@元/月",@(entity.roomCnt),@(entity.hallCnt ),@(entity.toiletCnt),entity.gArea?entity.gArea:entity.nArea,@(entity.rentalPrice)];
    }
    
    [CommonMethod setImageWithImageView:cell.headerImg
                            andImageUrl:entity.defaultImage
                andPlaceholderImageName:@"defaultEstateBg_img"];
    cell.reloadTimeLabel.text=[CommonMethod dateFormat:[entity.updateTime doubleValue]/1000];
    cell.residualTimeLabel.text=[self dateFormat:[entity.expiredTime doubleValue]];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReleaseEstListResultEntity *entity;
    if([_estType isEqualToString:@"S"])
    {
        entity = _dataSaleArray[indexPath.row];
    }else{
        entity = _dataRentArray[indexPath.row];
    }
    
    
    if(entity.trustType != BOTH && entity.tradeType != entity.trustType)
    {
        showMsg(@"上架广告中有和房源交易类型不一致的房源，无法上架！");
        return;
    }
    
    
    if (_allEstCount > 0)
    {
        NSString *message = [NSString stringWithFormat:@"您还可以放盘%@套,是否上架",@(_allEstCount)];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:message
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"否"
                                                otherButtonTitles:@"是", nil];
        alertView.tag = indexPath.row+AlertViewTag;
        [alertView show];
    }
    else
    {
        [CustomAlertMessage showAlertMessage:@"您的放盘数量已满\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
    }

    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
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

#pragma  mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ReleaseEstListResultEntity * entity;
    if ([_estType isEqualToString:@"S"])
    {
        entity = _dataSaleArray[alertView.tag - AlertViewTag];
    }
    else
    {
        entity = _dataRentArray[alertView.tag - AlertViewTag];
    }
    if (buttonIndex == 1)
    {

        if (entity.propertyStatus)
        {
            if (!_agentEntity.admPermission)
            {
                [CustomAlertMessage showAlertMessage:@"无上架广告权限\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            else
            {
                _getEstOnlineOrOfflineApi = [[GetEstOnlineOrOfflineApi alloc] init];
                _getEstOnlineOrOfflineApi.getEstSetType = OnLine;
                _getEstOnlineOrOfflineApi.keyIds = @[entity.advertKeyid];
                [_manager sendRequest:_getEstOnlineOrOfflineApi];
            }
        }
        else
        {
            [CustomAlertMessage showAlertMessage:@"该房源为无效房源\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
        }

    }
}
#pragma mark - <customMethod>
- (NSString *)getHeaderImgUrlWith:(NSString*)string
{

    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:CityCode];
    NSInteger code = [city integerValue];
    NSString *cityString;
    switch (code) {
        case 10:
            cityString = @"beijing";
            break;
        case 28:
            cityString = @"chengdu";
            break;
        case 22:
            cityString = @"tianjin";
            break;
        case 23:
            cityString = @"chongqing";
            break;
        case 755:
            cityString = @"shenzhen";
            break;
        default:
            break;
    }
    NSString * headerImgUrl = [NSString stringWithFormat:@"http://pic.centanet.com/%@/postimage/%@_126x126.jpg",cityString,string];
    return headerImgUrl;

}

- (NSString*)dateFormat:(CGFloat)timeOld
{
    CGFloat timeTag = [[NSDate date] timeIntervalSince1970];
    CGFloat timebase = timeOld - (timeTag * 1000) ;
    CGFloat day = timebase / (60 * 60 * 24 * 1000);

    NSInteger time = [[NSString stringWithFormat:@"%@",@(day)] integerValue];
    NSString *dayString = [[[NSString stringWithFormat:@"%@",@(day)] componentsSeparatedByString:@"."]lastObject];
    if ([dayString integerValue] == 0)
    {
        return [NSString stringWithFormat:@"剩余%@天",@(time)];
    }
    else
    {
        return [NSString stringWithFormat:@"剩余%@天",@(time + 1)];
    }
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    
    [self endRefreshWithTableView:_mainTableView];
    
    if ([modelClass isEqual:[ReleaseEstListEntity class]]) {
        {
            [self hiddenLoadingView];
            ReleaseEstListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
            if (entity.advertPropertys.count != 0)
            {

                [self hiddenLoadingView];

                if ([_estType isEqualToString:@"S"])
                {
                    [_dataSaleArray addObjectsFromArray:entity.advertPropertys];
                    if (_dataSaleArray.count == entity.recordCount)
                    {
//                        _mainTableView.footerHidden = YES;
                        _mainTableView.mj_footer.hidden = YES;
                    }
                    else
                    {
//                        _mainTableView.footerHidden = NO;
                        _mainTableView.mj_footer.hidden = NO;
                    }

                }
                else
                {
                    [_dataRentArray addObjectsFromArray:entity.advertPropertys];
                    if (_dataRentArray.count == entity.recordCount)
                    {
//                        _mainTableView.footerHidden = YES;
                        _mainTableView.mj_footer.hidden = YES;
                    }
                    else
                    {
//                        _mainTableView.footerHidden = NO;
                        _mainTableView.mj_footer.hidden = NO;
                    }
                }

                [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                    andOnView:_mainTableView
                                      andShow:NO];
            }
            else
            {
                
                [self noResultImageWithHeight:APP_SCREEN_HEIGHT/2
                                    andOnView:_mainTableView
                                      andShow:YES];
            }
        }
    }

    //上架
    if ([modelClass isEqual:[EstReleaseOnLineOrOffLineEntity class]])
    {
        [self hiddenLoadingView];
        [CustomAlertMessage showAlertMessage:@"上架成功\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT/2];
        _allEstCount -= 1;
        [self headerRefreshMethod];
    }

    //获取经纪人配套数
    if ([modelClass isEqual:[AgentQuotaEntity class]])
    {
        _agentEntity = [DataConvert convertDic:data toEntity:modelClass];
        _allEstCount = _agentEntity.countPropertyAd;
    }


    [_mainTableView reloadData];





}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    
    [super respFail:error andRespClass:cls];
    
    [self endRefreshWithTableView:_mainTableView];
    if ([_estType isEqualToString:@"S"])
    {
        if (_dataSaleArray.count == 0)
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
    else
    {
        if (_dataRentArray.count == 0)
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


}


@end
