//
//  SellAndRentListDetailViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SellAndRentListDetailViewController.h"
#import "EstateReleaseDetailTitleTableViewCell.h"
#import "EstReleaseBasicInfoTableViewCell.h"
#import "EstReleaseDescribeTableViewCell.h"
#import "EstReleaseRentBasicInfoTableViewCell.h"
#import "EstReleaseDetailEntity.h"
#import "EstReleaseDetailImgEntity.h"
#import "EstReleaseDetailImgResultEntity.h"
#import "ReleaseEstListEntity.h"
#import "EstReleaseDetailPhotoViewController.h"
#import "CheckRealSurveyEntity.h"
#import "EstReleaseOnLineOrOffLineEntity.h"
#import "GetEstOnlineOrOfflineApi.h"
#import "GetEstDetailApi.h"

#define BASEIMG_TAG 10000

@interface SellAndRentListDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIScrollView *_mainScrollView;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UILabel *_postImgCountLabel;
    __weak IBOutlet NSLayoutConstraint *_bottomViewTopLabelHeight;

    GetEstOnlineOrOfflineApi *_getEstOnlineOrOfflineApi;//下架
    GetEstDetailApi *_getEstDetailApi;

    EstReleaseDetailEntity *_estDetailEntity;  //详情entity
    CheckRealSurveyEntity *_photoEntity;  //图片的entity

    NSMutableArray *_postImgArray;     //图片数组
    NSInteger _pageCount;               //第几张

}
@end

@implementation SellAndRentListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView.hidden = YES;
    [self initData];
    [self initNavTitleView];
    [self getDetail];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomViewTopLabelHeight.constant = 0.5;
}

- (void)initData
{
    _postImgArray = [NSMutableArray arrayWithCapacity:0];
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

#pragma mark - <获取详情>

- (void)getDetail
{
    [self showLoadingView:@""];
    _getEstDetailApi = [[GetEstDetailApi alloc] init];
    _getEstDetailApi.keyId = self.advertKeyid;
    [_manager sendRequest:_getEstDetailApi];
}

#pragma mark - <TableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_estDetailEntity.title)
        {
            CGFloat developerStrHeight;
            developerStrHeight = [_estDetailEntity.title getStringHeight:[UIFont fontWithName:FontName  size:15.0]  width:APP_SCREEN_WIDTH-20.0  size:15.0];
            if (developerStrHeight < 18)
            {
                developerStrHeight = 18;
            }
            return developerStrHeight + 52;

        }
        return 70;
    }
    else if (indexPath.section == 1)
    {
        return 126.0;

    }
    else
    {
        if (_estDetailEntity.infoDescription)
        {
            CGFloat hight = [_estDetailEntity.infoDescription getStringHeight:[UIFont fontWithName:FontName size:15.0]  width:APP_SCREEN_WIDTH-16.0  size:15.0];

            if (hight < 15.0)
            {
                return 15.0;
            }
            return hight + 16.0 + 50.0;

        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 10;
    }
    else if (section == 2)
    {
        return 40;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 50;
    }
    return 0.5;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        return view;
    }
    else
    {
        return nil;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, 200, 14)];
        label.text = @"房源描述";
        label.font = [UIFont fontWithName:FontName size:13.0];
        label.textColor = LITTLE_GRAY_COLOR;
        [view addSubview:label];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"titleCell";
    static NSString *basicCellIdentifier = @"basicCell";
    static NSString *rentBasicCellIdentifier = @"rentBasicCell";
    static NSString *describeCellIdentifier = @"describeCell";

    EstateReleaseDetailTitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    if (!titleCell) {

        [tableView registerNib:[UINib nibWithNibName:@"EstateReleaseDetailTitleTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:titleCellIdentifier];

        titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
    }

    EstReleaseBasicInfoTableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:basicCellIdentifier];
    if (!basicCell) {

        [tableView registerNib:[UINib nibWithNibName:@"EstReleaseBasicInfoTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:basicCellIdentifier];

        basicCell = [tableView dequeueReusableCellWithIdentifier:basicCellIdentifier];
    }
    
    EstReleaseRentBasicInfoTableViewCell *rentBasicCell=[tableView dequeueReusableCellWithIdentifier:rentBasicCellIdentifier];
    if (!rentBasicCell) {

        [tableView registerNib:[UINib nibWithNibName:@"EstReleaseRentBasicInfoTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:rentBasicCellIdentifier];

        rentBasicCell = [tableView dequeueReusableCellWithIdentifier:rentBasicCellIdentifier];
    }

    EstReleaseDescribeTableViewCell *describeCell = [tableView dequeueReusableCellWithIdentifier:describeCellIdentifier];
    if (!describeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"EstReleaseDescribeTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:describeCellIdentifier];

        describeCell = [tableView dequeueReusableCellWithIdentifier:describeCellIdentifier];
    }
    if (indexPath.section == 0)
    {
        NSString *propSalePriceResultStr;
        NSString *propSalePriceUnitStr;
        if (_estDetailEntity)
        {
             titleCell.titleLabel.text = _estDetailEntity.title;
            if (self.isSaleEst)
            {
                if (_estDetailEntity.sellPrice >= 10000)
                {
                    propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                              _estDetailEntity.sellPrice/10000];
                    propSalePriceUnitStr = @"亿元/套";
                }
                else
                {
                    propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                              _estDetailEntity.sellPrice];
                    propSalePriceUnitStr = @"万元/套";
                }
                if ([propSalePriceResultStr rangeOfString:@".00"].location != NSNotFound)
                {

                    //不是有效的数字，去除小数点后的0
                    propSalePriceResultStr = [propSalePriceResultStr
                                              substringToIndex:propSalePriceResultStr.length - 3];
                }


                titleCell.saleLabel.text = [NSString stringWithFormat:@"%@%@",propSalePriceResultStr,propSalePriceUnitStr];
                NSString * averageString =[NSString stringWithFormat:@"%.2f",_estDetailEntity.sellPrice * 10000 / _estDetailEntity.nArea];
                averageString = [averageString
                                 substringToIndex:averageString.length - 3];
                titleCell.averagePriceLabel.text = [NSString stringWithFormat:@"(%@元/平)",averageString];
            }
            else
            {
                 titleCell.saleLabel.text = [NSString stringWithFormat:@"%0.0f元/月",_estDetailEntity.rentalPrice];
                titleCell.averagePriceLabel.text = [NSString stringWithFormat:@"  (%@)",_estDetailEntity.payType?_estDetailEntity.payType:@"暂无"];
            }
        }

        return titleCell;
    }
    else if (indexPath.section == 1)
    {
        if (_isSaleEst)
        {
            basicCell.roomFormLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫",@(_estDetailEntity.roomCnt),@(_estDetailEntity.hallCnt),@(_estDetailEntity.toiletCnt)];
            basicCell.roomType.text = [NSString stringWithFormat:@"%@",_estDetailEntity.propertyType?_estDetailEntity.propertyType:@""];
            basicCell.fitmentLabel.text = [NSString stringWithFormat:@"%@",_estDetailEntity.fitment?_estDetailEntity.fitment:@""];
            basicCell.areaLabel.text = [NSString stringWithFormat:@"%g平米",_estDetailEntity.gArea?_estDetailEntity.gArea:_estDetailEntity.nArea];
            basicCell.confrontationLabel.text = [NSString stringWithFormat:@"%@",_estDetailEntity.direction?_estDetailEntity.direction:@""];
            basicCell.floorLabel.text = [NSString stringWithFormat:@"%@/%@层",@(_estDetailEntity.floor),@(_estDetailEntity.floorTotal)];
            basicCell.yearLabel.text = _estDetailEntity.opDate;
            basicCell.propertyLabel.text = [NSString stringWithFormat:@"%@",_estDetailEntity.propertyRight?_estDetailEntity.propertyRight:@""];
             return basicCell;
        }
        else
        {
            rentBasicCell.roomFormLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫",@(_estDetailEntity.roomCnt),@(_estDetailEntity.hallCnt),@(_estDetailEntity.toiletCnt)];
            rentBasicCell.roomType.text = [NSString stringWithFormat:@"%@",_estDetailEntity.propertyType?_estDetailEntity.propertyType:@""];
            rentBasicCell.fitmentLabel.text = [NSString stringWithFormat:@"%@",_estDetailEntity.fitment?_estDetailEntity.fitment:@""];
            rentBasicCell.areaLabel.text = [NSString stringWithFormat:@"%g平米",_estDetailEntity.gArea?_estDetailEntity.gArea:_estDetailEntity.nArea];
            rentBasicCell.confrontationLabel.text = [NSString stringWithFormat:@"%@",_estDetailEntity.direction?_estDetailEntity.direction:@""];
            rentBasicCell.floorLabel.text = [NSString stringWithFormat:@"%@/%@层",@(_estDetailEntity.floor),@(_estDetailEntity.floorTotal)];
            rentBasicCell.yearLabel.text = _estDetailEntity.opDate;
            rentBasicCell.sexTypeLabel.text = _estDetailEntity.rentType;
            rentBasicCell.rentTypeLabel.text = _estDetailEntity.rentTyep;
            return rentBasicCell;
        }

    }
    else
    {
        if (_estDetailEntity)
        {
            describeCell.estDescripeLabel.text = _estDetailEntity.infoDescription;
        }
        return describeCell;
    }
}

- (IBAction)estSetOffLine:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否下架该房源"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"否"
                                            otherButtonTitles:@"是", nil];
    [alertView show];
}

#pragma mark - <进入地图>
- (void)pushMapVC
{
    
}
#pragma mark - <加载封面图>
- (void)loadPostImgData
{
    _postImgCountLabel.text = [NSString stringWithFormat:@"1/%@",@(_postImgArray.count)];

    [_mainScrollView setContentSize:CGSizeMake(_mainScrollView.frame.size.width * [_postImgArray count],
                                              _mainScrollView.frame.size.height)];

    if (_postImgArray.count == 0)
    {
        _postImgCountLabel.text = @"0/0";

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              _mainScrollView.frame.size.width,
                                                                              _mainScrollView.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:@"estateCheapDefaultDetailImg.png"]];


        [_mainScrollView addSubview:imageView];
    }
    else
    {

        EstReleaseDetailImgResultEntity *firstPostImg = [_postImgArray objectAtIndex:0];

        for (int i = 0; i<_postImgArray.count; i++) {

            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*_mainScrollView.frame.size.width,
                                                                                  0,
                                                                                  _mainScrollView.frame.size.width,
                                                                                  _mainScrollView.frame.size.height)];
            imageView.tag = BASEIMG_TAG+i;
            imageView.userInteractionEnabled = YES;
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.clipsToBounds = YES;
            //点击查看相册
            UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCoverImageMethod:)];
            imageTapGesture.numberOfTouchesRequired = 1;
            imageTapGesture.numberOfTapsRequired = 1;

            [imageView addGestureRecognizer:imageTapGesture];

            if (i == 0) {
                
                [CommonMethod setImageWithImageView:imageView
                                        andImageUrl:firstPostImg.imgPath
                            andPlaceholderImageName:@"estateCheapDefaultDetailImg"];
            }else{
                [imageView setImage:[UIImage imageNamed:@"estateCheapDefaultDetailImg.png"]];
            }

            [_mainScrollView addSubview:imageView];
        }
    }

}

#pragma mark - <点击封面图>
- (void)clickCoverImageMethod:(UITapGestureRecognizer *)tapGesture
{
    EstReleaseDetailPhotoViewController * estReleasePhotoVC = [[EstReleaseDetailPhotoViewController alloc]initWithNibName:@"EstReleaseDetailPhotoViewController"   bundle:nil];
    estReleasePhotoVC.count=_pageCount;
    estReleasePhotoVC.imageArray=_postImgArray;
    [self.navigationController pushViewController:estReleasePhotoVC  animated:YES];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //房源下架
        [self showLoadingView:@""];
        _getEstOnlineOrOfflineApi = [[GetEstOnlineOrOfflineApi alloc] init];
        _getEstOnlineOrOfflineApi.getEstSetType = OffLine;
        _getEstOnlineOrOfflineApi.keyIds = @[self.advertKeyid];
        [_manager sendRequest:_getEstOnlineOrOfflineApi];
    }
}

#pragma mark - <ScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger curPage = scrollView.contentOffset.x/_mainScrollView.frame.size.width;
    _postImgCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(curPage+1),@(_postImgArray.count)];
    _pageCount=curPage;
    if (_postImgArray.count > 0) {

        UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:BASEIMG_TAG+curPage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        EstReleaseDetailImgResultEntity *imgDetail = [_postImgArray objectAtIndex:curPage];
        [CommonMethod setImageWithImageView:imageView
                                andImageUrl:imgDetail.imgPath
                    andPlaceholderImageName:@"estateCheapDefaultDetailImg"];
    }

}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    //下架
    if ([modelClass isEqual:[EstReleaseOnLineOrOffLineEntity class]])
    {
        EstReleaseOnLineOrOffLineEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        [self hiddenLoadingView];
        if (entity.operateResult.operateResult)
        {
            [CustomAlertMessage showAlertMessage:@"下架成功\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    if ([modelClass isEqual:[EstReleaseDetailEntity class]])
    {
        [self hiddenLoadingView];
        // 详情
        _mainTableView.hidden = NO;
        _estDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [_postImgArray addObjectsFromArray:_estDetailEntity.photos];
        [self loadPostImgData];
    }

    [_mainTableView reloadData];

}

@end
