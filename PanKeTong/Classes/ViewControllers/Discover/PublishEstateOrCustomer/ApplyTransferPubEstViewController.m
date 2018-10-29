//
//  ApplyTransferPubEstViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ApplyTransferPubEstViewController.h"
#import "ApplyTransferPubEstRemindPersonCell.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "ApplyTransferEstSelectItemCell.h"
#import "ApplyTransferEstInputItemCell.h"
#import "ApplyReasonInputCell.h"
#import "SearchRemindPersonViewController.h"
#import "CustomActionSheet.h"
#import "AddPropertyFollowApi.h"
#import "AgencyBaseEntity.h"
#import "FollowTypeDefine.h"
#import <iflyMSC/iflyMSC.h>
#import "DateTimePickerDialog.h"
#import "OpeningPersonCell.h"


#import "ApplyTransferPubEstZJPresenter.h"


#define DeleteRemindPersonBtnTag        10000   // 删除按钮baseTag
#define AddRemindPersonActionTag        20001   // 点击提醒人后Actionsheet
#define ContactPersonNameInputTag       20005   // 联系人姓名inputTag
#define ContactPersonPhoneInputTag      20006   // 联系人手机inputTag
#define ApplyReasonInputTag             20007   // 申请理由inputTag
#define SubmitApplyAlertTag             20008   // 申请转盘成功的alerttag
#define ReminderTime                    20009   // 提醒时间

@interface ApplyTransferPubEstViewController ()<UITableViewDataSource, UITableViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
SearchRemindPersonDelegate,
UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,UITextFieldDelegate,UITextViewDelegate,
UIAlertViewDelegate,IFlyRecognizerViewDelegate,DateTimeSelected>
{
    __weak IBOutlet UITableView *_mainTableView;
    
    UICollectionView *_remindPersonCollectionView;      // 提醒人collectionView
    UIPickerView *_selectItemPickerView;                // 选择类型
    
    NSMutableArray *_remindPersonsArr;                  // 选择的提醒人
    NSMutableArray *_estStatusArr;                      // 楼盘状态
    NSMutableArray *_contactTypeArr;                    // 联系人类型
    NSMutableArray *_contactSexArr;                     // 联系人性别
    
    NSMutableArray *_listTitleArray;                    // 列表显示用到的数组
    
    SelectItemDtoEntity *_selectEstStatus;              // 选择的状态
    SelectItemDtoEntity *_selectContactType;            // 选择的联系人类型
    SelectItemDtoEntity *_selectContactSex;             // 选择的联系人性别


    IFlyRecognizerView  *_iflyRecognizerView;           // 语音输入
    
    NSInteger _selectListIndex;                         // 选择了列表中的index
    NSInteger _selectResultIndex;                       // 选择筛选结果中的index
    
    
    // 用来再次点击的时候默认选择之前选择的那一项
    
    NSInteger _selectEstStatusIndex;                    // 楼盘状态选择过的index
    NSInteger _selectContactTypeIndex;                  // 联系人类型选择过的index
    NSInteger _selectContactSexIndex;                   // 联系人性别选择过的index
    
    NSString *_contactPersonName;                       // 联系人姓名
    NSString *_contactPersonPhone;                      // 联系人手机号
    NSString *_applyReason;                             // 申请理由
    
    UILabel *_applyReasonPlaceholderLabel;              // 申请理由placeholder
    
    BOOL _isNowSubmit;                                  // 是否正在提交跟进（防止多次点击）
    NSString *_msgTime;                                 // 提醒时间
    NSDate *_selectedDate;
    NSDate *_oldTime;
    
    ApplyTransferPubEstBasePresenter *_applyTransferPresenter;
}

@property (nonatomic,readwrite,strong)DateTimePickerDialog *dateTimePickerDialog;

@end

@implementation ApplyTransferPubEstViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"申请转盘"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submitApplyMethod)]];
    [_mainTableView registerNib:[UINib nibWithNibName:@"ApplyTransferPubEstRemindPersonCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"applyTransferPubEstRemindPersonCell"];

    // 添加textfield、textView监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textfieldChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
    [self initPresenter];
    [self initView];
    [self initData];
}

#pragma mark - init

- (void)initPresenter
{
   
        _applyTransferPresenter = [[ApplyTransferPubEstZJPresenter alloc] initWithDelegate:self];
    
}

- (void)initView
{
    [_mainTableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];
}

- (void)initData
{
    _remindPersonsArr = [[NSMutableArray alloc] init];
    _listTitleArray = [[NSMutableArray alloc] init];
    
    _isNowSubmit = NO;

    SysParamItemEntity *estStatuSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_STATUS];
    SysParamItemEntity *contactTypeSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_CONTACT_TYPE];
    SysParamItemEntity *contactSexSysparamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    
    _estStatusArr = [[NSMutableArray alloc] initWithArray:estStatuSysParamItemEntity.itemList];
    _contactTypeArr = [[NSMutableArray alloc] initWithArray:contactTypeSysParamItemEntity.itemList];
    _contactSexArr = [[NSMutableArray alloc] initWithArray:contactSexSysparamItemEntity.itemList];
}

#pragma mark - <SubmitApplyMethod>

- (void)submitApplyMethod
{
    [self.view endEditing:YES];
    
    // 正在提交中，不再重复提交
    if (_isNowSubmit)
    {
        return;
    }

    // 去掉两端的空格
    NSString *trimedString = [_applyReason stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_applyReason];
    if (!_applyReason ||
        [_applyReason isEqualToString:@""] || isEmpty)
    {
        showMsg(@"请输入申请理由!");
        
        return;
    }

    // 判断联系人类型、姓名、手机号是否全部都输入了，不然不让提交
    if (_selectContactType||
        (![_contactPersonName isEqualToString:@""] &&
         _contactPersonName) ||
        (_contactPersonPhone &&
         ![_contactPersonPhone isEqualToString:@""])||
        _selectContactSex )
    {
        if (!_selectContactType.itemValue)
        {
            showMsg(@"请选择联系人类型!");
            
            return;
        }
        
        BOOL isEmptyPersonName = [NSString isEmptyWithLineSpace:_contactPersonName];
        if ([_contactPersonName isEqualToString:@""] ||
            !_contactPersonName || isEmptyPersonName)
        {
            showMsg(@"请输入联系人姓名!");
            return;
        }
        
        if ([_contactPersonPhone isEqualToString:@""] ||
            !_contactPersonPhone)
        {
            showMsg(@"请输入联系人电话!");
            return;
        }
        
        if (!_selectContactSex.itemValue)
        {
            showMsg(@"请输入联系人性别");
            return;
        }
        
        if (![CommonMethod isMobile:_contactPersonPhone])
        {
            showMsg(@"请输入正确的手机号!");
            return;
            
        }
    }
    
    NSString *followTypeStr = [NSString stringWithFormat:@"%@",@(PropertyFollowTypeApplyTurnProperty)];
    
    NSMutableArray *contactsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *contactsKeyIdArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *informDepartsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *informDepartsKeyIdArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _remindPersonsArr.count; i++) {
        
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
    
    NSString *contactNameStr = [NSString stringWithFormat:@""];
    NSString *contactPhoneStr = [NSString stringWithFormat:@""];
    
    if (_contactPersonName &&
        ![_contactPersonName isEqualToString:@""])
    {
        contactNameStr = _contactPersonName;
    }
    
    if (_contactPersonPhone &&
        ![_contactPersonPhone isEqualToString:@""])
    {
        contactPhoneStr = _contactPersonPhone;
    }
    
    _isNowSubmit = YES;
    
    [self showLoadingView:@"提交中..."];

    AddPropertyFollowApi *addPropertyFollowApi = [[AddPropertyFollowApi alloc] init];
    addPropertyFollowApi.followType = followTypeStr;
    addPropertyFollowApi.contactsName = contactsNameArr;
    addPropertyFollowApi.informDepartsName = informDepartsNameArr;
    addPropertyFollowApi.followContent = trimedString;//
    addPropertyFollowApi.targetPropertyStatusKeyId = _selectEstStatus?_selectEstStatus.itemValue:@"";
    addPropertyFollowApi.trustorTypeKeyId = _selectContactType?_selectContactType.itemValue:@"";
    addPropertyFollowApi.trustorName = contactNameStr;
    addPropertyFollowApi.trustorGenderKeyId = _selectContactSex?_selectContactSex.itemValue:@"";
    addPropertyFollowApi.mobile = contactPhoneStr;
    addPropertyFollowApi.keyId = _propEstKeyId;
    addPropertyFollowApi.msgUserKeyIds = contactsNameArr;
    addPropertyFollowApi.msgDeptKeyIds = informDepartsKeyIdArr;
    addPropertyFollowApi.msgTime = _msgTime ? _msgTime : @"";
    [_manager sendRequest:addPropertyFollowApi];

}

#pragma mark - <AlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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

/// 添加提醒人
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
        searchRemindPersonVC.isExceptMe = [_applyTransferPresenter isExceptMe];
        searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
        searchRemindPersonVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:searchRemindPersonVC animated:YES];
        
    }];
    
//    BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:@"部门",@"人员", nil];
//    byActionSheetView.tag = AddRemindPersonActionTag;
//    [byActionSheetView show];
}

///  删除提醒人
- (void)deleteRemindPersonMethod:(UIButton *)button
{
    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
    
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight) withObject:nil afterDelay:0.1];
}

#pragma mark - PrivateMethod

- (void)reloadRemindCellHeight
{
    [_mainTableView reloadData];
}

#pragma mark - <InputViewTextChangeDelegate>

- (void)textfieldChangeInput:(NSNotification *)notification
{
    UITextField *inputTextfield = (UITextField *)notification.object;
    
    switch (inputTextfield.tag) {
        case ContactPersonNameInputTag:
        {
            // 联系人姓名（不超过20个文字）
            if (_contactPersonName.length <= 20 ||
                _contactPersonName.length > inputTextfield.text.length)
            {
                
                _contactPersonName = inputTextfield.text;
            }
            else
            {
                [_mainTableView reloadData];
                [CustomAlertMessage showAlertMessage:@"请输入不超过20个字的姓名\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
        }
            break;
        case ContactPersonPhoneInputTag:
        {
            // 联系人手机
            _contactPersonPhone = inputTextfield.text;
        }
            break;
            
        default:
            break;
    }
}

-(void)textViewChangeInput:(NSNotification *)notification
{
    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200)
    {
        NSString *subStr=[inputTextView.text substringToIndex:200];
        inputTextView.text = subStr;

    }
    else
    {
        _applyReason = inputTextView.text;
    }

    if (inputTextView.text && ![inputTextView.text isEqualToString:@""])
    {
        _applyReasonPlaceholderLabel.hidden = YES;
    }
    else
    {
        _applyReasonPlaceholderLabel.hidden = NO;
    }
}

#pragma mark - <UITextFieldDelegate/UITextViewDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == ContactPersonNameInputTag)
    {
        // 联系人姓名设置长度15
        if (range.length == 0 && range.location >= 19)
        {
            NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
            NSString * subStr = [inputString substringToIndex:20];
            textField.text = subStr;
            
            return NO;
        }
        
    }
    else if (textField.tag == ContactPersonPhoneInputTag)
    {
        // 联系人手机设置长度11
        if (range.length == 0 && range.location >= 11)
        {
            NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
            NSString *subStr = [inputString substringToIndex:11];
            textField.text = subStr;
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        return YES;
    }
    
    if (textView.text.length >= 200)
    {
        return NO;
    }
    
    if (range.length == 0 && range.location >= 200)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@", textView.text, text];
        NSString *subStr=[inputString substringToIndex:200];
        textView.text=subStr;
        
        return NO;
    }
    
    return YES;
}

//#pragma mark - <BYActionSheetViewDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex
//         andButtonTitle:(NSString *)buttonTitle
//{
//    if (alertView.tag == AddRemindPersonActionTag)
//    {
//        {
//            // 添加提醒人
//            SearchRemindType selectRemindType;
//            NSString *selectRemindTypeStr;
//
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
//
//            SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                                      initWithNibName:@"SearchRemindPersonViewController"
//                                                                      bundle:nil];
//            searchRemindPersonVC.selectRemindType = selectRemindType;
//            searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//            searchRemindPersonVC.isExceptMe = [_applyTransferPresenter isExceptMe];
//            searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
//            searchRemindPersonVC.delegate = self;
//            [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
//        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellNumber ;
    // 是否有提醒时间功能
    if ([_applyTransferPresenter haveReminderTimeFunction])
    {
        cellNumber = 8;
    }
    else
    {
        cellNumber = 7;
    }
    
    return cellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *remindPersonCellId = @"applyTransferPubEstRemindPersonCell";
    static NSString *inputItemCellId = @"applyTransferEstInputItemCell";
    static NSString *selectItemCellId = @"applyTransferEstSelectItemCell";
    static NSString *applyReasonInputCellId = @"applyReasonInputCell";
    NSString *openingPersonCellIdentifier = @"openingPersonCell";

//    ApplyTransferPubEstRemindPersonCell *remindPersonCell =[tableView dequeueReusableCellWithIdentifier:remindPersonCellId];
    ApplyTransferEstSelectItemCell *selectItemCell = [tableView dequeueReusableCellWithIdentifier:selectItemCellId];
    ApplyTransferEstInputItemCell *inputItemCell = [tableView dequeueReusableCellWithIdentifier:inputItemCellId];
    ApplyReasonInputCell *applyReasonInputCell = [tableView dequeueReusableCellWithIdentifier:applyReasonInputCellId];
    
    switch (indexPath.row) {
        case 0:
        {
            // 修改状态
            if (!selectItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstSelectItemCell" bundle:nil]
                forCellReuseIdentifier:selectItemCellId];
                selectItemCell = [tableView dequeueReusableCellWithIdentifier:selectItemCellId];
            }
            
            selectItemCell.leftTitleLabel.text = @"修改状态";
            
            if (_selectEstStatus.itemText &&
                ![_selectEstStatus.itemText isEqualToString:@""])
            {
                selectItemCell.rightValueLabel.text = _selectEstStatus.itemText;
            }
            else
            {
                selectItemCell.rightValueLabel.text = @"请选择状态";
            }
            
            return selectItemCell;
        }
            break;
            
        case 1:
        {
            // 联系人类型
            if (!selectItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstSelectItemCell"
                                                      bundle:nil]
                forCellReuseIdentifier:selectItemCellId];
                selectItemCell = [tableView dequeueReusableCellWithIdentifier:selectItemCellId];
            }
            selectItemCell.leftTitleLabel.text = @"联系人类型";
            
            if (_selectContactType.itemText &&
                ![_selectContactType.itemText isEqualToString:@""])
            {
                selectItemCell.rightValueLabel.text = _selectContactType.itemText;
            }
            else
            {
                selectItemCell.rightValueLabel.text = @"请选择联系人类型";
            }
            
            return selectItemCell;
        }
            break;
            
        case 2:
        {
            // 联系人姓名
            if (!inputItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstInputItemCell"
                                                      bundle:nil]
                forCellReuseIdentifier:inputItemCellId];
                
                inputItemCell = [tableView dequeueReusableCellWithIdentifier:inputItemCellId];
            }
            
            inputItemCell.leftTitleLabel.text = @"联系人姓名";
            inputItemCell.rightInputTextfield.placeholder = @"请输入联系人姓名";
            inputItemCell.rightInputTextfield.delegate = self;
            inputItemCell.rightInputTextfield.text = _contactPersonName;
            inputItemCell.rightInputTextfield.tag = ContactPersonNameInputTag;
            
            return inputItemCell;
        }
            break;
            
        case 3:
        {
            // 性别
            if (!selectItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstSelectItemCell"
                                                      bundle:nil]
                forCellReuseIdentifier:selectItemCellId];
                selectItemCell = [tableView dequeueReusableCellWithIdentifier:selectItemCellId];
            }
            
            selectItemCell.leftTitleLabel.text = @"性别";
            
            if (_selectContactSex.itemText &&
                ![_selectContactSex.itemText isEqualToString:@""])
            {
                selectItemCell.rightValueLabel.text = _selectContactSex.itemText;
            }
            else
            {
                selectItemCell.rightValueLabel.text = @"请选择联系人性别";
            }
            
            return selectItemCell;
        }
            break;
            
        case 4:
        {
            // 手机
            if (!inputItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstInputItemCell"
                                                      bundle:nil]
                forCellReuseIdentifier:inputItemCellId];
                
                inputItemCell = [tableView dequeueReusableCellWithIdentifier:inputItemCellId];
            }
            
            inputItemCell.leftTitleLabel.text = @"手机";
            inputItemCell.rightInputTextfield.placeholder = @"请输入联系人电话";
            inputItemCell.rightInputTextfield.delegate = self;
            inputItemCell.rightInputTextfield.keyboardType = UIKeyboardTypeNumberPad;
            inputItemCell.rightInputTextfield.text = _contactPersonPhone;
            inputItemCell.rightInputTextfield.tag = ContactPersonPhoneInputTag;
            
            return inputItemCell;
        }
            break;
            
        case 5:
        {
            // 申请理由
            if (!applyReasonInputCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyReasonInputCell"
                                                      bundle:nil]
                forCellReuseIdentifier:applyReasonInputCellId];
                applyReasonInputCell = [tableView dequeueReusableCellWithIdentifier:applyReasonInputCellId];
            }
            
            applyReasonInputCell.rightInputTextView.tag = ApplyReasonInputTag;
            applyReasonInputCell.rightInputTextView.text = _applyReason;
            applyReasonInputCell.rightInputTextView.delegate = self;
            [applyReasonInputCell.voiceInputBtn addTarget:self
                                                   action:@selector(voiceInputMethod)
                                         forControlEvents:UIControlEventTouchUpInside];
            
            _applyReasonPlaceholderLabel = applyReasonInputCell.placeholderLabel;
            
            if (_applyReason &&
                ![_applyReason isEqualToString:@""])
            {
                applyReasonInputCell.placeholderLabel.hidden = YES;
            }
            else
            {
                applyReasonInputCell.placeholderLabel.hidden = NO;
            }
            
            return applyReasonInputCell;
        }
            break;
            
        case 6:
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
            
        case 7:
        {
            // 提醒时间
            if (!selectItemCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstSelectItemCell"
                                                      bundle:nil]
                forCellReuseIdentifier:selectItemCellId];
                selectItemCell = [tableView dequeueReusableCellWithIdentifier:selectItemCellId];
            }
            
            selectItemCell.leftTitleLabel.text = @"提醒时间";
            
            if (_selectedDate)
            {
                [selectItemCell rightLabelWithString:_msgTime];
            }
            else
            {
                [selectItemCell rightLabelWithString:@"点击选择时间"];
            }
            
            return selectItemCell;
        }
            break;
            
        default:
            break;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectListIndex = indexPath.row;
    _selectResultIndex = 0;
    
    [_listTitleArray removeAllObjects];
    
    switch (indexPath.row) {
        case 0:
        {
            // 选择楼盘状态
            _estStatusArr = [_applyTransferPresenter getEstStatusArr:_estStatusArr];
            // 去除当前状态，目前仅天津
            _estStatusArr = [_applyTransferPresenter getChangedStatusArr:_estStatusArr CurrentStatus:self.propertyStatus];
            [_listTitleArray addObjectsFromArray:_estStatusArr];
            [self createPickerMethod];
        }
            break;
            
        case 1:
        {
            // 选择联系人类型
            [_listTitleArray addObjectsFromArray:_contactTypeArr];
            [self createPickerMethod];
        }
            break;
            
        case 3:
        {
            // 选择联系人状态
            [_listTitleArray addObjectsFromArray:_contactSexArr];
            [self createPickerMethod];
        }
            break;
            
        case 7:
        {
            // 提醒时间
            if (!_selectedDate)
            {
                _selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
            }
            self.dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                                     andDelegate:self
                                                                          andTag:@"start"];
            [self.dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 6:
        {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            if (remindPersonHeight > 50.0)
            {
                return remindPersonHeight+16.0;
            }
            
            return 80.0+16.0;
        }
            break;
            
        case 5:
        {
            // 申请理由
            return 115.0;
        }
            break;
            
        default:
            break;
    }
    
    return 44.0;
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

- (void)voiceInputMethod
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
 *  @ param isLast 表示是否最后一次结果
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
    
    for (int i = 0; i<vcnWSArray.count; i ++) {
        
        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
        
        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }
    
    
    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue)
    {
        _applyReason = [NSString stringWithFormat:@"%@%@",
                        _applyReason?_applyReason:@"",
                        vcnMutlResultValue];
        
        if (_applyReason.length > 200)
        {
            _applyReason = [_applyReason substringToIndex:200];
        }
        
        [_mainTableView reloadData];
    }
}

/** 识别会话错误返回代理
 *  @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0)
    {
        
    }
}

#pragma mark - <CreatePickerView>

- (void)createPickerMethod
{
    _selectItemPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    _selectItemPickerView.dataSource = self;
    _selectItemPickerView.delegate = self;
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_selectItemPickerView
                                                             AndHeight:284];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    switch (_selectListIndex) {
        case 0:
        {
            // 选择楼盘状态
            [_selectItemPickerView selectRow:_selectEstStatusIndex
                                 inComponent:0
                                    animated:YES];
        }
            break;
            
        case 1:
        {
            // 选择联系人类型
            [_selectItemPickerView selectRow:_selectContactTypeIndex
                                 inComponent:0
                                    animated:YES];
        }
            break;
            
        case 3:
        {
            // 选择联系人状态
            [_selectItemPickerView selectRow:_selectContactSexIndex
                                 inComponent:0
                                    animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <PickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _listTitleArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    SelectItemDtoEntity *selectItemDtoEntity = [_listTitleArray objectAtIndex:row];
    
    cusPicLabel.text = selectItemDtoEntity.itemText;
    [cusPicLabel setFont:[UIFont fontWithName:FontName
                                         size:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectResultIndex = row;
}

#pragma mark - <DateTimeSelectedDelegate>

- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *now = [date  dateByAddingTimeInterval: interval];   // 当前时间
    NSDate *selectTime = [DateTimePickerDialog ConversionTimeZone:dateTime];

    NSTimeInterval secondsInterval= [selectTime timeIntervalSinceDate:now];

    // 不是之前的日期
    if (secondsInterval > 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];

        _msgTime = [dateFormatter stringFromDate:dateTime];
        _selectedDate = dateTime;
    }
    else
    {
        showMsg(@"请选择有效日期");
    }
}

/// 确定
- (void)clickDone
{
    if (_msgTime == nil)
    {
        // 没有滑动
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        _msgTime = [dateFormatter stringFromDate:_selectedDate];
    }

    _oldTime = _selectedDate;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/// 取消
- (void)clickCancle
{
    if (!_oldTime)
    {
        _msgTime = nil;
        _selectedDate = nil;
    }
    else
    {
        _selectedDate = _oldTime;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];

        _msgTime = [dateFormatter stringFromDate:_oldTime];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <DoneSelectDelegate>

- (void)doneSelectItemMethod
{
    switch (_selectListIndex) {
        case 0:
        {
            // 选择楼盘状态
            _selectEstStatus = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectEstStatusIndex = _selectResultIndex;
        }
            break;
            
        case 1:
        {
            // 选择联系人类型
            _selectContactType = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectContactTypeIndex = _selectResultIndex;
        }
            break;
            
        case 3:
        {
            // 选择联系人性别
            _selectContactSex = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectContactSexIndex = _selectResultIndex;
        }
            break;
            
        default:
            break;
    }
    
    [_mainTableView reloadData];
}

#pragma mark- <ResponseDelegate>

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
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"已成功提交申请转盘"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {

                                                                          [weakSelf submitSuccess];
                                                                      }];
                [alertCtrl addAction:confirmAction];
                [self presentViewController:alertCtrl animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"已成功提交申请转盘"
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
            showMsg(@"提交失败");
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
