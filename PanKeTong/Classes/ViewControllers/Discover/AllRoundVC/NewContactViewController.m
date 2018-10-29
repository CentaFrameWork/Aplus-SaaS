//
//  NewContactViewController.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NewContactViewController.h"
#import "ReactiveCocoa.h"
#import "NewContactTypeCell.h"          // 联系人类型、联系人称谓、婚姻情况
#import "NewContactNamePhoneCell.h"     // 姓名、手机号
#import "NewContactLandlineCell.h"      // 座机
#import "NewContactInformationCell.h"   // 联系人信息
#import "NoteTableViewCell.h"         // 输入
#import <iflyMSC/iflyMSC.h>             //语音的
#import "CustomActionSheet.h"
#import "NewContactApi.h"               // 接口和数据
#import "NewContactModel.h"

@interface NewContactViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,IFlyRecognizerViewDelegate,doneSelect>
{
    
    IFlyRecognizerView  *_iflyRecognizerView;       //语音输入
    NSString *_appendContent;                       // 信息补充内容
}
@property (nonatomic, strong)UITableView *tableView;        // tableview
@property (nonatomic, strong)NSMutableArray *dataArray;     // 填写数据数组
@property (nonatomic, strong)NSArray *typeArray;            // 类型
@property (nonatomic, strong)NSArray *appellationArray;     // 称谓
@property (nonatomic, strong)NSArray *marriageArray;        // 婚姻情况
@property (nonatomic, assign)NSInteger tagValue;                  // 用来判断是哪个cell的语音输入
@property (nonatomic, assign)BOOL editPhoneNumber;          // 是否编辑过手机号
@property (nonatomic, assign)BOOL editLineNumber;           // 是否编辑过座机号

@property (nonatomic, strong)NewContactModel *isModifyModel;        // 用来判断是否修改

@end

@implementation NewContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    
    if (_isEditor) {
        [self setNavTitle:@"编辑联系人"
           leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"提交" backgroundImage:nil foreground:nil sel:@selector(commitNewOpening)]];
    }else {
        [self setNavTitle:@"新增联系人"
           leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:[self customBarItemButton:@"提交" backgroundImage:nil foreground:nil sel:@selector(commitNewOpening)]];
    }
    
    
    /*
     *添加textView监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
    [self initData];
    [self TableView];
    
}

- (void)initData {
    [self.view endEditing:YES];
   
    
    // 联系人类型
    SysParamItemEntity *genderSysParamItemEntity1 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TYPE];
    _typeArray = genderSysParamItemEntity1.itemList;
    // 性别
    SysParamItemEntity *genderSysParamItemEntity2 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    _appellationArray = genderSysParamItemEntity2.itemList;
    // 婚姻情况
    SysParamItemEntity *genderSysParamItemEntity3 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_MARRIAGE_STATUS];
    _marriageArray = genderSysParamItemEntity3.itemList;
    
    NewContactModel *model = [[NewContactModel alloc] init];
    _dataArray = [[NSMutableArray alloc] initWithObjects:model,nil];  // 默认有一组数据
    if (_isEditor) {
        [self editorInitData];
    }
}

- (void)editorInitData {
    
    NSDictionary *dict = @{
                           @"PropertyKeyId":_propertyKeyId,
                           @"KeyId":_keyId,
                           };
    
    
    [AFUtils GET:AipPropertyTrustorDetail parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        NSLog(@"successfuldictsuccessfuldict:%@",successfuldict);
        NewContactModel *model = [NewContactModel modelWithDict:successfuldict keyId:_keyId];
        _isModifyModel = [NewContactModel modelWithDict:successfuldict keyId:_keyId];
        _dataArray = nil;
        _dataArray = [[NSMutableArray alloc] initWithObjects:model,nil];
        [_tableView reloadData];
        
    } failureDict:^(NSDictionary *failuredict) {
         [self.navigationController popViewControllerAnimated:YES];
    } failureError:^(NSError *failureerror) {
          [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (void)TableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight-APP_NAV_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        // 联系人类型、联系人称谓、婚姻情况
        static NSString *reuseID = @"newContactTypeCell";
        NewContactTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NewContactTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.typeArray = _typeArray;
        cell.appellationArray = _appellationArray;
        cell.marriageArray = _marriageArray;
        cell.model = _dataArray[indexPath.section];
        return cell;
    }
    else if (indexPath.row == 1 || indexPath.row == 5) {
        // 姓名、手机号
        static NSString *reuseID = @"newContactNamePhoneCell";
        NewContactNamePhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NewContactNamePhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.isEditor = _isEditor;
        cell.editPhoneNumber = _editPhoneNumber;          // 是否编辑过手机号
        [cell.nameTextField addTarget:self action:@selector(inputLenth1:) forControlEvents:UIControlEventAllEvents];
        cell.model = _dataArray[indexPath.section];

        
        // 没有编辑权限的不能编辑手机和座机
        if (_isEditor && indexPath.row == 5) {
            if([AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_MODIFY_ALL]) {
                cell.nameTextField.enabled = YES;
            }else {
                cell.nameTextField.enabled = NO;
                cell.nameTextField.textColor = YCTextColorAuxiliary;
            }
        }else {
            cell.nameTextField.enabled = YES;
        }
        
        return cell;
    }
    else if (indexPath.row == 4) {
        // 联系人信息
        static NSString *reuseID = @"newContactInformationCell";
        NewContactInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NewContactInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (indexPath.row == 6) {
        // 座机cell
        static NSString *reuseID = @"newContactLandlineCell";
        NewContactLandlineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell = [[NewContactLandlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.indexPath = indexPath;
        cell.isEditor = _isEditor;
        cell.editLineNumber = _editLineNumber;           // 是否编辑过座机号
        cell.model = _dataArray[indexPath.section];
        [cell.areaCodeTextField addTarget:self action:@selector(inputLenth2:) forControlEvents:UIControlEventAllEvents];
        [cell.phoneTextField addTarget:self action:@selector(inputLenth3:) forControlEvents:UIControlEventAllEvents];
        [cell.extensionTextField addTarget:self action:@selector(inputLenth4:) forControlEvents:UIControlEventAllEvents];
        
        if (_isEditor) {
            if([AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_MODIFY_ALL]) {
                cell.areaCodeTextField.enabled = YES;
                cell.phoneTextField.enabled = YES;
                cell.extensionTextField.enabled = YES;
            }else {
                cell.areaCodeTextField.enabled = NO;
                cell.phoneTextField.enabled = NO;
                cell.extensionTextField.enabled = NO;
                cell.areaCodeTextField.textColor = YCTextColorAuxiliary;
                cell.phoneTextField.textColor = YCTextColorAuxiliary;
                cell.extensionTextField.textColor = YCTextColorAuxiliary;
            }
        }else {
            cell.areaCodeTextField.enabled = YES;
            cell.phoneTextField.enabled = YES;
            cell.extensionTextField.enabled = YES;
        }
        
        return cell;
    }
    else if (indexPath.row == 7) {
        // 备注
        NoteTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell2) {
            [tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
            cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell2.indexPath = indexPath;
        cell2.model = _dataArray[indexPath.section];
        cell2.rightInputTextView.delegate = self;
        cell2.voiceInputBtn.tag = indexPath.section;
        cell2.rightInputTextView.tag = indexPath.section;
        [cell2.voiceInputBtn addTarget:self action:@selector(voiceInputMethod:) forControlEvents:UIControlEventTouchUpInside];
        cell2.contentDescriptionLabel.text = @"备注";
        cell2.contentDescriptionLabel.textColor = YCTextColorGray;
        cell2.contentDescriptionLabel.font = [UIFont systemFontOfSize:14*NewRatio];
        return  cell2;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

// 返回有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return 218*NewRatio;
    }
    else if (indexPath.row == 4) {
        return 32*NewRatio;
    }
    return 48*NewRatio;
}

// 设置sectionHeader的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_isEditor) {
            return 6*NewRatio;
        }else {
            return 54*NewRatio;
        }
    }
    
    return 6*NewRatio;
}

// 设置sectionFooter的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_dataArray.count == 1) {
        return 0.01;
    }
    else {
        return 63*NewRatio;
    }
    
}

// 自定义每组的头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH-152*NewRatio, 12*NewRatio, 140*NewRatio, 36*NewRatio)];
    button.backgroundColor = YCThemeColorGreen;
    button.layer.cornerRadius = 5*NewRatio;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(headerBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    button.tag = section;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(21*NewRatio, 11*NewRatio, 14*NewRatio, 14*NewRatio)];
    imageView.image = [UIImage imageNamed:@"新增"];
    [button addSubview:imageView];
    
    UILabel *labelStr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+13*NewRatio, 0, 80*NewRatio, 36*NewRatio)];
    labelStr.text = @"新增联系人";
    labelStr.textColor = [UIColor whiteColor];
    labelStr.font = [UIFont systemFontOfSize:14*NewRatio];
    [button addSubview:labelStr];
    
    
//    if (section == 0) {
//        return view;
//    }
    return view;
}
- (void)headerBtnEvent:(UIButton *)button {
    if (_dataArray.count < 5) {
        [_dataArray addObject: [[NewContactModel alloc] init]];
        [_tableView reloadData];
        [_tableView layoutIfNeeded];
        [self scrollTableToFoot];
    }else {
        showMsg(@"最多添加5个联系人！")
    }
}

// 自定义每组的尾
-(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH-72*NewRatio, 1*NewRatio, 60*NewRatio, 50*NewRatio)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;    // 内容居右
    [button setTitle:@"删除" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [button setTitleColor:UICOLOR_RGB_Alpha(0xe87475, 1.0) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    button.tag = section;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UICOLOR_RGB_Alpha(0xf4f4f4, 1.0);
    [view addSubview:lineView];
    
    UIView *bigLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 51*NewRatio, APP_SCREEN_WIDTH, 12*NewRatio)];
    bigLineView.backgroundColor = UICOLOR_RGB_Alpha(0xf4f4f4, 1.0);
    [view addSubview:bigLineView];
    
    if (_dataArray.count == 1) {
        return nil;
    }
    return view;
}
- (void)footerBtnEvent:(UIButton *)button {
    if (_dataArray.count >1) {
        [_dataArray removeObjectAtIndex:button.tag];
        [_tableView reloadData];
    }
}


// cell 回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 隐藏键盘
    [self resignFirstResponderEven];
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        [self TheSelector:indexPath];
    }
}

// 手机号输入
- (void)inputLenth1:(NewContactNameTextField *)input {
    
    NewContactModel *model = _dataArray[input.indexPath.section];
    if (input.indexPath.row == 1) {
        model.name = input.text;
    }
    else if (input.indexPath.row == 5) {
        if (_isEditor) {
            // 编辑
            [self editContactPersonNumber:input];
        }else {
            // 新增
            [self newContactNumber:input];
        }
    }
}

// 新增手机号
- (void)newContactNumber:(NewContactNameTextField *)input {
    NewContactModel *model = _dataArray[input.indexPath.section];
    if (input.text.length <= 11 && isPureInt(input.text)) {
        model.mobilePhone = input.text;
    }else {
        input.text = model.mobilePhone;
    }
}
// 编辑手机号
- (void)editContactPersonNumber:(NewContactNameTextField *)input {
    
    NewContactModel *model = _dataArray[input.indexPath.section];
    // 直接清空
    if (input.text.length == 0) {
        _editPhoneNumber = YES;          // 是否编辑过手机号
        return;
    }
    // 如果小于等于11位并且包含四个*，那么应该还是加四个*的手机号
    if (input.text.length >= 11 && !([input.text rangeOfString:@"****"].location == NSNotFound)) {
        NSMutableString *muStr = [[NSMutableString alloc] initWithFormat:@"%@",model.mobilePhone];
        [muStr replaceCharactersInRange:(NSRange){3,4} withString:@"****"];
        input.text = muStr;
        return;
    }
    // 如果小于11位并且包含三个星星，清空
    if (input.text.length < 11 && !([input.text rangeOfString:@"***"].location == NSNotFound)) {
        model.mobilePhone = @"";
        input.text = @"";
        _editPhoneNumber = YES;          // 是否编辑过手机号
        return;
    }
    // 如果小于等于11位，判断是不是数字，和新增一样
    if (input.text.length <= 11 && isPureInt(input.text)) {
        model.mobilePhone = input.text;
    }else {
        input.text = model.mobilePhone;
    }
}

- (void)inputLenth2:(NewContactAreaCodeTextField *)input {
    NewContactModel *model = _dataArray[input.indexPath.section];
    if (input.text.length <= 4 && isPureInt(input.text)) {
        model.areaCode = input.text;
    }else {
        input.text = model.areaCode;
    }
}
// 座机号输入
- (void)inputLenth3:(NewContactPhoneTextField *)input {
    if (_isEditor) {
        // 编辑
        [self editTheContactNumber:input];
    }else {
        // 新增
        [self newContactLineNumber:input];
    }
}
// 新增联系人座机号
- (void)newContactLineNumber:(NewContactPhoneTextField *)input {
    NewContactModel *model = _dataArray[input.indexPath.section];
    if (input.text.length <= 8 && isPureInt(input.text)) {
        model.phone = input.text;
    }else {
        input.text = model.phone;
    }
}
// 编辑联系人座机号
- (void)editTheContactNumber:(NewContactPhoneTextField *)input {
    NewContactModel *model = _dataArray[input.indexPath.section];
    // 直接清空的情况
    if (input.text.length == 0) {
        _editLineNumber = YES;          // 是否编辑过手机号
        return;
    }
    // 如果小于等于8或7位并且包含四个*，那么应该还是加四个*的手机号
    if (input.text.length >= model.phone.length && !([input.text rangeOfString:@"****"].location == NSNotFound)) {
        NSMutableString *muStr = [[NSMutableString alloc] initWithFormat:@"%@",model.phone];
        [muStr replaceCharactersInRange:(NSRange){2,4} withString:@"****"];
        input.text = muStr;
        return;
    }
    // 如果小于7或8位并且包含三个星星，清空
    if (input.text.length < model.phone.length && !([input.text rangeOfString:@"***"].location == NSNotFound)) {
        model.phone = @"";
        input.text = @"";
        _editLineNumber = YES;          // 是否编辑过手机号
        return;
    }
    // 如果小于等于8位，判断是不是数字，和新增一样
    if (input.text.length <= 8 && isPureInt(input.text)) {
        model.phone = input.text;
    }else {
        input.text = model.phone;
    }
    
}

- (void)inputLenth4:(NewContactExtensionTextField *)input {
    NewContactModel *model = _dataArray[input.indexPath.section];
    if (input.text.length <= 6 && isPureInt(input.text)) {
        model.extension = input.text;
    }else {
        input.text = model.extension;
    }
}

#pragma mark - <VoiceInputMethod>
- (void)voiceInputMethod:(UIButton *)button
{
    [self.view endEditing:YES];
    
    __weak typeof (self) weakSelf = self;
    
    _tagValue = button.tag;
    NewContactModel *model = _dataArray[_tagValue];
    _appendContent = model.note;
    
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
    NewContactModel *model = _dataArray[_tagValue];
    model.note = _appendContent;
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
    NewContactModel *model = _dataArray[textView.tag];
    model.note = textView.text;
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
- (void)TheSelector:(NSIndexPath*)indexPath {
    
    NewContactModel *model = _dataArray[indexPath.section];
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    
    if (indexPath.row == 0) {
        for (int i=0; i<_typeArray.count; i++) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_typeArray[i];
            [muArray addObject:itemDto.itemText];
        }
        [NewUtils popoverSelectorTitle:@"联系人类型" listArray:muArray theOption:^(NSInteger optionValue) {
            model.typeSelector = [NSString stringWithFormat:@"%ld",optionValue];
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_typeArray[optionValue];
            model.typeSelectorKeyId = itemDto.itemValue;
            [_tableView reloadData];
        }];
    }
    else if (indexPath.row == 2) {
        for (int i=0; i<_appellationArray.count; i++) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_appellationArray[i];
            [muArray addObject:itemDto.itemText];
        }
        [NewUtils popoverSelectorTitle:@"联系人称谓" listArray:muArray theOption:^(NSInteger optionValue) {
            model.appellationSelector = [NSString stringWithFormat:@"%ld",optionValue];
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_appellationArray[optionValue];
            model.appellationSelectorKeyId = itemDto.itemValue;
            [_tableView reloadData];
        }];
    }
    else if (indexPath.row == 3) {
        for (int i=0; i<_marriageArray.count; i++) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_marriageArray[i];
            [muArray addObject:itemDto.itemText];
        }
        [NewUtils popoverSelectorTitle:@"婚姻情况" listArray:muArray theOption:^(NSInteger optionValue) {
            model.marriageSelector = [NSString stringWithFormat:@"%ld",optionValue];
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_marriageArray[optionValue];
            model.marriageSelectorKeyId = itemDto.itemValue;
            [_tableView reloadData];
        }];
    }
    
}

#pragma mark  - 滑到最底部
- (void)scrollTableToFoot
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES]; //滚动到最后一行
}

// 解决tableView分割线不到头的问题
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)back {
    
    if (_isEditor) {
        // 编辑
        NewContactModel *model = _dataArray[0];
        if (!([[NSString stringWithFormat:@"%@", model.typeSelector] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.typeSelector]] &&
              [[NSString stringWithFormat:@"%@", model.typeSelectorKeyId] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.typeSelectorKeyId]] &&
              [[NSString stringWithFormat:@"%@", model.name] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.name]] &&
              [[NSString stringWithFormat:@"%@", model.appellationSelector] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.appellationSelector]] &&
              [[NSString stringWithFormat:@"%@", model.appellationSelectorKeyId] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.appellationSelectorKeyId]] &&
              [[NSString stringWithFormat:@"%@", model.marriageSelector] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.marriageSelector]] &&
              [[NSString stringWithFormat:@"%@", model.marriageSelectorKeyId] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.marriageSelectorKeyId]] &&
              [[NSString stringWithFormat:@"%@", model.mobilePhone] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.mobilePhone]] &&
              [[NSString stringWithFormat:@"%@", model.areaCode] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.areaCode]] &&
              [[NSString stringWithFormat:@"%@", model.phone] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.phone]] &&
              [[NSString stringWithFormat:@"%@", model.extension] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.extension]] &&
              [[NSString stringWithFormat:@"%@", model.note] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.note]] &&
              [[NSString stringWithFormat:@"%@", model.keyId] isEqualToString:[NSString stringWithFormat:@"%@", _isModifyModel.keyId]])) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃编辑联系人?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
                if (value.integerValue == 0) {
                }
                else if(value.integerValue == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else {
        // 新增
        BOOL isModify = NO;
        for (int i=0; i<_dataArray.count; i++) {
            NewContactModel *model = _dataArray[i];
            if (!((model.typeSelector == nil || model.typeSelector.length == 0) &&
                  (model.typeSelectorKeyId == nil || model.typeSelectorKeyId.length == 0)&&
                  (model.name == nil || model.name.length == 0)&&
                  (model.appellationSelector == nil || model.appellationSelector.length == 0)&&
                  (model.appellationSelectorKeyId == nil || model.appellationSelectorKeyId.length == 0)&&
                  (model.marriageSelector == nil || model.marriageSelector.length == 0)&&
                  (model.marriageSelectorKeyId == nil || model.marriageSelectorKeyId.length == 0)&&
                  (model.mobilePhone == nil || model.mobilePhone.length == 0)&&
                  (model.areaCode == nil || model.areaCode.length == 0)&&
                  (model.phone == nil || model.phone.length == 0)&&
                  (model.extension == nil || model.extension.length == 0)&&
                  (model.note == nil || model.note.length == 0)&&
                  (model.keyId == nil || model.keyId.length == 0))) {
                isModify = YES;
            }
        }
        if (isModify) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否放弃新增联系人?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *value) {
                if (value.integerValue == 0) {
                }
                else if(value.integerValue == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

// 隐藏键盘
- (void)resignFirstResponderEven {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


// 提交
- (void)commitNewOpening {
    
    
    
    /*
     typeSelector           // 联系人类型
     name                   // 姓名
     appellationSelector    // 联系人称谓
     marriageSelector       // 婚姻情况
     mobilePhone            // 手机号
     areaCode               // 区号
     phone                  // 电话
     extension              // 分机
     note
     */
    
    for (int i = 0; i<_dataArray.count; i++) {
        NewContactModel *model = _dataArray[i];
        if (model.typeSelector == nil) {
            showMsg(@"请选择联系人类型");
            return;
        }
        if (model.name == nil || model.name.length == 0) {
            showMsg(@"请输入姓名");
            return;
        }else if ([NSString isEmptyWithLineSpace:model.name]) {
            // 判断是否全是空格
            showMsg(@"姓名输入有误");
            return;
        }else {
            if (model.name.length > 8) {
                showMsg(@"姓名最多输入8位！");
                return;
            }
        }
        if (model.appellationSelector == nil) {
            showMsg(@"请选择联系人称谓");
            return;
        }
        if (model.marriageSelector == nil) {
            showMsg(@"请选择婚姻情况");
            return;
        }
        if (model.mobilePhone == nil || model.mobilePhone.length == 0) {
            if ((model.phone == nil || model.phone.length == 0) && (model.areaCode == nil || model.areaCode.length == 0) && (model.extension == nil || model.extension.length == 0)) {
                showMsg(@"手机号和座机号至少填写一个");
                return;
            }
            else if ((model.phone == nil || model.phone.length == 0) || (model.areaCode == nil || model.areaCode.length == 0)) {
                showMsg(@"区号和座机号不能为空");
                return;
            }
            else {
                // 填了座机 判断合法不合法
//                if (model.phone.length >= 8 || model.phone.length ==0) {
//                    showMsg(@"请输入正确的座机号!");
//                    return;
//                }
//                if (model.areaCode.length >= 6 || model.areaCode.length ==0) {
//                    showMsg(@"请输入正确的区号!");
//                    return;
//                }
            }
        }else {
            
            
            // 验证手机号
            if(![CommonMethod isMobile:model.mobilePhone]){
                showMsg(@"请输入正确的手机号码！");
                return;
            }
          
            if ((model.phone == nil || model.phone.length == 0) && (model.areaCode == nil || model.areaCode.length == 0) && (model.extension == nil || model.extension.length == 0)) {
                
            }else {
                // 填了座机 判断合法不合法
                if ((model.phone == nil || model.phone.length == 0) || (model.areaCode == nil || model.areaCode.length == 0)) {
                    showMsg(@"区号和座机号不能为空");
                    return;
                }
            }
        }
        
        //去掉两端的空格   //判断输入内容是否全是空格  // 非必填项
        NSString *trimedString = [_appendContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        BOOL isEmpty = [NSString isEmptyWithLineSpace:_appendContent];
        if (isEmpty) {
            trimedString = nil;
        }
    }
    
    // 隐藏键盘
    [self resignFirstResponderEven];
    
    
    if (_isEditor) {
     
        
//        // 编辑
//        [AFUtils POST:AipPropertyEditTrustor parameters:[NewContactModel dictWithArray:_dataArray propertyKeyId:_propertyKeyId] controller:self successfulDict:^(NSDictionary *successfuldict) {
//           
//        } failureDict:^(NSDictionary *failuredict) {
//        } failureError:^(NSError *failureerror) {
//        }];
        
        // 编辑
        [AFUtils PUT:AipPropertyEditTrustor parameters:[NewContactModel dictWithArray:_dataArray propertyKeyId:_propertyKeyId] controller:self successfulDict:^(NSDictionary *successfuldict) {
            _theRefresh();
            showMsg(@"编辑成功");
            [self.navigationController popViewControllerAnimated:YES];
        } failureDict:^(NSDictionary *failuredict) {
            
        } failureError:^(NSError *failureerror) {
            
        }];
        
    } else {
        // 新增
        [AFUtils POST:AipPropertyCreateTrustor parameters:[NewContactModel dictWithArray:_dataArray propertyKeyId:_propertyKeyId] controller:self successfulDict:^(NSDictionary *successfuldict) {
            _theRefresh();
            showMsg(@"提交成功");
            [self.navigationController popViewControllerAnimated:YES];
        } failureDict:^(NSDictionary *failuredict) {
        } failureError:^(NSError *failureerror) {
        }];
    }
    
}

@end
