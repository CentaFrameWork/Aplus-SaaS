//
//  AppendMessageViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/4.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AppendMessageViewController.h"
#import "RemindPersonDetailEntity.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "ApplyReasonInputCell.h"
#import "ApplyTransferPubEstRemindPersonCell.h"
#import "SearchRemindPersonViewController.h"
#import "AddPropertyFollowApi.h"
#import "FollowTypeDefine.h"
#import <iflyMSC/iflyMSC.h>


#define AddRemindPersonActionTag        1000
#define DeleteRemindPersonBtnTag        2000
#define SubmitApplyAlertTag             3000   // 申请转盘成功的alerttag


@interface AppendMessageViewController ()<UITableViewDelegate,UITableViewDataSource,
UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,SearchRemindPersonDelegate,
UITextViewDelegate,IFlyRecognizerViewDelegate,
UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    NSMutableArray *_remindPersonsArr;                  // 提醒人、部门数组
    UICollectionView *_remindPersonCollectionView;      // 显示提醒人collectionView
    UILabel *_appendContentPlaceholderLabel;            // 信息补充内容placeholderLabel
    NSString *_appendContent;                           // 信息补充内容
    
    IFlyRecognizerView  *_iflyRecognizerView;           // 语音输入
    
    BOOL _isNowSubmit;                                  // 现在是否正在上传（防止多次点击）
}

@end

@implementation AppendMessageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupNavigationBar];
    // 添加textView监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    [self initData];
}

- (void)setupNavigationBar
{
	if (_appendMessageType == PropertyFollowTypeInfoAdd)
    {
		[self setNavTitle:@"房源动态"
		   leftButtonItem:[self customBarItemButton:nil
									backgroundImage:nil
										 foreground:@"backBtnImg"
												sel:@selector(back)]
		  rightButtonItem:[self customBarItemButton:@"提交"
									backgroundImage:nil
										 foreground:nil
												sel:@selector(submitAppendMsg)]];
	}
    else if (_appendMessageType == PropertyFollowTypeClareInfo)
    {
		[self setNavTitle:@"洗盘"
		   leftButtonItem:[self customBarItemButton:nil
									backgroundImage:nil
										 foreground:@"backBtnImg"
												sel:@selector(back)]
		  rightButtonItem:[self customBarItemButton:@"提交"
									backgroundImage:nil
										 foreground:nil
												sel:@selector(submitAppendMsg)]];
	}
}

#pragma mark - init

- (void)initData
{
    _isNowSubmit = NO;
    _remindPersonsArr = [[NSMutableArray alloc]init];
}

/**
 *  提交信息补充
 */
- (void)submitAppendMsg
{
    // 正在提交中，不再重复提交
    if (_isNowSubmit)
    {
        return;
    }
    
    [self.view endEditing:YES];
    // 去掉两端的空格
    NSString *trimedString = [_appendContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_appendContent];
    if (!_appendContent ||
        [_appendContent isEqualToString:@""] || isEmpty)
    {
        showMsg(@"请输入内容!");
        return;
    }
	
	NSString *followTypeStr = [[NSString alloc] init];
	if (_appendMessageType == PropertyFollowTypeInfoAdd)
    {
		followTypeStr = [NSString stringWithFormat:@"%ld",(long)_appendMessageType];
	}
    else
    {
		followTypeStr = [NSString stringWithFormat:@"%ld",(long)_appendMessageType];
	}
    
    NSMutableArray *contactsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *contactsKeyIdArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *informDepartsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *informDepartsKeyIdArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _remindPersonsArr.count; i ++) {
        
        RemindPersonDetailEntity *remindPersonEntity = [_remindPersonsArr objectAtIndex:i];
        
        if ([remindPersonEntity.departmentKeyId isEqualToString:
             remindPersonEntity.resultKeyId])
        {
            // 部门
            [informDepartsNameArr addObject:remindPersonEntity.resultName];
            [informDepartsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }
        else
        {
            // 人员
            [contactsNameArr addObject:remindPersonEntity.resultName];
            [contactsKeyIdArr addObject:remindPersonEntity.resultKeyId];
        }
    }
    
    _isNowSubmit = YES;

    [self showLoadingView:@"提交中..."];

    AddPropertyFollowApi *addPropertyFollowApi = [[AddPropertyFollowApi alloc] init];
    addPropertyFollowApi.followType = followTypeStr;
    addPropertyFollowApi.contactsName = contactsNameArr;
    addPropertyFollowApi.informDepartsName = informDepartsNameArr;
    addPropertyFollowApi.followContent = trimedString;//
    addPropertyFollowApi.targetPropertyStatusKeyId = @"";
    addPropertyFollowApi.trustorTypeKeyId = @"";
    addPropertyFollowApi.trustorName = @"";
    addPropertyFollowApi.trustorGenderKeyId = @"";
    addPropertyFollowApi.mobile = @"";
    addPropertyFollowApi.keyId = _propKeyId;
    addPropertyFollowApi.msgUserKeyIds = contactsNameArr;
    addPropertyFollowApi.msgDeptKeyIds = informDepartsNameArr;
    [_manager sendRequest:addPropertyFollowApi];
}

#pragma mark - <AlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SubmitApplyAlertTag)
    {
        if (buttonIndex == 0)
        {
            [self submitSuccess];
        }
    }
}

#pragma mark - <SubmitSuccessMethod>

- (void)submitSuccess
{
    if ([_delegate respondsToSelector:@selector(transferEstSuccess)])
    {
        [_delegate performSelector:@selector(transferEstSuccess)];
    }
    
    [self back];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *remindPersonCellId = @"applyTransferPubEstRemindPersonCell";
    static NSString *applyReasonInputCellId = @"applyReasonInputCell";
    
    ApplyTransferPubEstRemindPersonCell *remindPersonCell = [tableView dequeueReusableCellWithIdentifier:remindPersonCellId];
    ApplyReasonInputCell *applyReasonInputCell = [tableView dequeueReusableCellWithIdentifier:applyReasonInputCellId];
    
    if (indexPath.row == 0)
    {
        if (!applyReasonInputCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ApplyReasonInputCell"
                                                  bundle:nil]
            forCellReuseIdentifier:applyReasonInputCellId];
            
            applyReasonInputCell = [tableView dequeueReusableCellWithIdentifier:applyReasonInputCellId];
        }
        
        applyReasonInputCell.rightInputTextView.text = _appendContent;
        applyReasonInputCell.leftTitleLabel.text = @"*内容";
        applyReasonInputCell.rightInputTextView.delegate = self;
        [applyReasonInputCell.voiceInputBtn addTarget:self
                                               action:@selector(voiceInputMethod)
                                     forControlEvents:UIControlEventTouchUpInside];
        
        _appendContentPlaceholderLabel = applyReasonInputCell.placeholderLabel;
        
        if (_appendContent &&
            ![_appendContent isEqualToString:@""])
        {
            applyReasonInputCell.placeholderLabel.hidden = YES;
        }
        else
        {
            applyReasonInputCell.placeholderLabel.hidden = NO;
        }
        
        return applyReasonInputCell;
        
    }
    else if (indexPath.row == 1)
    {
        if (!remindPersonCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferPubEstRemindPersonCell"
                                                  bundle:nil]
            forCellReuseIdentifier:remindPersonCellId];
            remindPersonCell = [tableView dequeueReusableCellWithIdentifier:remindPersonCellId];
        }
        
        UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                  bundle:nil];
        _remindPersonCollectionView = remindPersonCell.showRemindListCollectionView;
        [_remindPersonCollectionView registerNib:collectionCellNib
                      forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
        _remindPersonCollectionView.delegate = self;
        _remindPersonCollectionView.dataSource = self;
        
        [remindPersonCell.addRemindPersonBtn addTarget:self
                                                action:@selector(clickAddRemindPersonMethod)
                                      forControlEvents:UIControlEventTouchUpInside];
        
        return remindPersonCell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            // 补充内容
            return 115.0;
        }
            break;
            
        case 1:
        {
            // 添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight > 50.0)
            {
                
                return remindPersonHeight+16.0;
            }
            
            return 50.0+16.0;
        }
            break;
            
        default:
            break;
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

#pragma mark - <VoiceInputMethod>

-(void)voiceInputMethod
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    // 检测麦克风功能是否打开
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        
        if (granted)
        {
            // 初始化语音识别控件
            if (!_iflyRecognizerView)
            {
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
                
                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
                
                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
                
                // 设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }
            
            _iflyRecognizerView.delegate = weakSelf;
            
            [_iflyRecognizerView start];
            
        }
        else
        {
            showMsg(SettingMicrophone);
        }
    }];
}

#pragma mark - <IFlyRecognizerViewDelegate>
/** 识别结果返回代理
 *  @param resultArray 识别结果
 *  @param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
    
    if (resultArray.count == 0)
    {
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
    
    // 语音结果最外层的数组
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
    
    for (int i = 0; i < vcnWSArray.count; i ++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue)
    {
        _appendContent = [NSString stringWithFormat:@"%@%@",
                          _appendContent?_appendContent:@"",
                          vcnMutlResultValue];
        if (_appendContent.length > 200)
        {
            _appendContent = [_appendContent substringToIndex:200];
        }
        
        [_mainTableView reloadData];
    }
}

/** 识别会话错误返回代理
 *  @param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0)
    {
    }
}

#pragma mark - <TextViewDelegate>

- (void)textViewChangeInput:(NSNotification *)notification
{
    
    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200)
    {
        NSString * subStr=[inputTextView.text substringToIndex:200];
        inputTextView.text = subStr;
    }
    else
    {
        _appendContent = inputTextView.text;
    }
    
    _appendContentPlaceholderLabel.text = @"";
    _appendContentPlaceholderLabel.textColor = [UIColor blackColor];
    _appendContentPlaceholderLabel.hidden = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (range.length == 0 && range.location>=200)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                 textView.text,
                                 text];
        NSString * subStr=[inputString substringToIndex:200];
        textView.text=subStr;
        
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
    CGFloat collectionViewWidth = (202.0 / 320.0) * APP_SCREEN_WIDTH;
    CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                                           size:14.0]
                                                                    Height:25.0
                                                                      size:14.0];
    resultStrWidth += 20;
    
    if (resultStrWidth > collectionViewWidth)
    {
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

//#pragma mark - <BYActionSheetViewDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView
//  clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//    if (alertView.tag == AddRemindPersonActionTag)
//    {
//        // 添加提醒人
//        SearchRemindType selectRemindType;
//        NSString *selectRemindTypeStr;
//
//        switch (buttonIndex) {
//            case 0:
//            {
//                // 部门
//                selectRemindType = DeparmentType;
//                selectRemindTypeStr = DeparmentRemindType;
//            }
//                break;
//
//            case 1:
//            {
//                // 人员
//                selectRemindType = PersonType;
//                selectRemindTypeStr = PersonRemindType;
//            }
//                break;
//
//            default:
//            {
//                return;
//            }
//                break;
//        }
//
//        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                                  initWithNibName:@"SearchRemindPersonViewController"
//                                                                  bundle:nil];
//        searchRemindPersonVC.selectRemindType = selectRemindType;
//        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//        searchRemindPersonVC.delegate = self;
//        [self.navigationController pushViewController:searchRemindPersonVC
//                                             animated:YES];
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

/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
    
    [self.view endEditing:YES];
    NSArray * listArr = @[@"部门",@"人员"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        // 添加提醒人
        SearchRemindType selectRemindType;
        NSString *selectRemindTypeStr;
        
        switch (optionValue) {
            case 0:
            {
                // 部门
                selectRemindType = DeparmentType;
                selectRemindTypeStr = DeparmentRemindType;
            }
                break;
                
            case 1:
            {
                // 人员
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
        searchRemindPersonVC.delegate = weakSelf;
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
    [_mainTableView reloadData];
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
            if (MODEL_VERSION >= 8.0)
            {
                __weak typeof(self) weakSelf = self;

                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"已提交成功"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {

                                                                          [weakSelf submitSuccess];
                                                                      }];
                [alertCtrl addAction:confirmAction];

                [self presentViewController:alertCtrl
                                   animated:YES
                                 completion:nil];
            }
            else
            {

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"已提交成功"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"确定", nil];
                alert.tag = SubmitApplyAlertTag;
                [alert show];
            }
        }
        else
        {
            showMsg(@"提交失败!");

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
