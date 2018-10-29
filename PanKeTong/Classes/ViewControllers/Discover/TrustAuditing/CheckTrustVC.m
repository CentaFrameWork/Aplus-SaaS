//
//  CheckTrustVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/23.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CheckTrustVC.h"
#import "CheckTrustPhotosCell.h"
#import "AudioPlayView.h"
#import "CheckTrustApi.h"
#import "ApproveRecordApi.h"
#import "LookTrustPhotosVC.h"

#define LineViewTag         1111
#define AidioPlayerTag      2222
#define CredentialsAlertTag 100
#define PassAlertTag        200
#define RejectAlertTag      300

@interface CheckTrustVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,
CustomTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{

    UITableView *_tableView;
    IBOutlet UIView *_footerView;
    IBOutlet UIView *_rejectView;
    __weak IBOutlet CustomTextView *_inputView;
    UIView *_shadowView;
    UICollectionView *_collectionView;

    BOOL _haveAudio;// 是否有录音附件

    NSArray *_dataArr;
    CGFloat _keyBoardHeight;
}

@end

@implementation CheckTrustVC

- (void)dealloc{
    AudioPlayView *audioPlayView = [_tableView viewWithTag:AidioPlayerTag];
    [audioPlayView.audioPlayer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"查看委托"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    // 增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    // 增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    

  
    [self initNoClassifyUI];
    

    // 加载数据
    [self requestData];
}

// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    _rejectView.height = 250 + _keyBoardHeight - 26;
    _rejectView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;

}

// 当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)notification{
    _keyBoardHeight = 0;
    if (_shadowView.hidden == NO)
    {
        _rejectView.height = 250;
        _rejectView.bottom = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // 如果正在播放，暂停
    if (_isPlaying)
    {
        AudioPlayView *audioPlayView = [_tableView viewWithTag:AidioPlayerTag];
        [audioPlayView audioPlayOrPause];
    }
}




#pragma mark - 附件分类UI

- (void)initClassifyUI
{
    CGFloat height = [_pushType isEqualToString:UNAUDITING]?APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - 60:APP_SCREEN_HEIGHT - 70;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    if ([_pushType isEqualToString:UNAUDITING])
    {// 待审核状态
        _footerView.frame = CGRectMake(0, _tableView.bottom, APP_SCREEN_WIDTH, 60);
        [self.view addSubview:_footerView];


    }
}

#pragma mark - 附件不分类UI

- (void)initNoClassifyUI{
    CGFloat height = 160;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    if ([_pushType isEqualToString:UNAUDITING])// 待审核状态
    {
        _footerView.frame = CGRectMake(0, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - 60, APP_SCREEN_WIDTH, 60);
        [self.view addSubview:_footerView];


    }
    else
    {
        _footerView.height = 0;
    }

    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 160, 200, 40)];
    headLabel.textColor = [UIColor darkGrayColor];
    headLabel.text = @"业主委托";
    headLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:headLabel];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置布局对象之间的垂直行与行之间的最小间距  默认为10
    flowLayout.minimumInteritemSpacing = 0;
    // 设置布局对象的大小
    CGFloat width = (APP_SCREEN_WIDTH  - 45 - 30)/3;
    flowLayout.itemSize = CGSizeMake(width,150);
    // 设置布局对象之间水平的最小间距  默认为10
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 5;
    // 设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    // 自定义大小
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, headLabel.bottom,
                                                                         APP_SCREEN_WIDTH - 30,
                                                                         APP_SCREEN_HEIGHT - 274 - _footerView.height)
                                         collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];

    // 注册单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LookPhotosCell"];

}

#pragma mark - 请求数据

- (void)requestData{
    CheckTrustApi *checkTrustApi = [[CheckTrustApi alloc] init];
    checkTrustApi.keyId = _propertyKeyId;
    [_manager sendRequest:checkTrustApi];

    [self showLoadingView:nil];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 3;
    }
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        return 50;
    }else
    {
        if (_haveAudio == YES)
        {
            if (indexPath.row == 0)
            {
                return 50;
            }
        }
    }
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0)
    {
        return 10;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) // 第一组
    {
        UITableViewCell *firstSectionCell = [tableView dequeueReusableCellWithIdentifier:@"firstSectionCell"];
        if (firstSectionCell == nil)
        {
            firstSectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"firstSectionCell"];
            firstSectionCell.textLabel.font = [UIFont systemFontOfSize:15];
            firstSectionCell.textLabel.textColor = [UIColor grayColor];
            firstSectionCell.detailTextLabel.textColor = [UIColor darkGrayColor];
            firstSectionCell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (indexPath.row != 2)
            {
                UIView *lineView = [firstSectionCell.contentView viewWithTag:LineViewTag];
                if (lineView == nil)
                {
                    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, APP_SCREEN_WIDTH, 0.5)];
                    lineView.tag = LineViewTag;
                    lineView.backgroundColor = RGBColor(225, 225, 225);
                    [firstSectionCell.contentView addSubview:lineView];
                }
            }
        }

        if (indexPath.row == 0)
        {
            firstSectionCell.textLabel.text = @"签署人";
            firstSectionCell.detailTextLabel.text = _creatorPersonName;
        }else if (indexPath.row == 1)
        {
            firstSectionCell.textLabel.text = @"签署时间";
            firstSectionCell.detailTextLabel.text = _signDate;
        }else
        {
            firstSectionCell.textLabel.text = @"签署类型";
            firstSectionCell.detailTextLabel.text = _signType;
        }

        return firstSectionCell;

    }
    else  // 第二组
    {
        NSDictionary *dic = _dataArr[indexPath.row];
        if (_haveAudio)
        {
            if (indexPath.row == 0)
            {
                UITableViewCell *firstRowCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                firstRowCell.textLabel.font = [UIFont systemFontOfSize:15];
                firstRowCell.textLabel.textColor = [UIColor darkGrayColor];
                firstRowCell.selectionStyle = UITableViewCellSelectionStyleNone;

                AudioPlayView *audioPlayView = [firstRowCell.contentView viewWithTag:AidioPlayerTag];
                if (audioPlayView == nil)
                {
                    audioPlayView = [AudioPlayView new];
                    audioPlayView.tag = AidioPlayerTag;
                    CGFloat width = APP_SCREEN_WIDTH - 110;
                    audioPlayView.frame = CGRectMake(110, 0,width , 50);
                    [firstRowCell.contentView addSubview:audioPlayView];
                }

                NSArray *arr = [[dic allValues] lastObject];
                SubCheckTrustEntity *entity =  arr[0];
                audioPlayView.audioUrl = entity.attachmentPath;
                firstRowCell.textLabel.text = @"委托录音";
                return firstRowCell;
            }
        }

        CheckTrustPhotosCell *secondSetionCell = [tableView dequeueReusableCellWithIdentifier:@"CheckTrustPhotosCell"];
        if (secondSetionCell == nil)
        {
            secondSetionCell = [[[NSBundle mainBundle] loadNibNamed:@"CheckTrustPhotosCell" owner:nil options:nil] lastObject];
            secondSetionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        secondSetionCell.dataDic = dic;
        
        return secondSetionCell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSDictionary *dic = _dataArr[indexPath.row];
        NSString *keyStr = [[dic allKeys] lastObject];
        if (![keyStr isEqualToString:@"录音"])
        {
            LookTrustPhotosVC *vc = [[LookTrustPhotosVC alloc] init];
            vc.lastIndex = 0;
            vc.navTitleStr = keyStr;
            vc.dataArr = [dic objectForKey:keyStr];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LookPhotosCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];

    UIImageView *imgView = [cell.contentView viewWithTag:1993];
    CGFloat width = (APP_SCREEN_WIDTH  - 45 - 30)/3;
    UILabel *typeLabel;
    if (imgView == nil)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
        imgView.tag = 1993;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgView];
    }

    if (_dataArr.count > 0)
    {
        SubCheckTrustEntity *entity = _dataArr[indexPath.row];
        NSString *imgStr = [NSString stringWithFormat:@"%@%@%@",entity.attachmentPath,AllRoundListPhotoWidth,TrustWaterMark];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgStr]];

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LookTrustPhotosVC *vc = [[LookTrustPhotosVC alloc] init];
    vc.navTitleStr = @"附件图片";
    vc.lastIndex = indexPath.row;
    vc.dataArr = _dataArr;
    vc.isHaveImgType = NO;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 审核通过

- (IBAction)TrustPasssClick:(UIButton *)sender
{
    [CommonMethod addLogEventWithEventId:@"A power of a_adopt_Function" andEventDesc:@"委托审核通过数量"];
    
    
    

}

#pragma mark - 审核拒绝

- (IBAction)TrustRefuseClick:(UIButton *)sender
{
    [CommonMethod addLogEventWithEventId:@"A power of a_refuse_Function" andEventDesc:@"委托审核拒绝数量"];



        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确认要拒绝该业主委托吗？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"是", nil];
        alertView.tag = RejectAlertTag;
        [alertView show];
    }


#pragma mark - 确定审核拒绝

- (IBAction)sureClick:(UIButton *)sender
{
    [self rejectRequest];
}

#pragma mark - <CustomTextViewDelegate>

- (void)customTextViewDidEndEditing:(UITextView *)textView
{
    [_inputView resignFirstResponder];
}

- (void)customTextViewAchieveTextLengthLimit
{
    showMsg(@"字数不能超过200");
}

- (void)rejectRequest
{


    ApproveRecordApi *approveRecordApi = [[ApproveRecordApi alloc] init];
    approveRecordApi.regTrustsAuditStatus = @(2);
    approveRecordApi.keyId = _trustkeyId;
    approveRecordApi.isCredentials = @"";
    approveRecordApi.reject = _inputView.text;
    [_manager sendRequest:approveRecordApi];

    [self showLoadingView:nil];
}

#pragma mark - 取消

- (IBAction)cancelClick:(UIButton *)sender
{
    _shadowView.hidden = YES;
    _rejectView.top = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
    [CommonMethod resignFirstResponder];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CredentialsAlertTag)
    {
        ApproveRecordApi *approveRecordApi = [[ApproveRecordApi alloc] init];
        approveRecordApi.regTrustsAuditStatus = @(1);
        approveRecordApi.keyId = _trustkeyId;
        if (buttonIndex == 1)
        {
            // 证件齐全
            approveRecordApi.isCredentials = @"true";
        }
        else if(buttonIndex == 2)
        {
            // 证件不齐全
            approveRecordApi.isCredentials = @"false";
        }
        else
        {
            return;
        }
        [_manager sendRequest:approveRecordApi];
        [self showLoadingView:nil];
    }

    else if (alertView.tag == PassAlertTag)
    {
        if (buttonIndex == 1)
        {
            ApproveRecordApi *approveRecordApi = [[ApproveRecordApi alloc] init];
            approveRecordApi.regTrustsAuditStatus = @(1);
            approveRecordApi.keyId = _trustkeyId;
            [_manager sendRequest:approveRecordApi];
            [self showLoadingView:nil];
        }
    }

    else if  (alertView.tag == RejectAlertTag)
    {
        if (buttonIndex == 1)
        {
            ApproveRecordApi *approveRecordApi = [[ApproveRecordApi alloc] init];
            approveRecordApi.regTrustsAuditStatus = @(2);
            approveRecordApi.keyId = _trustkeyId;
            [_manager sendRequest:approveRecordApi];
            [self showLoadingView:nil];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _shadowView.hidden = YES;
    _rejectView.top = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT;
    [CommonMethod resignFirstResponder];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[CheckTrustEntity class]])
    {
        CheckTrustEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        NSArray *array = entity.attachmentModels;

       
            // 北京－附件不分类
            _dataArr = array;
            [_collectionView reloadData];
        
        

//        // 筛选出所有的分类
//        NSMutableSet *mSet = [NSMutableSet set];
//        for (SubCheckTrustEntity *entity in array)
//        {
//            if (entity.attachmenSysTypeName.length > 0)
//            {
//                [mSet addObject:entity.attachmenSysTypeName];
//            }
//            else
//            {
//                entity.attachmenSysTypeName = @"其他";
//                [mSet addObject:entity.attachmenSysTypeName];
//            }
//        }
//
//        // 分类整理数据
//        NSMutableArray *mArr = [NSMutableArray array];
//        for (NSString *typeStr in mSet)
//        {
//            NSMutableArray *mArr2D = [NSMutableArray array];
//            for (SubCheckTrustEntity *entity in array)
//            {
//                if (entity.attachmenSysTypeName.length > 0 &&
//                    [entity.attachmenSysTypeName isEqualToString:typeStr])
//                {
//                    [mArr2D addObject:entity];
//                }
//            }
//
//            NSDictionary *dic = @{typeStr:mArr2D};
//            if ([typeStr isEqualToString:@"录音"])
//            {
//                _haveAudio = YES;
//                [mArr insertObject:dic atIndex:0];
//            }
//            else
//            {
//                [mArr addObject:dic];
//            }
//            mArr2D = nil;
//        }
//
//        _dataArr = mArr;
//        mSet = nil;
//        mArr = nil;
//        [_tableView reloadData];
    }
    else if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        if ([self.refreshDelegate respondsToSelector:@selector(isRefreshData:)])
        {
            [self.refreshDelegate isRefreshData:YES];
        }
        [self performSelector:@selector(back) withObject:nil afterDelay:1];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    NSLog(@"%@",error);
}

@end
