//
//  CheckRealSurveyViewController.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CheckRealSurveyViewController.h"
#import "CheckRealSurveyEntity.h"
#import "PhotoEntity.h"
#import "ApprovalRecordViewController.h"
#import "PhotoDownLoadImageViewController.h"
#import "RealSurveyOperationEntity.h"
#import "RealSurveyOperationApi.h"
#import "CheckRealSurveyApi.h"
#import "RealSurveyStatusEnum.h"

#import "CheckRealSurveyBasePresenter.h"


#import "CheckRealSurveyViewProtocol.h"


#define Single_height 20            // 单行文字高度
#define Double_LineHeight 40        // 两行文字高度
#define PassAlertView_Tag 111       // 通过弹框tag
#define RefusedAlertView_Tag 222    // 拒绝弹框tag

@interface CheckRealSurveyViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,
UIAlertViewDelegate,CheckRealSurveyViewProtocol>{

    UITableView *_maintableView;
    UICollectionView *_collectionView;
    UILabel *_decorationSituationLabel;

    __weak IBOutlet UIButton *_refuseButton;
    __weak IBOutlet UIButton *_passAction;
    
    UIView *_headerView;
    IBOutlet UIView *_footerView;

    CGFloat _headerHeight;          // 头视图高度
    CGFloat _footHeight;            // 尾视图高度

    NSString *_allTextStr;          // 全文内容
    NSString *_decorationSituation; //装修情况

    CheckRealSurveyEntity *_checkRealSurveyEntity;
    
    CheckRealSurveyBasePresenter *_checkRealSurveyPresenter;
}
@end

@implementation CheckRealSurveyViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 加载数据
    [self loadData];
    
    [self initPresenter];
    [self initView];
}

#pragma mark - init

- (void)initView
{
    // 导航栏UI
    [self setNavTitle:@"查看实勘"
       leftButtonItem:[self customBarItemButton:nil 
                                backgroundImage:nil 
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    NSInteger status = self.realSurveyStatus;
    
    _footHeight = 80;
    _footerView.hidden = NO;
   
    if (status == APPROVED || status == REJECT ||  // 通过/拒绝
        [_realSurveyAuditingEntity.auditStatus integerValue] == UNSUBMIT || // 状态为"待提交"
        [_checkRealSurveyPresenter needHidePushButtonOrRefuseButton:_realSurveyAuditingEntity andListEntity:_listEntity]) // 根据权限判断是否需要隐藏
        
    {
        _footHeight = 0;
        _footerView.hidden = YES;
    }
    
    // 表视图
    _maintableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, APP_SCREEN_WIDTH - 20, APP_SCREEN_HEIGHT - 64 - _footHeight)
                                                  style:UITableViewStylePlain];
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.scrollEnabled = NO;
    _maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_maintableView];
    
    // 头视图
    _decorationSituationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
    _decorationSituationLabel.text = @"装修情况:";
    _decorationSituationLabel.tag = 2014;
    _decorationSituationLabel.textColor = rgba(155, 155, 155, 1.0);
    _decorationSituationLabel.font = [UIFont fontWithName:FontName size:16.0];
  
    // 设置装修情况字段显示情况
    [_checkRealSurveyPresenter setDecorationSituationDisplaySituation];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _decorationSituationLabel.bottom + 5, 100, 20)];
    label1.text = @"实勘点评:";
    label1.textColor = rgba(155, 155, 155, 1.0);
    label1.font = [UIFont fontWithName:FontName size:16.0];
    
    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(0,label1.bottom + 5 , APP_SCREEN_WIDTH - 20, Single_height)];
    textLable.tag = 2016;
    textLable.font = [UIFont fontWithName:FontName size:14.0];

    // 全文按钮
    UIButton *allTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allTextBtn.tag = 2015;
    allTextBtn.frame = CGRectMake(0, textLable.bottom + 5, 50, 15);
    [allTextBtn setTitle:@"全文" forState:UIControlStateNormal];
    allTextBtn.titleLabel.font = [UIFont fontWithName:FontName size:14.0];
    allTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [allTextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    allTextBtn.selected = NO;
    allTextBtn.hidden = YES;
    [allTextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _headerHeight = label1.height + textLable.height + 15 + _decorationSituationLabel.height + 10;
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH - 20, _headerHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_decorationSituationLabel]; // 装修情况
    [_headerView addSubview:label1];
    [_headerView addSubview:textLable];
    [_headerView addSubview:allTextBtn];
    _maintableView.tableHeaderView = _headerView;
    
    // 尾视图
    _footerView.frame = CGRectMake(0,APP_SCREEN_HEIGHT - 64 - _footHeight, APP_SCREEN_WIDTH, _footHeight);
    _footerView.backgroundColor = [UIColor clearColor];
    UIButton *btn1 = [_footerView viewWithTag:101];
    UIButton *btn2 = [_footerView viewWithTag:102];
    btn1.layer.cornerRadius = 5;
    btn1.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 5;
    btn2.layer.masksToBounds = YES;
    [self.view addSubview:_footerView];

}

- (void)initPresenter
{
   
        _checkRealSurveyPresenter = [[CheckRealSurveyBasePresenter alloc] initWithDelegate:self];
    
}

#pragma mark - <CheckRealSurveyViewProtocol>

- (void)controlDecorationSituationDisplaySituation
{
    if (![_checkRealSurveyPresenter haveDecorationSituationFunction]) {
        _decorationSituationLabel.hidden = YES;
        _decorationSituationLabel.height = 0;
    }
}

#pragma mark-点击全文展开或收起
- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    UILabel *textLabel = [_headerView viewWithTag:2016];
    if (btn.selected) {
        //展开全文
        textLabel.numberOfLines = 0;
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        CGFloat height = [self heightForString:_allTextStr fontSize:14.0 andWidth:APP_SCREEN_WIDTH - 20];
        [self sizeOfHeaderWithHeight:height];
    }else{
        //收起
        textLabel.numberOfLines = 2;
        [btn setTitle:@"全文" forState:UIControlStateNormal];
        [self sizeOfHeaderWithHeight:40];
    }
}

#pragma mark - 头视图高度变化
- (void)sizeOfHeaderWithHeight:(CGFloat)height{
    UILabel *textLabel = [_headerView viewWithTag:2016];
    textLabel.height = height;
    textLabel.text = _allTextStr;
    
    // 装修情况
    UILabel *renovationLabel = [_headerView viewWithTag:2014];
    renovationLabel.text = [NSString stringWithFormat:@"装修情况:%@",_decorationSituation];
    // 设置装修情况字段显示情况
    [_checkRealSurveyPresenter setDecorationSituationDisplaySituation];

    _headerHeight = height + 35 + 15 + renovationLabel.height + 10;
    _headerView.height = _headerHeight;
    _maintableView.tableHeaderView = _headerView;

    UIButton *btn = [_headerView viewWithTag:2015];
    btn.top = textLabel.bottom + 5;
    _maintableView.rowHeight = APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight;
    _collectionView.height = APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight;
}


#pragma mark - 根据文字个数获取高度
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width  
{  
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置  
    return sizeToFit.height;  
}  

#pragma mark - 通过
- (IBAction)passAction:(UIButton *)sender {
    
    NSString *errorMsg = [_checkRealSurveyPresenter passRealSurveyAuditPerScope:_realSurveyAuditingEntity andListEntity:_listEntity];
   
    if (![NSString isNilOrEmpty:errorMsg]) {
        showMsg(errorMsg);
    }
}

#pragma mark - 拒绝
- (IBAction)refusedAction:(UIButton *)sender
{
   
    NSString *errorMsg = [_checkRealSurveyPresenter refusedRealSurveyAuditPerScope:_realSurveyAuditingEntity
                                                andListEntity:_listEntity];
    if (![NSString isNilOrEmpty:errorMsg]) {
        showMsg(errorMsg);
    }
}



#pragma mark - CheckRealSurveyViewProtocol
/// 通过提示框
- (void)passAlert
{
    UIAlertView *passAlertView = [[UIAlertView alloc] initWithTitle:@"您确定要进行该实勘操作吗？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
    passAlertView.tag = PassAlertView_Tag;
    [passAlertView show];

}

/// 拒绝提示框
- (void)refusedAlert
{
    if ([_checkRealSurveyPresenter needRefusedReason]) {
        //深圳----需要拒绝理由
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拒绝理由"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"拒绝理由";
            
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //取出textFiled的值
            NSArray *testArr = [alertController textFields];
            UITextField *textField = [testArr lastObject];
            //拒绝理由
            NSString *textFieldTextStr = textField.text;
            NSLog(@"%@",textFieldTextStr);
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

    }
    else
    {
        UIAlertView *refusedAlertView = [[UIAlertView alloc] initWithTitle:@"您确定要进行该实勘操作吗？"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
        refusedAlertView.tag = RefusedAlertView_Tag;
        [refusedAlertView show];

    }
}



#pragma mark - 网络请求数据
- (void)loadData{
    CheckRealSurveyApi *checkRealSurveyApi = [[CheckRealSurveyApi alloc] init];
    checkRealSurveyApi.keyId = self.keyId;
    [_manager sendRequest:checkRealSurveyApi];
    
    [self showLoadingView:nil];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == PassAlertView_Tag) {
        if (buttonIndex == 1) {
            //通过---确定
            RealSurveyOperationApi *realSurveyOperationApi = [[RealSurveyOperationApi alloc] init];
            realSurveyOperationApi.auditStatus = @"1";
            realSurveyOperationApi.keyId = self.keyId;
            [_manager sendRequest:realSurveyOperationApi];
        }
    }else if (alertView.tag == RefusedAlertView_Tag){
        if (buttonIndex == 1) {
            //拒绝---确定
            RealSurveyOperationApi *realSurveyOperationApi = [[RealSurveyOperationApi alloc] init];
            realSurveyOperationApi.auditStatus = @"-1";
            realSurveyOperationApi.keyId = self.keyId;
            [_manager sendRequest:realSurveyOperationApi];
        }
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]; 
    _collectionView = (UICollectionView *)[cell.contentView viewWithTag:123];
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.itemSize = CGSizeMake((APP_SCREEN_WIDTH - 30) / 3, 100);
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.tag = 123;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
        [cell.contentView addSubview:_collectionView];
    }

    _collectionView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH - 20, APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight);
    return cell;
}


- (void)back
{
    [NSThread sleepForTimeInterval:0.3];
    [self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark - <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *photosArr = _checkRealSurveyEntity.photos;
    return photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (APP_SCREEN_WIDTH - 30) / 3, 100)];
    imgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *panoramaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    panoramaLabel.font = [UIFont systemFontOfSize:14];
    panoramaLabel.text = @"全景图";
    panoramaLabel.center = imgView.center;
    panoramaLabel.textAlignment = NSTextAlignmentCenter;
    panoramaLabel.hidden = YES;
    panoramaLabel.textColor = [UIColor whiteColor];
    panoramaLabel.alpha = 0.8;
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.height - 20, imgView.width, 20)];
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.text = @"";
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.alpha = 0.8;


    if (_checkRealSurveyEntity != nil) {
        NSArray *photosArr = _checkRealSurveyEntity.photos;
        PhotoEntity *photoEntity = photosArr[indexPath.item];
        NSString *newImgStr = [NSString stringWithFormat:@"%@%@&watermark=smallgroup_center",photoEntity.imgPath,AllRoundListPhotoWidth];
        [imgView sd_setImageWithURL:[NSURL URLWithString:newImgStr]];
        
        // 是否含有全景功能
        if ([_checkRealSurveyPresenter havePanoramaFunction])
        {
            if ([photoEntity.isPanorama boolValue]) {
                panoramaLabel.hidden = NO;
            }
        }
        
        // 是否显示图片类型
        if ([_checkRealSurveyPresenter havePhotoType])
        {
            typeLabel.text = photoEntity.photoType;
            [imgView addSubview:typeLabel];
        }

    }
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:panoramaLabel];

    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDownLoadImageViewController *photoDownImageVC = [[PhotoDownLoadImageViewController alloc]initWithNibName:@"PhotoDownLoadImageViewController" bundle:nil];
    photoDownImageVC.propKeyId = self.keyId;
    photoDownImageVC.isItem = YES;
    photoDownImageVC.curImageindex = indexPath.row;
    [self.navigationController pushViewController:photoDownImageVC animated:YES];
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    if ([modelClass isEqual:[CheckRealSurveyEntity class]])
    {
        _checkRealSurveyEntity = [DataConvert convertDic:data toEntity:modelClass];
        NSLog(@"%@",_checkRealSurveyEntity);
        [_collectionView reloadData];

        UIButton *btn = [_headerView viewWithTag:2015];
        _allTextStr = _checkRealSurveyEntity.realSurveyComment;
        
        _decorationSituation = _checkRealSurveyEntity.decorationSituation ? _checkRealSurveyEntity.decorationSituation:@"";
        _decorationSituationLabel.text = [NSString stringWithFormat:@"装修情况 : %@",_decorationSituation];
        
        UILabel *textLabel = [_headerView viewWithTag:2016];

        CGFloat totalHeight = [self heightForString:_allTextStr fontSize:14.0 andWidth:APP_SCREEN_WIDTH - 20];
        if (totalHeight < Double_LineHeight) {
            // 一行或两行
            [btn removeFromSuperview];
            textLabel.text = _allTextStr;
            if (totalHeight > Single_height) {
                // 两行
                textLabel.numberOfLines = 2;
                textLabel.height = 40;
                _headerHeight = 70 + 10;
                _headerView.height = _headerHeight;
                _maintableView.rowHeight = APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight;
                _collectionView.height = APP_SCREEN_HEIGHT - 64 - _footHeight - _headerHeight;
            }
        }
        else
        {
            // 多行
            btn.hidden = NO;
            CGFloat height;
            if (btn.selected) {
                textLabel.numberOfLines = 0;
                height = [self heightForString:_allTextStr fontSize:14.0 andWidth:APP_SCREEN_WIDTH - 20];
            }else{
                textLabel.numberOfLines = 2;
                height = 40;
            }
            [self sizeOfHeaderWithHeight:height];
        }
    }

    if ([modelClass isEqual:[RealSurveyOperationEntity class]])
    {
        [self back];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.operDelegate refreshData];
        });
    }
    
    [self hiddenLoadingView];
}


@end
