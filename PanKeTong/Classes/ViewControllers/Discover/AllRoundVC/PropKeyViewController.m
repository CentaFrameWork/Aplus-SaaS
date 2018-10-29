//
//  PropKeyViewController.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
// 

#import "PropKeyViewController.h"
#import "ReactiveCocoa.h"
#import "PropSituationKeyCell.h"
#import "FollowUpContentCell.h"
#import "PropKeyModel.h"
#import <iflyMSC/iflyMSC.h>             //语音的
#import "SearchRemindPersonViewController.h"

@interface PropKeyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,IFlyRecognizerViewDelegate,SearchRemindPersonDelegate>
{
    IFlyRecognizerView  *_iflyRecognizerView;       // 语音输入
    NSString *_appendContent;                       // 信息补充内容
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)PropKeyModel *model;

@end

@implementation PropKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"编辑钥匙" leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"提交" backgroundImage:nil foreground:nil sel:@selector(commitNewOpening)]];
    
    [self initData];
    [self TableView];
}


- (void)initData {
    _model = [[PropKeyModel alloc] init];
    _model.propertyKeyStatus = 1;
    _model.keyId = _keyId;
    _model.propertyKeyId = _keyId;
    
    
    NSString *string = [NSString stringWithFormat:@"%@?PropertyKeyId=%@",AipPropertyKey,_keyId];
    
    [AFUtils GET:string controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        _model = [PropKeyModel modelWithDict:successfuldict Model:_model];
        [_tableView reloadData];
        
    } failureDict:^(NSDictionary *failuredict) {
        
    } failureError:^(NSError *failureerror) {
        
    }];
    
}

- (void)TableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *reuseID = @"propSituation";
        PropSituationKeyCell *propSituation = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!propSituation) {
            propSituation = [[PropSituationKeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            propSituation.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        propSituation.indexPath = indexPath;
        propSituation.model = _model;
        return propSituation;
    }
    else if (_model.propertyKeyStatus == 2 && indexPath.row == 1) {
        static NSString *reuseID = @"propSituation1";
        PropSituationKeyCell *propSituation1 = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!propSituation1) {
            propSituation1 = [[PropSituationKeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            propSituation1.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        propSituation1.indexPath = indexPath;
        propSituation1.model = _model;
        return propSituation1;
    }
    else if ((_model.propertyKeyStatus == 2 && indexPath.row == 2) || (_model.propertyKeyStatus == 3 && indexPath.row == 1)) {
        FollowUpContentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell2) {
            [tableView registerNib:[UINib nibWithNibName:@"FollowUpContentCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
            cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell2.rightInputTextView.text = _model.remark;
        cell2.rightInputTextView.delegate = self;
        cell2.contentDescriptionLabel.text = @"钥匙说明";
        cell2.contentDescriptionLabel.textColor = [UIColor blackColor];
        [cell2.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];
        
        return  cell2;
    }
    
    return nil;
}


// 返回每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.propertyKeyStatus == 1) {
        return 1;
    }
    else if (_model.propertyKeyStatus == 2) {
        return 3;
    }
    else if (_model.propertyKeyStatus == 3) {
        return 2;
    }
    return 0;
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 50*NewRatio;
    }
    else if (_model.propertyKeyStatus == 2 && indexPath.row == 1) {
        return 50*NewRatio;
    }
    else if ((_model.propertyKeyStatus == 2 && indexPath.row == 2) || (_model.propertyKeyStatus == 3 && indexPath.row == 1)) {
        return 280*NewRatio;
    }
    return 0;
}

// cell 回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self clickAddRemindPersonMethod];
        
    }
    else if (indexPath.row == 1 && _model.propertyKeyStatus == 2) {
        // 跳转到搜索
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] initWithNibName:@"SearchRemindPersonViewController" bundle:nil];
        searchRemindPersonVC.selectRemindType = 1;
        searchRemindPersonVC.selectRemindTypeStr = PersonRemindType;
        searchRemindPersonVC.isExceptMe = nil;
        searchRemindPersonVC.selectedRemindPerson = nil;
        searchRemindPersonVC.delegate = self;
        searchRemindPersonVC.isPropKeyVC = YES;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
        
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView  {
//    // 隐藏键盘
//    [self.view endEditing:YES];
//}


#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem {
    _model.receiverKeyId = selectRemindItem.resultKeyId;
    _model.receiver = selectRemindItem.resultName;
    _model.departmentKeyId = selectRemindItem.departmentKeyId;
    
    [_tableView reloadData];
}

- (void)returnText:(NSString *)text {
    _model.receiverKeyId = nil;
    _model.receiver = text;
    
    [_tableView reloadData];
}

#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    _appendContent = _model.remark;
    
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
    
    NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
    NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData options:NSJSONReadingAllowFragments error:&error];
    
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
    }
    _model.remark = _appendContent;
    [_tableView reloadData];
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

//选中textView 或者输入内容的时候调用的方法
- (void)textViewDidChangeSelection:(UITextView *)textView {
    _model.remark = textView.text;
}
//从键盘上将要输入到textView的时候调用的方法
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


// 选择器
- (void)clickAddRemindPersonMethod {
    
    NSArray * listArr = @[@"无",@"在店",@"同行"];
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        switch (optionValue) {
            case 0: {
                // 无
                _model.propertyKeyStatus = 1;
                _model.remark = nil;
                [_tableView reloadData];
                return;
            }
                break;
            case 1: {
                // 在店
                _model.propertyKeyStatus = 2;
                [_tableView reloadData];
                return;
            }
                break;
            case 2: {
                // 同行
                _model.propertyKeyStatus = 3;
                [_tableView reloadData];
                return;
            }
                break;
            default: {
                return;
            }
                break;
        }
        
        
    }];
    
}



// 提交
- (void)commitNewOpening {
    
//    if (_model.propertyKeyStatus == 2) {
//        if (_model.receiverKeyId.length == 0) {
//            showMsg(@"请从智能提示中选择收钥匙人！");
//            return;
//        }
//        if (_model.remark.length == 0) {
//            showMsg(@"请填写备注！");
//            return;
//        }
//    }
//
//    if (_model.propertyKeyStatus == 3) {
//
//        //判断输入内容是否全是空格
//        BOOL isEmpty = [NSString isEmptyWithLineSpace:_model.remark];
//        if (_model.remark.length == 0 || isEmpty) {
//            showMsg(@"请填写备注！");
//            return;
//        }else {
//            //去掉两端的空格
//            NSString *trimedString = [_model.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            _model.remark = trimedString;
//        }
//    }
    
    if (_model.propertyKeyStatus == 3 || _model.propertyKeyStatus == 2) {
        
        //去掉两端的空格
        NSString *trimedString = [_model.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _model.remark = trimedString;
    }
    
    [self.view endEditing:YES];
    [AFUtils PUT:AipPropertykeyModify parameters:[PropKeyModel dictWithModel:_model] controller:self successfulDict:^(NSDictionary *successfuldict) {
        self.theRefreshata();
        [self.navigationController popViewControllerAnimated:YES];
    } failureDict:^(NSDictionary *failuredict) {
    } failureError:^(NSError *failureerror) {
    }];
    
}

- (void)back {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃本次提交?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
        if (value.integerValue == 0) {
        }
        else if(value.integerValue == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}


@end
