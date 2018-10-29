//
//  SellAndRentViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SellAndRentViewController.h"

#import "ReleaseEstListEntity.h"
#import "ReleaseEstListResultEntity.h"
#import "SellAndRentTableViewCell.h"
#import "SellAndRentListDetailViewController.h"
#import "EstReleaseOnLineOrOffLineEntity.h"
#import "ReleaseEstManageApi.h"
#import "GetEstOnlineOrOfflineApi.h"

@interface SellAndRentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSInteger _startIndex;
    
    ReleaseEstManageApi *_releaseEstManageApi;
    GetEstOnlineOrOfflineApi *_getEstOnlineOrOfflineApi;

    UIImageView *_rightImg;    //导航右侧Img
    UILabel *_rightLabel;      //导航右侧label
    
    NSMutableArray *_dataArray;
    NSString *_staffNo;   //经纪人编号
}
@end

@implementation SellAndRentViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self initArray];
    [self initNavTitleView];
    [self createRefreshViewMethod];

    _mainTableView.tableFooterView = [[UIView alloc]init];
    _staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self headerRefreshMethod];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)initArray
{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)initNavTitleView
{
    [self setNavTitle:self.titleString
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
    _startIndex = 1;
    [self getEstReleaseManageWithStartIndex:_startIndex];
}

- (void)footerRefreshMethod
{
    _startIndex ++;
    [self getEstReleaseManageWithStartIndex:_startIndex];
}

- (void)getEstReleaseManageWithStartIndex:(NSInteger)count
{
    [self showLoadingView:@""];
    if (count == 1)
    {
        [_dataArray removeAllObjects];
    }
    NSString *estType;
    if (_isSellEstate)
    {
        estType=@"S";
    }
    else
    {
        estType=@"R";
    }

    _releaseEstManageApi = [[ReleaseEstManageApi alloc] init];
    _releaseEstManageApi.ReleaseEstManageType = ReleaseEstManage;//放盘管理
    _releaseEstManageApi.staffno = _staffNo;
    _releaseEstManageApi.pageindex = [NSString stringWithFormat:@"%@",@(count)];
    _releaseEstManageApi.posttype = estType;
    _releaseEstManageApi.poststatus = @"online";
    [_manager sendRequest:_releaseEstManageApi];
}

#pragma mark - <下架>
- (void)estSetOffLineWithPostId:(NSString*)postId
{
    _getEstOnlineOrOfflineApi = [[GetEstOnlineOrOfflineApi alloc] init];
    _getEstOnlineOrOfflineApi.getEstSetType = OffLine;
    _getEstOnlineOrOfflineApi.keyIds = @[postId];
    [_manager sendRequest:_getEstOnlineOrOfflineApi];
}


#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"SellAndRentCell";
    SellAndRentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SellAndRentTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    }
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];

    longPressed.minimumPressDuration = 1;
    cell.contentView.tag=indexPath.row;
    [cell.contentView addGestureRecognizer:longPressed];
    if (_dataArray.count != 0)
    {
        ReleaseEstListResultEntity *entity = _dataArray[indexPath.row];
        cell.estateNameLabel.text = entity.displayEstName;
        cell.estateAddressLabel.text = entity.displayAddress;
        /**
         *  售价超过“亿”，转换单位，数据是以“万”为单位
         *
         */

        if (self.isSellEstate)
        {
            NSString *propSalePriceResultStr ;
            NSString *propSalePriceUnitStr;
            if (entity.sellPrice >= 10000) {

                propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                          entity.sellPrice/10000];
                propSalePriceUnitStr = @"亿";
            }
            else
            {
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
        cell.reloadTimeLabel.text = [CommonMethod dateFormat:[entity.updateTime doubleValue]/1000];
        cell.residualTimeLabel.text = [self dateFormat:[entity.expiredTime doubleValue]];
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    ReleaseEstListResultEntity *entity = _dataArray[indexPath.row];

    SellAndRentListDetailViewController *estReleaseDetailVC = [[SellAndRentListDetailViewController alloc]initWithNibName:@"SellAndRentListDetailViewController"     bundle:nil];
    estReleaseDetailVC.titleString = entity.displayEstName;
    estReleaseDetailVC.advertKeyid = entity.advertKeyid;
    estReleaseDetailVC.postId = entity.postId;
    estReleaseDetailVC.isSaleEst = self.isSellEstate;
    [self.navigationController pushViewController:estReleaseDetailVC animated:YES];
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

- (void)longPressedAct:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        //下架
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下架", nil];
        
        av.tag = gesture.view.tag;
        
        [av show];
        
//        //下架
//        BYActionSheetView *actionSheetView = [[BYActionSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下架",  nil];
//        actionSheetView.tag = gesture.view.tag;
//        [actionSheetView show];
//        return;

    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    ReleaseEstListResultEntity *entity = _dataArray[alertView.tag];
    
    [self estSetOffLineWithPostId:entity.advertKeyid];
}


#pragma mark - <确认刷新>
- (void)commitReload:(UIButton *)sender {

}

- (CGFloat)getTimeWith:(NSString *)timeString
{
    NSString *dateString = [[[[timeString componentsSeparatedByString:@"("] lastObject]componentsSeparatedByString:@")"] firstObject];
    CGFloat date = [dateString doubleValue];
    return date;
}

- (NSString *)dateFormat:(CGFloat)timeOld
{
    CGFloat timeTag = [[NSDate date] timeIntervalSince1970];
    CGFloat timebase = (timeOld/1000) - timeTag ;
    CGFloat day = timebase/(60*60*24);

    NSInteger time = [[NSString stringWithFormat:@"%@",@(day)] integerValue];
    if (time <= 0)
    {
         return @"剩余0天";
    }
    return [NSString stringWithFormat:@"剩余%@天",@(time)];
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self endRefreshWithTableView:_mainTableView];
    [self hiddenLoadingView];
    if ([modelClass isEqual:[ReleaseEstListEntity class]])
    {
        ReleaseEstListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
       
        if (entity.advertPropertys.count != 0)
        {

            [_dataArray addObjectsFromArray:entity.advertPropertys];

            if (_dataArray.count == entity.recordCount)
            {
//                _mainTableView.footerHidden = YES;
                _mainTableView.mj_footer.hidden = YES;
            }
            else
            {
//                _mainTableView.footerHidden = NO;
                _mainTableView.mj_footer.hidden = NO;
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


    //下架
    if ([modelClass isEqual:[EstReleaseOnLineOrOffLineEntity class]])
    {
        EstReleaseOnLineOrOffLineEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.operateResult.operateResult)
        {
            [CustomAlertMessage showAlertMessage:@"下架成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            [self showLoadingView:@""];
            [self headerRefreshMethod];
        }
    }




    [_mainTableView reloadData];


}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
    [self hiddenLoadingView];
    if (_dataArray.count == 0)
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

@end
