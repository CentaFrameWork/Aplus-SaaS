//
//  AppendInfoViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AppendInfoViewController.h"
#import "NewOpeningCell.h"
#import "OpeningPersonCell.h"
#import "FollowUpContentCell.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "SearchRemindPersonViewController.h"
#import "PropertyFollowAllAddApi.h"
#import <iflyMSC/iflyMSC.h>
#import "AppendInfoCell.h"
#import "TCPickView.h"
#import "DateTimePickerDialog.h"
#import "AddPropertyFollowApi.h"


#import "AppendInfoZJPresenter.h"


#define AddRemindPersonActionTag        1000
#define DeleteRemindPersonBtnTag        2000
#define SubmitApplyAlertTag             3000    // 申请转盘成功的alerttag

#define FirstButtonContentBaseTag       10001   // 五个按钮相应的内容
#define SecondButtonContentBaseTag      10002
#define ThirdButtonContentBaseTag       10003
#define FourthButtonContentBaseTag      10004
#define FifthButtonContentBaseTag       10005

@interface AppendInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchRemindPersonDelegate,UITextViewDelegate,IFlyRecognizerViewDelegate
,DateTimeSelected>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_remindPersonsArr;              //提醒人、部门数组
    NSArray *_celltitleArr;
    UICollectionView *_remindPersonCollectionView;  //显示提醒人collectionView
    NSString *_appendContent;                       //信息补充内容
    NSString *_msgTime;     //提醒时间
    
    IFlyRecognizerView  *_iflyRecognizerView;       //语音输入
    DateTimePickerDialog *dateTimePickerDialog;
    
    NSDate *_selectedDate;//记录上次选择时间
    NSDate *_oldTime;
    BOOL _isNowSubmit;      //现在是否正在上传（防止多次点击）

    AppendInfoBasePresenter *_appendInfoPresenter;
}

@property (nonatomic, assign)CGFloat viewHeight;

@end

@implementation AppendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    _viewHeight = 0;
    
    [self initPresenter];
    [self initView];
    [self initData];
}

- (void)initView
{
    NSString *NavTitle = @"";
    
    // 隐藏cell分割线
    _mainTableView.separatorStyle = NO;
    _mainTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf4f4f4, 1.0);
    
    if (_appendMessageType == PropertyFollowTypeInfoAdd)
    {
        NavTitle = @"房源动态";
    }
    else if (_appendMessageType == PropertyFollowTypeClareInfo)
    {
        NavTitle = @"洗盘";
    }
    
    [self setNavTitle:NavTitle
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil sel:@selector(commitNewOpening)]];
    
    
    /*
     *添加textView监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
}

- (void)initPresenter
{

        _appendInfoPresenter = [[AppendInfoZJPresenter alloc] initWithDelegate:self];
    
}

- (void)initData
{
    _remindPersonsArr = [[NSMutableArray alloc]init];
    _isNowSubmit = NO;
}


/**
 *  提交信息补充
 */
- (void)commitNewOpening
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
        [_appendContent isEqualToString:@""] || isEmpty) {
        
        if (_appendMessageType == PropertyFollowTypeInfoAdd) {
         
            showMsg(@"请输入信息补充内容!");
        }else if(_appendMessageType == PropertyFollowTypeClareInfo){
         
            showMsg(@"请输入洗盘内容!");
        }
        
        return;
    }
    
     _isNowSubmit = YES;
    
    [_manager sendRequest:[_appendInfoPresenter getRequestApi:_remindPersonsArr
                       andPropertyKeyId:_propertyKeyId
                   andAppendMessageType:_appendMessageType
                       andFollowContent:trimedString andMsgTime:_msgTime]];

    [self showLoadingView:@"提交中..."];
}



//点击按钮将对应的值赋值给跟进内容
- (void)selectButtonTitle:(UIButton *)btnTitle
{
    if (_appendContent.length >= 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"字数不能超过200"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    switch (btnTitle.tag) {
        case FirstButtonContentBaseTag:
            _appendContent = [NSString stringWithFormat:@"%@%@",_appendContent?_appendContent:@"",@"【无人接听】"];
            break;
        case SecondButtonContentBaseTag:
            _appendContent = [NSString stringWithFormat:@"%@%@",_appendContent?_appendContent:@"",@"【非业主电话】"];
            break;
        case ThirdButtonContentBaseTag:
            _appendContent = [NSString stringWithFormat:@"%@%@",_appendContent?_appendContent:@"",@"【不租不售】,原因:"];
            break;
        case FourthButtonContentBaseTag:
            _appendContent = [NSString stringWithFormat:@"%@%@",_appendContent?_appendContent:@"",@"【号码无效】"];
            break;
        case FifthButtonContentBaseTag:
            _appendContent = [NSString stringWithFormat:@"%@%@",_appendContent?_appendContent:@"",@"【行家成交】"];
            break;
        default:
            break;
    }
    
    if (_appendContent.length >= 200)
    {
        _appendContent = [_appendContent substringToIndex:200];
    }
    
    [_mainTableView reloadData];
}



#pragma mark - <TableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTitleStr = _celltitleArr[indexPath.row];
    if ([cellTitleStr isEqualToString:@"跟进内容"]) {
        return 283*NewRatio;
    }
    else if([cellTitleStr isEqualToString:@"快捷输入"]){
        return 103;
    }
    else if ([cellTitleStr isEqualToString:@"提醒人"])
    {
        //添加提醒人
        CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
        
        if (remindPersonHeight != 0) {
            _viewHeight = remindPersonHeight;
        }
        
        if (_viewHeight > 50*NewRatio) {
            return _viewHeight+20*NewRatio;
        }

        return 70*NewRatio;
    }
    else if([cellTitleStr isEqualToString:@"提醒时间"]){
        return 50*NewRatio;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellNumber = 4;
    NSMutableArray *mArr  = [NSMutableArray arrayWithObjects:@"跟进内容",@"快捷输入",@"提醒人",@"提醒时间", nil];
    if (![_appendInfoPresenter haveQuickInputModule]) {
        // 无快捷输入模块
        [mArr removeObject:@"快捷输入"];
        cellNumber--;
    }

    if (![_appendInfoPresenter haveRemindPeople]) {
        // 无提醒人
        [mArr removeObject:@"提醒人"];
        cellNumber--;
    }

    if (![_appendInfoPresenter haveReminderTimeFunction]) {
        // 无提醒时间
        [mArr removeObject:@"提醒时间"];
        cellNumber--;
    }

    _celltitleArr = mArr;
    mArr = nil;
    return cellNumber;
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
    
    //提醒人
    OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier];
    if (!openingPersonCell) {
        [tableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];
        openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier];
        
    }
    
    NSString *cellTitleStr = _celltitleArr[indexPath.row];
    if ([cellTitleStr isEqualToString:@"跟进内容"]) {
        followUpContentCell.rightInputTextView.text = _appendContent;
        followUpContentCell.rightInputTextView.delegate = self;
        [followUpContentCell.voiceInputBtn addTarget:self
                                              action:@selector(voiceInputMethod)
                                    forControlEvents:UIControlEventTouchUpInside];
        return  followUpContentCell;
    }
    else if([cellTitleStr isEqualToString:@"快捷输入"]){
        for (UIButton *btn in appendInfoCell.buttonArray) {
            [btn addTarget:self action:@selector(selectButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
        }
        return appendInfoCell;
    }
    else if ([cellTitleStr isEqualToString:@"提醒人"])
    {
        
        [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
        openingPersonCell.leftPersonLabel.text = @"提醒人";
        _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
        [_remindPersonCollectionView registerNib:[UINib nibWithNibName:@"ApplyRemindPersonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
        _remindPersonCollectionView.delegate = self;
        _remindPersonCollectionView.dataSource = self;
        
        return openingPersonCell;
    }
    else if([cellTitleStr isEqualToString:@"提醒时间"]){
        newOpeningCell.leftTitleLabel.text = @"提醒时间";
        newOpeningCell.rightValueLabel.text = @"点击选择时间";
        newOpeningCell.rightValueLabel.textColor = YCTextColorAuxiliary;
        if (_selectedDate) {
            newOpeningCell.rightValueLabel.textColor = YCTextColorBlack;
            newOpeningCell.rightValueLabel.text = _msgTime;
        }else{
            newOpeningCell.rightValueLabel.textColor = YCTextColorAuxiliary;
            newOpeningCell.rightValueLabel.text = @"点击选择时间";
        }

        return newOpeningCell;
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
    NSString *cellTitleStr = _celltitleArr[indexPath.row];
    if ([cellTitleStr isEqualToString:@"提醒时间"]) {

        if (!_selectedDate) {

            _selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
        }

        dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                            andDelegate:self
                                                                 andTag:@"start"];
        [dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    
    [self.view endEditing:YES];
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
                [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
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
        
        [_mainTableView reloadData];
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

#pragma mark - <TextViewDelegate>
- (void)textViewChangeInput:(NSNotification *)notification
{
    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200)
    {
        if (_appendContent.length > 0)
        {
            inputTextView.text = _appendContent;
        }
        else
        {
            _appendContent = [inputTextView.text substringToIndex:199];
            inputTextView.text = _appendContent;
        }
    }
    else
    {
        _appendContent = inputTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 0 && range.location>=200)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
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
    
    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName size:14*NewRatio] Height:25*NewRatio size:14*NewRatio];
    
    resultStrWidth += 30*NewRatio;
    
    if (resultStrWidth > collectionViewWidth) {
        
        resultStrWidth = collectionViewWidth;
    }
    
    
    return CGSizeMake(resultStrWidth, 25*NewRatio);
    
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

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    
    [_remindPersonsArr addObject:selectRemindItem];
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight) withObject:nil afterDelay:0.2];
}

/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
    [NewUtils popoverSelectorTitle:@"请选择" listArray:@[@"部门",@"人员"] theOption:^(NSInteger optionValue) {
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
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                  initWithNibName:@"SearchRemindPersonViewController"
                                                                  bundle:nil];
        searchRemindPersonVC.selectRemindType = selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.isExceptMe = [_appendInfoPresenter isExceptMe];
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    }];
}

/**
 *  删除提醒人
 */
- (void)deleteRemindPersonMethod:(UIButton *)button
{
    
    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
    
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight) withObject:nil afterDelay:0.2];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_celltitleArr.count - 1) inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];



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

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_celltitleArr.count - 1) inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadRemindCellHeight
{
    [_mainTableView reloadData];
}

#pragma mark - private
- (void)addRemindPersonWithIndex:(NSInteger)index{
    
    //添加提醒人
    SearchRemindType selectRemindType;
    NSString *selectRemindTypeStr;
    
    if (index == 0) {
        //部门
        selectRemindType = DeparmentType;
        selectRemindTypeStr = DeparmentRemindType;
        
    }else if (index == 1){
        
        //人员
        selectRemindType = PersonType;
        selectRemindTypeStr = PersonRemindType;
        
    }
    
    SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
    searchRemindPersonVC.selectRemindType = selectRemindType;
    searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
    searchRemindPersonVC.isExceptMe = [_appendInfoPresenter isExceptMe];
    searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
    searchRemindPersonVC.delegate = self;
    [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    
    
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {

        [self hiddenLoadingView];

        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];

        if (agencyBaseEntity.flag)
        {
            showMsg(@"已提交成功");
            // 获取到 语音按钮
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            FollowUpContentCell *nextCell = [_mainTableView cellForRowAtIndexPath:indexPath];
            nextCell.voiceInputBtn.userInteractionEnabled = NO;
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
            
            if ([_delegate respondsToSelector:@selector(transferEstSuccess)])
            {
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

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    _isNowSubmit = NO;
}

@end
