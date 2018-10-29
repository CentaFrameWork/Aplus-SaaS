//
//  NewReminRecordViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "NewReminRecordViewController.h"
#import "NewTakeLookThirdCell.h"
#import "NewTakeLookFourthCell.h"
#import "NewTakeLookSecondCell.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "SearchRemindPersonViewController.h"
#import <iflyMSC/iflyMSC.h>
#import "TCPickView.h"
#import "AddAlertApi.h"

#define AddRemindPersonAndAepartmentActionTag        1000
#define AddRemindPersonActionTag                     1001
#define AddRemindAepartmentActionTag                 1002
#define DeleteRemindPersonBtnTag                     2000

@interface NewReminRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,
                                            UICollectionViewDelegate,UICollectionViewDataSource,
                                            IFlyRecognizerViewDelegate,TCPickViewDelegate
                                            ,SearchRemindPersonDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_remindPersonsArr;              //提醒人、部门数组
    NSString *_remindContent;   //提醒内容
    
    UICollectionView *_remindPersonCollectionView;  //显示提醒人collectionView
    
    IFlyRecognizerView  *_iflyRecognizerView;       //语音输入
    BOOL _hasPickView;         //是否页面上存在时间选择器
    NSString *_selectReminTime;     //选择提醒时间
    BOOL _isNowSubmit;      //现在是否正在提交（防止多次点击）
}

@end

@implementation NewReminRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

-(void)initView
{
    _remindContent = @"提醒内容";
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self setNavTitle:@"新增提醒"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submitGoOutMethod)]];
}

-(void)initData
{
    _isNowSubmit = NO;
    _remindPersonsArr = [[NSMutableArray alloc]init];
}

#pragma mark 提交方法
-(void)submitGoOutMethod
{
    
    /**
     *  正在提交中，不再重复提交
     */
    if (_isNowSubmit) {
        
        return;
    }
    [self.view endEditing:YES];
    
    //判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_remindContent];
    if (!_remindContent ||
        [_remindContent isEqualToString:@"提醒内容"] || isEmpty) {
        showMsg(@"请填写提醒内容!");
        return;
    }
    if (!_selectReminTime) {
        showMsg(@"请选择提醒时间!");
        return;
    }
    IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
    AddAlertApi *addAlertApi = [[AddAlertApi alloc] init];
    addAlertApi.deptKeyId = @"";
    addAlertApi.deptName = @"";
    addAlertApi.employeeNo = @"";
    addAlertApi.employeeKeyId = @"";
    addAlertApi.employeeName = @"";
    addAlertApi.alertEventTimes = _selectReminTime;
    addAlertApi.remark = _remindContent;
    addAlertApi.createUserKeyId = identifyEntity.uId;
    
    for (int i = 0; i<_remindPersonsArr.count; i++) {
        
        RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:i];
        
        if ([remindPersonEntity.departmentKeyId isEqualToString:
             remindPersonEntity.resultKeyId]) {
            //部门
            addAlertApi.deptKeyId = remindPersonEntity.resultKeyId;
            addAlertApi.deptName = remindPersonEntity.resultName;
    
        }else{
            //人员
            addAlertApi.employeeKeyId = remindPersonEntity.resultKeyId;
            addAlertApi.employeeName = remindPersonEntity.resultName;
        }
    }
    
    if (addAlertApi.employeeName.length < 1 || addAlertApi.employeeName.length < 1) {
        showMsg(@"请选择提醒人或部门!");
        return;
    }
    [_manager sendRequest:addAlertApi];
    _isNowSubmit = YES;
}

#pragma mark - TCPickViewDelegate
- (void)pickViewRemove
{
    _hasPickView = NO;
}

/**
 *  添加提醒人
 */
- (void)AddRemindPersonMethod
{
    [self.view endEditing:YES];
    
    NSArray * listArr = @[];
    
    //如果人员和部门都添加了则不能再添加了
    if (_remindPersonsArr.count > 1) {
        
        return;
    }else if (_remindPersonsArr.count == 0){
        
        listArr = @[@"部门",@"人员"];
    }else{
        
        for (int i = 0; i<_remindPersonsArr.count; i++) {
            
            RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:i];
            
            if ([remindPersonEntity.departmentKeyId isEqualToString:
                 remindPersonEntity.resultKeyId]) {
                
                listArr = @[@"人员"];
                
            }else {
                
                listArr = @[@"部门"];
                
            }
        }
        
    }
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        SearchRemindType selectRemindType;
        NSString *selectRemindTypeStr;
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
        if ([CityCodeVersion isShenZhen] || [CityCodeVersion isNanJing]) {
            searchRemindPersonVC.isExceptMe = NO;
            
        }
        
        searchRemindPersonVC.isExceptMe = YES;
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = weakSelf;
        
        NSString * title = listArr[optionValue];
        
        if ([title isEqualToString:@"部门"]) {
            
            selectRemindType = DeparmentType;
            selectRemindTypeStr = DeparmentRemindType;
            searchRemindPersonVC.selectRemindType = selectRemindType;
            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
            
        }else{
            
            selectRemindType = PersonType;
            selectRemindTypeStr = PersonRemindType;
            searchRemindPersonVC.selectRemindType = selectRemindType;
            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
            
        }
        
        [weakSelf.navigationController pushViewController:searchRemindPersonVC animated:YES];
        
    }];
    
    
    
    
//    BYActionSheetView * byActionSheetView;
//
//
//    //如果人员和部门都添加了则不能再添加了
//    if (_remindPersonsArr.count > 1) {
//        return;
//    }else if (_remindPersonsArr.count == 0)
//    {
//        byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"部门",@"人员", nil];
//        byActionSheetView.tag = AddRemindPersonAndAepartmentActionTag;
//    }
//
//    // 如果添加了部门就不能再添加人员了，如果添加了人员就不能添加部门了
//    for (int i = 0; i<_remindPersonsArr.count; i++) {
//
//        RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:i];
//
//        if ([remindPersonEntity.departmentKeyId isEqualToString:
//             remindPersonEntity.resultKeyId]) {
//            //有部门了，只能添加人员
//            byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                      otherButtonTitles:@"人员", nil];
//            byActionSheetView.tag = AddRemindPersonActionTag;
//
//        }else {
//            //有人员了，只能添加部门
//            byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                               delegate:self
//                                                      cancelButtonTitle:@"取消"
//                                                      otherButtonTitles:@"部门", nil];
//            byActionSheetView.tag = AddRemindAepartmentActionTag;
//
//        }
//    }
//
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

//#pragma mark - <BYActionSheetViewDelegate>
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex
//         andButtonTitle:(NSString *)buttonTitle
//{
//    SearchRemindType selectRemindType;
//    NSString *selectRemindTypeStr;
//
//    SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                              initWithNibName:@"SearchRemindPersonViewController"
//                                                              bundle:nil];
//    if ([CityCodeVersion isShenZhen] || [CityCodeVersion isNanJing]) {
//        searchRemindPersonVC.isExceptMe = NO;
//
//    }
//    searchRemindPersonVC.isExceptMe = YES;
//    searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//    searchRemindPersonVC.delegate = self;
//    //添加提醒人
//    switch (alertView.tag) {
//            //人和部门都能添加
//        case AddRemindPersonAndAepartmentActionTag:
//        {
//            switch (buttonIndex) {
//                case 0:
//                {
//                    //部门
//
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
//            searchRemindPersonVC.selectRemindType = selectRemindType;
//            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//            [self.navigationController pushViewController:searchRemindPersonVC
//                                                 animated:YES];
//        }
//            break;
//            //只能添加人员
//        case AddRemindPersonActionTag:
//        {
//            switch (buttonIndex) {
//                case 0:
//                {
//                    selectRemindType = PersonType;
//                    selectRemindTypeStr = PersonRemindType;
//                    searchRemindPersonVC.selectRemindType = selectRemindType;
//                    searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
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
//            [self.navigationController pushViewController:searchRemindPersonVC
//                                                 animated:YES];
//        }
//            break;
//            //只能添加部门
//        case AddRemindAepartmentActionTag:
//        {
//            switch (buttonIndex) {
//                case 0:
//                {
//                    selectRemindType = DeparmentType;
//                    selectRemindTypeStr = DeparmentRemindType;
//                    searchRemindPersonVC.selectRemindType = selectRemindType;
//                    searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//                }
//                    break;
//
//                default:
//                {
//                    return;
//                }
//                    break;
//            }
//            [self.navigationController pushViewController:searchRemindPersonVC
//                                                 animated:YES];
//        }
//            break;
//
//        default:
//            break;
//
//    }
//}

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    
    [_remindPersonsArr addObject:selectRemindItem];
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTakeLookFourthCell *firstCell = [NewTakeLookFourthCell cellWithTableView:tableView];
    NewTakeLookSecondCell *secondCell = [NewTakeLookSecondCell cellWithTableView:tableView];
    NewTakeLookThirdCell *thirdCell = [NewTakeLookThirdCell cellWithTableView:tableView];
    
    switch (indexPath.section) {
        case 0:
        {
            UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                      bundle:nil];
            _remindPersonCollectionView = firstCell.reminPersonCollection;
            [_remindPersonCollectionView registerNib:collectionCellNib
                          forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _remindPersonCollectionView.delegate = self;
            _remindPersonCollectionView.dataSource = self;
            
            [firstCell.addPersonBtn addTarget:self
                                                      action:@selector(AddRemindPersonMethod)
                                            forControlEvents:UIControlEventTouchUpInside];
            
            return firstCell;
        }
            break;
        case 1:
        {
            secondCell.leftTitle.text = @"提醒时间";
            secondCell.rightTitle.text = _selectReminTime?_selectReminTime:@"选择提醒时间";
            return secondCell;
        }
            break;
        case 2:
        {
            thirdCell.remindTextView.text = _remindContent;
            thirdCell.remindTextView.delegate = self;
            [thirdCell.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];
            
            return thirdCell;
        }
            break;
            
        default:
            break;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasPickView) {
        return;
    }
    
    if (indexPath.section == 1) {
        _hasPickView = YES;
        TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:[NSDate date] mode:UIDatePickerModeDate];
        pickView.myDelegate = self;
        [pickView showPickViewWithResultBlock:^(id result) {
            
            NSString *time = result;
            _hasPickView = NO;
            
            _selectReminTime = time;
            [_mainTableView reloadData];
        }];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        //添加提醒人
        CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
        
        if (remindPersonHeight > 34.0) {
            
            return remindPersonHeight+16.0;
        }
        
        return 50;
    }else if (indexPath.section == 1)
    {
        return 40;
    }else if (indexPath.section == 2)
    {
        return 130;
    }else{
        return 50;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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


#pragma mark - <TextViewDelegate>

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200) {
        NSString *subStr=[textView.text substringToIndex:200];
        textView.text = subStr;
    }else{
        _remindContent = textView.text;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_remindContent.length == 0 || [_remindContent isEqualToString:@"提醒内容"])
    {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"提醒内容";
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)reloadRemindCellHeight
{
    
    [_mainTableView reloadData];
}

#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    //检测麦克风功能是否打开
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
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
        
        _remindContent = [NSString stringWithFormat:@"%@%@",
                          _remindContent?_remindContent:@"",
                          vcnMutlResultValue];
        
        if (_remindContent.length > 200) {
            
            _remindContent = [_remindContent substringToIndex:200];
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

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    if ([modelClass isEqual:[AgencyBaseEntity class]]) {
        
        [self hiddenLoadingView];
        
        AgencyBaseEntity *agencyBaseEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (agencyBaseEntity.flag) {
            showMsg(@"已提交成功");
            [self.navigationController popViewControllerAnimated:YES];
            if ([_delegate respondsToSelector:@selector(addAlertSuccess)]) {
                
                [_delegate performSelector:@selector(addAlertSuccess)];
            }
            
        }else{
            
            showMsg(@"提交失败，请重试!");
            
            _isNowSubmit = NO;
        }
    }
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    _isNowSubmit = NO;
}

-(void)dealloc{
    
}

@end
