//
//  AddCustomerFollowActivityVC.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AddCustomerFollowActivityVC.h"
#import "NewOpeningCell.h"
#import "FollowUpContentCell.h"
#import "AppendInfoCell.h"
#import "OpeningPersonCell.h"
#import "DateTimePickerDialog.h"
#import "ApplyRemindPersonCollectionCell.h"
#import <iflyMSC/iflyMSC.h>
#import "SearchRemindPersonViewController.h"
#import "InquiryFollowAddApi.h"


#define DeleteRemindPersonBtnTag        2000
#define AddRemindPersonActionTag        1000

@interface AddCustomerFollowActivityVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DateTimeSelected,SearchRemindPersonDelegate,IFlyRecognizerViewDelegate>
{
    UITableView *_tableView;
    NSDate *_selectedDate;                          // 记录上次选择时间
    NSString *_msgTime;                             // 提醒时间
    NSDate *_oldTime;
    DateTimePickerDialog *_dateTimePickerDialog;
    NSMutableArray *_remindPersonsArr;
    IFlyRecognizerView  *_iflyRecognizerView;       // 语音输入

    UILabel *_appendContentPlaceholderLabel;        // 信息补充内容placeholderLabel
    NSString *_appendContent;                       // 信息补充内容
    BOOL _isNowSubmit;                              // 现在是否正在上传（防止多次点击）

    InquiryFollowAddApi *_followAddApi;
}

@end

@implementation AddCustomerFollowActivityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)initView
{
    [self setNavTitle:_titleName
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil sel:@selector(commit)]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 74)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];

    [self.view addSubview:_tableView];
    
    /*
     *添加textView监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
}

- (void)initData
{
    _remindPersonsArr = [[NSMutableArray alloc]init];
    _remindPersonsArr = [[NSMutableArray alloc]init];
    _isNowSubmit = NO;
    
    _followAddApi = [InquiryFollowAddApi new];
}

#pragma mark - 提交
- (void)commit
{
    /**
     *  正在提交中，不再重复提交
     */
    if (_isNowSubmit) {
        
        return;
    }
    
    [self.view endEditing:YES];
    
    
    //去掉两端的空格
    NSString *trimedString = [_appendContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_appendContent];
    if (!_appendContent ||
        [_appendContent isEqualToString:@""] || isEmpty)
    {
        NSString *alertStr = [NSString stringWithFormat:@"请输入%@内容!", _titleName];
        showMsg(alertStr);
        return;
    }
    
    NSMutableArray *contactsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *contactsKeyIdArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *informDepartsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *informDepartsKeyIdArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<_remindPersonsArr.count; i++) {
        
        RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:i];
        
        if ([remindPersonEntity.departmentKeyId isEqualToString:
             remindPersonEntity.resultKeyId]) {
            
            //部门
            [informDepartsNameArr addObject:remindPersonEntity.resultName];
            [informDepartsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }else{
            
            //人员
            [contactsNameArr addObject:remindPersonEntity.resultName];
            [contactsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }
    }
    
    _isNowSubmit = YES;
    
    SelectItemDtoEntity *followTypeEntity ;
    
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUSTOMER_CONTACT_TYPE];
    for (SelectItemDtoEntity *entity in genderSysParamItemEntity.itemList)
    {
        if ([entity.itemText isEqualToString:_titleName]) {
            followTypeEntity = entity;
        }
    }
    
    _followAddApi.content = trimedString;
    _followAddApi.followTypeCode = followTypeEntity.itemCode;
    _followAddApi.followTypeKeyId = followTypeEntity.itemValue;
    _followAddApi.msgUserKeyIds = contactsKeyIdArr;
    _followAddApi.msgDeptKeyIds = informDepartsKeyIdArr;
    _followAddApi.contactsName = contactsNameArr;
    _followAddApi.informDepartsName = informDepartsNameArr;
    _followAddApi.msgTime = _msgTime ? _msgTime : @"";
    _followAddApi.inquiryKeyId = _inquiryKeyId;
    
    [_manager sendRequest:_followAddApi];
    
    [self showLoadingView:@"提交中..."];
}

/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
    [self.view endEditing:YES];
    NSArray * listArr = @[@"部门",@"人员"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        //添加提醒人
        SearchRemindType selectRemindType;
        NSString *selectRemindTypeStr;
        
        switch (optionValue) {
            case 0:
            {
                //部门
                selectRemindType = DeparmentType;
                selectRemindTypeStr = DeparmentRemindType;
            }
                break;
            case 1:
            {
                //人员
                
                selectRemindType = PersonType;
                selectRemindTypeStr = PersonRemindType;
            }
                break;
                
            default:
            {
                return;
            }
                break;
        }
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
        searchRemindPersonVC.selectRemindType = selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [weakSelf.navigationController pushViewController:searchRemindPersonVC
                                             animated:YES];
        
    }];
    
//    BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:@"部门",@"人员", nil];
//    byActionSheetView.tag = AddRemindPersonActionTag;
//    [byActionSheetView show];
}

/**
 *  删除提醒人
 */
- (void)deleteRemindPersonMethod:(UIButton *)button
{
    
    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
    
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}

- (void)reloadRemindCellHeight
{
    [_tableView reloadData];
}

//#pragma mark - <BYActionSheetViewDelegate>
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex
//         andButtonTitle:(NSString *)buttonTitle
//{
//
//    switch (alertView.tag) {
//        case AddRemindPersonActionTag:
//        {
//            //添加提醒人
//            SearchRemindType selectRemindType;
//            NSString *selectRemindTypeStr;
//
//            switch (buttonIndex) {
//                case 0:
//                {
//                    //部门
//                    selectRemindType = DeparmentType;
//                    selectRemindTypeStr = DeparmentRemindType;
//                }
//                    break;
//                case 1:
//                {
//                    //人员
//
//                    selectRemindType = PersonType;
//                    selectRemindTypeStr = PersonRemindType;
//                }
//                    break;
//
//                default:
//                {
//                    return;
//                }
//                    break;
//            }
//
//            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                                      initWithNibName:@"SearchRemindPersonViewController"
//                                                                      bundle:nil];
//            searchRemindPersonVC.selectRemindType = selectRemindType;
//            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//            searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//            searchRemindPersonVC.delegate = self;
//            [self.navigationController pushViewController:searchRemindPersonVC
//                                                 animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
//}


#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            //初始化语音识别控件
            if (!_iflyRecognizerView) {
                
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                //设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }
            
            _iflyRecognizerView.delegate = weakSelf;
            
            [_iflyRecognizerView start];
            
        }else{
            
            showMsg(SettingMicrophone);
        }
    }];
    
}

#pragma mark - <IFlyRecognizerViewDelegate>
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
    
    if (resultArray.count == 0) {
        
        return;
    }
    
    /**
     *  语音输入后返回的内容格式...
     *
     *  {
     bg = 0;
     ed = 0;
     ls = 0;
     sn = 1;
     ws =     (
     {
     bg = 0;
     cw =
     (
     {
     sc = "-101.93";
     w = "\U5582";
     }
     );
     },
     );
     }
     */
    
    
    NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
    NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error];
    
    NSMutableString *vcnMutlResultValue = [[NSMutableString alloc]init];
    
    /**
     语音结果最外层的数组
     */
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
    
    for (int i = 0; i<vcnWSArray.count; i++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue) {
        
        _appendContent = [NSString stringWithFormat:@"%@%@",
                          _appendContent?_appendContent:@"",
                          vcnMutlResultValue];
        
        if (_appendContent.length > 200) {
            
            _appendContent = [_appendContent substringToIndex:200];
            
        }
        
        [_tableView reloadData];
    }
    
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0) {
        
    }
}

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    
    [_remindPersonsArr addObject:selectRemindItem];
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}


#pragma mark - <DateTimeSelectedDelegate>
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *now = [date  dateByAddingTimeInterval: interval];//当前时间
    NSDate *selectTime = [DateTimePickerDialog ConversionTimeZone:dateTime];
    
    NSTimeInterval secondsInterval= [selectTime timeIntervalSinceDate:now];
    
    //不是之前的日期
    if (secondsInterval > 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        
        _msgTime = [dateFormatter stringFromDate:dateTime];
        
        _selectedDate = dateTime;
        
    }else{
        showMsg(@"请选择有效日期");
    }
}

///确定
- (void)clickDone{
    if (_msgTime == nil) {
        //没有滑动
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        _msgTime = [dateFormatter stringFromDate:_selectedDate];
    }
    
    _oldTime = _selectedDate;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

///取消
- (void)clickCancle{
    
    if (!_oldTime) {
        
        _msgTime = nil;
        _selectedDate = nil;
    }else{
        
        _selectedDate = _oldTime;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        
        _msgTime = [dateFormatter stringFromDate:_oldTime];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <TextViewDelegate>
- (void)textViewChangeInput:(NSNotification *)notification
{
    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200) {
        
        inputTextView.text = _appendContent;
        return;
    }
    else
    {
        _appendContent = inputTextView.text;
    }
}

#pragma mark - <TableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 173;
            break;
        case 1:
        {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;

            if (remindPersonHeight > 80.0) {

                return remindPersonHeight+16.0;
            }
            return 80.0+16.0;
        }
            break;
        default:
            break;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([CityCodeVersion isDongGuan])
    {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newOpeningCellIdentifier = @"newOpeningCell";
    NSString *openingPersonCellIdentifier = @"openingPersonCell";
    NSString *followUpContentCellIdentifier = @"followUpContentCell";
    NSString *appendInfoCellIdentifier = @"appendInfoCell";
    
    NewOpeningCell *newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
    if (!newOpeningCell) {
        [tableView registerNib:[UINib nibWithNibName:@"NewOpeningCell" bundle:nil] forCellReuseIdentifier:newOpeningCellIdentifier];
        newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
    }
    
    //跟进内容
    FollowUpContentCell *followUpContentCell = [tableView dequeueReusableCellWithIdentifier:followUpContentCellIdentifier];
    if (!followUpContentCell) {
        [tableView registerNib:[UINib nibWithNibName:@"FollowUpContentCell" bundle:nil] forCellReuseIdentifier:followUpContentCellIdentifier];
        followUpContentCell = [tableView dequeueReusableCellWithIdentifier:followUpContentCellIdentifier];
    }
    //选择内容
    AppendInfoCell *appendInfoCell = [tableView dequeueReusableCellWithIdentifier:appendInfoCellIdentifier];
    if (!appendInfoCell) {
        [tableView registerNib:[UINib nibWithNibName:@"AppendInfoCell" bundle:nil] forCellReuseIdentifier:appendInfoCellIdentifier];
        appendInfoCell = [tableView dequeueReusableCellWithIdentifier:appendInfoCellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            followUpContentCell.rightInputTextView.text = _appendContent;
            followUpContentCell.rightInputTextView.delegate = self;
            [followUpContentCell.voiceInputBtn addTarget:self
                                                  action:@selector(voiceInputMethod)
                                        forControlEvents:UIControlEventTouchUpInside];
            return  followUpContentCell;
            break;
       
        case 1:
        {
            //提醒人
            OpeningPersonCell *openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier forIndexPath:indexPath];
            UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                      bundle:nil];
            _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
            [_remindPersonCollectionView registerNib:collectionCellNib
                          forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _remindPersonCollectionView.delegate = self;
            _remindPersonCollectionView.dataSource = self;
            
            [openingPersonCell.addOpeningPersonBtn addTarget:self
                                                      action:@selector(clickAddRemindPersonMethod)
                                            forControlEvents:UIControlEventTouchUpInside];
            openingPersonCell.leftPersonLabel.text = @"提醒人";
            return openingPersonCell;
        }
            break;
        case 2:
        {
            newOpeningCell.leftTitleLabel.text = @"提醒时间";
            newOpeningCell.rightValueLabel.text = @"点击选择时间";
            if (_selectedDate) {
                newOpeningCell.rightValueLabel.text = _msgTime;
            }else{
                newOpeningCell.rightValueLabel.text = @"点击选择时间";
            }
            
            return newOpeningCell;
        }
            break;
            
        default:
            break;
    }
    return  [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [CommonMethod resignFirstResponder];
        
        if (!_selectedDate) {
            
            _selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
        }
        
        _dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                            andDelegate:self
                                                                 andTag:@"start"];
        
        [_dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
        
    }
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
#pragma mark - <UICollectionViewDelegate/DataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _remindPersonsArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    
    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;
    
    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                                           size:14.0]
                                                                    Height:25.0
                                                                      size:14.0];
    
    resultStrWidth += 20;
    
    if (resultStrWidth > collectionViewWidth) {
        
        resultStrWidth = collectionViewWidth;
    }
    
    
    return CGSizeMake(resultStrWidth, 25);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *collectionCellId = @"applyRemindPersonCollectionCell";
    
    ApplyRemindPersonCollectionCell *remindPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_remindPersonCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                                                                                                            forIndexPath:indexPath];
    
    remindPersonCollectionCell.rightDeleteBtn.tag = DeleteRemindPersonBtnTag+indexPath.row;
    [remindPersonCollectionCell.rightDeleteBtn addTarget:self
                                                  action:@selector(deleteRemindPersonMethod:)
                                        forControlEvents:UIControlEventTouchUpInside];
    
    RemindPersonDetailEntity *curRemindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
    remindPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;
    
    return remindPersonCollectionCell;
    
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    if ([modelClass isEqual:[AgencyBaseEntity class]]) {
        
        [self hiddenLoadingView];
        
        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyBaseEntity.flag)
        {
            showMsg(@"已提交成功");
            
            [self performSelector:@selector(back) withObject:nil afterDelay:2.0f];
            
            if ([_delegate respondsToSelector:@selector(transferEstSuccess)]) {
                
                [_delegate performSelector:@selector(transferEstSuccess)];
            }
        }
        else
        {
            showMsg(@"提交失败，请重试!");
            _isNowSubmit = NO;
        }
    }
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    _isNowSubmit = NO;
}


@end
