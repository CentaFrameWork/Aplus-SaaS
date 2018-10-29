//
//  NewOpeningViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "NewOpeningViewController.h"
#import "SearchRemindPersonViewController.h"
#import "CustomActionSheet.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "NewOpeningCell.h"
#import "PhoneNumberCell.h"
#import "OpeningReasonCell.h"
#import "OpeningPersonCell.h"
#import "RentalPricesCell.h"
#import <iflyMSC/iflyMSC.h>
#import "PropertyFollowAllAddApi.h"
#import "FollowTypeDefine.h"
#import "TCPickView.h"
#import "DateTimePickerDialog.h"
#import "MultiSelectView.h"
#import "GetTrustorslistApi.h"
#import "GetTrustorListEntity.h"
#import "OwnerEntity.h"

#import "NewOpeningBasePresenter.h"


#define DeleteRemindPersonBtnTag        10000   //删除按钮baseTag
#define DeleteOpeningPersonBtnTag       11001   //删除开盘人baseTag
#define DeleteOwnerBtnTag               12001   //删除业主baseTag

#define AddRemindPersonActionTag        20001   //点击提醒人后Actionsheet
#define RentalPricesInputTag            20004   //租售价格inputTag
#define ContactPersonNameInputTag       20005   //联系人姓名inputTag
#define ContactPersonPhoneInputTag      20006   //联系人手机inputTag
#define ApplyReasonInputTag             20007   //申请理由inputTag

#define ContactsAll                    1  //成功添加联系人
#define ContactsNone                   2   //无添加联系人
#define ContactsLack                   3   //添加联系人  缺少字段



@interface NewOpeningViewController ()<UITableViewDataSource,UITableViewDelegate,IFlyRecognizerViewDelegate,
UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,doneSelect,SearchRemindPersonDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DateTimeSelected,UITextFieldDelegate,UITextViewDelegate,
MultiSelectViewDelegate>
{
	
	NSDate *_selectedDate;
    NSDate *_oldTime;
	DateTimePickerDialog *dateTimePickerDialog;
	
    __weak IBOutlet UITableView *_mainTableView;
    UICollectionView *_OpeningPersonCollectionView; //开盘人collectionView
    UICollectionView *_remindPersonCollectionView;  //提醒人collectionView
    UICollectionView *_confirmOwnerCollectionView;  //确认业主collectionView
    
    UIPickerView *_selectItemPickerView;    //选择类型
    
    IFlyRecognizerView  *_iflyRecognizerView;       //语音输入
    
    NSMutableArray *_openingPersonArr;  //选择开盘人数组
    NSMutableArray *_remindPersonsArr;  //选择的提醒人数组
    NSMutableArray *_confirmOwnerArr;  //选择的业主数组
    
    NSMutableArray *_openingTypeArr;    //开盘类型
    NSMutableArray *_contactTypeArr;    //联系人类别
    NSMutableArray *_contactSexArr;     //联系人性别
    
    NSMutableArray *_listTitleArray;    //列表显示用到的数组
    
    SelectItemDtoEntity *_selectOpeningStatus; //开盘的类型
    SelectItemDtoEntity *_selectContactType;   //选择的联系人类型
    SelectItemDtoEntity *_selectContactSex;    //选择的联系人性别
    NSString *_msgTime;  //选择的时间
    
    //获取用户信息
    DataBaseOperation *_dataBase;
    DepartmentInfoResultEntity*_departmentInfoEntity;
    
    NSInteger _selectListIndex;         //选择了列表中的index
    NSInteger _selectResultIndex;       //选择筛选结果中的index
    
    NSString *_contactPersonName;       //联系人姓名
    NSString *_contactPersonPhone;      //联系人手机号
    NSString *_rentPrices;              //租价
    NSString *_salePrices;              //售价
    NSMutableAttributedString *_rentSalePricesType;      //租售价格类型
    NSString *_pricesType;              //价格单位
    
    NSString *_oldOpeningStatus;        //原始选择开盘类型
    
    //用来再次点击的时候默认选择之前选择的那一项
    NSInteger _selectOpeningTypeIndex;   //选择开盘的index
    NSInteger _selectContactTypeIndex;  //联系人类型选择过的index
    NSInteger _selectContactSexIndex;   //联系人性别选择过的index
    
    NSString *_openingReasonContent;       //信息补充内容
    
    BOOL _isSelectOpeningPersonCollectionView;  //点击开盘人还是提醒人
    BOOL _isSubmit;                         //是否正在提交新开盘（防止多次点击）
	
	UILabel *_rentalPricesCellRightLabel;
    
    UIWindow * _mainWindow;
    MultiSelectView *_customView;
    GetTrustorslistApi *_getTrustorslistApi;
	
    NSMutableArray *_trustorKeyIdList; // 确认业主 业主id list
    NSMutableArray *_newAddTrustorSortNum; // 新开盘时，新增的业主序号，用于确认业主
    
    NewOpeningBasePresenter *_newOpeningPresenter;
}

@end

@implementation NewOpeningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPresenter];
    [self initView];
    [self initData];
}

- (void)initView
{
    [self setNavTitle:@"新开盘"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil sel:@selector(commitNewOpening)]];
    _mainTableView.delegate =self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView =[[UIView alloc] init];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"OpeningPersonCell" bundle:nil] forCellReuseIdentifier:@"openingPersonCell"];
    
    /*
     *添加textfield、textView监听
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textfieldChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
}

- (void)initPresenter
{
    
        _newOpeningPresenter = [[NewOpeningBasePresenter alloc] initWithDelegate:self];
    
}

- (void)initData
{
    _isSubmit = NO;
    
    _getTrustorslistApi = [GetTrustorslistApi new];
    
    _trustorsArray = [NSMutableArray array];
    
    //从数据库获取当前登录用户
    _dataBase = [DataBaseOperation sharedataBaseOperation];
    _departmentInfoEntity =  [_dataBase selectAgencyUserInfo];
    
    _remindPersonsArr = [[NSMutableArray alloc]init];
    _openingPersonArr = [[NSMutableArray alloc] init];
    _confirmOwnerArr = [[NSMutableArray alloc] init];
    
    _trustorKeyIdList = [NSMutableArray array];
    _newAddTrustorSortNum = [NSMutableArray array];
    
    RemindPersonDetailEntity *remindPersonEntity = [[RemindPersonDetailEntity alloc] init];
    //开盘人默认加载当前登录用户
    remindPersonEntity.departmentName = _departmentInfoEntity.identify.departName;
    remindPersonEntity.resultName = _departmentInfoEntity.identify.uName;
    remindPersonEntity.departmentKeyId =_departmentInfoEntity.identify.departId;
    remindPersonEntity.resultKeyId =_departmentInfoEntity.identify.uId;
    [_openingPersonArr addObject:remindPersonEntity];
    _listTitleArray = [[NSMutableArray alloc]init];
    
    SysParamItemEntity *contactTypeSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_CONTACT_TYPE];
    SysParamItemEntity *contactSexSysparamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];

    //根据房源不同的状态，显示不同的开盘类型
    NSString * firstItemText = [_newOpeningPresenter getFirstItemTextWithPropertyStatus:_propertyStatus andTradingState:_tradingState.integerValue];
    NSString * secondItemText = [_newOpeningPresenter getSecondItemTextWithPropertyStatus:_propertyStatus andTradingState:_tradingState.integerValue];;
    
    //租售类型初始值
    if ([firstItemText isEqualToString:@"新开售"]||[firstItemText isEqualToString:@"租开售"]) {
        _pricesType = @"万元";
        _rentSalePricesType = [self setupLeftTitleWithString:@"*售价"];
    }else
    {
        _pricesType = @"元";
        _rentSalePricesType = [self setupLeftTitleWithString:@"*租价"];
    }
    
    _oldOpeningStatus = firstItemText;
    
    _openingTypeArr = [[NSMutableArray alloc] init];
    for (int i= 0; i<2; i++) {
        SelectItemDtoEntity *openingTypeEntity = [[SelectItemDtoEntity alloc] init];
        if (i == 0) {
            openingTypeEntity.itemText = firstItemText;
        }else{
            openingTypeEntity.itemText = secondItemText;
        }
        
        [_openingTypeArr addObject:openingTypeEntity];
    }
   
    _selectOpeningStatus = [SelectItemDtoEntity new];
    
    _contactTypeArr = [[NSMutableArray alloc]initWithArray:contactTypeSysParamItemEntity.itemList];
    _contactSexArr = [[NSMutableArray alloc]initWithArray:contactSexSysparamItemEntity.itemList];
}

- (NSMutableAttributedString *)setupLeftTitleWithString:(NSString *)title
{
    NSMutableAttributedString *leftTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
    [leftTitleStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor redColor]
                         range:NSMakeRange(0, 1)];
    return leftTitleStr;
}

#pragma mark - <提交>
- (void)commitNewOpening
{
    if (_isSubmit) {
        
        return;
        
    }
    
    [self.view endEditing:YES];

    //去掉两端的空格
    NSString *trimedString = [_openingReasonContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断输入内容是否全是空格
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_openingReasonContent];
    if (!_openingReasonContent ||
        [_openingReasonContent isEqualToString:@""] || isEmpty) {
        
        showMsg(@"请输入开盘原因!");
        
        return;
    }
    
    // 租价/售价
    if ([_oldOpeningStatus isEqualToString:@"新开租"]||[_oldOpeningStatus isEqualToString:@"售开租"]) {
        if ([NSString isNilOrEmpty:_rentPrices])
        {
            showMsg(@"请输入租价!");
            return;
        }
    }
    
    if ([_oldOpeningStatus isEqualToString:@"新开售"]||[_oldOpeningStatus isEqualToString:@"租开售"]) {
        if ([NSString isNilOrEmpty:_salePrices])
        {
            showMsg(@"请输入售价!");
            return;
        }
    }
    
    
    /**
     *  提醒人相关信息
     */
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

    
    // 是否含有确认业主功能
    if ([_newOpeningPresenter haveConfirmOwnerFunction])
    {
        if (_confirmOwnerArr.count <= 0)
        {
            showMsg(@"请确认业主!");
            return;
        }
    }
    
    
    // 开盘人相关信息
    if (_openingPersonArr.count <= 0) {
        showMsg(@"请输入开盘人!");
        
        return;
    }
    NSMutableArray *openingContactsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *openingContactsKeyIdArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *openingInformDepartsNameArr = [[NSMutableArray alloc]init];
    NSMutableArray *openingInformDepartsKeyIdArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_openingPersonArr.count; i++) {
        RemindPersonDetailEntity *remindPersonEntity = [_openingPersonArr objectAtIndex:i];
            
        [openingInformDepartsNameArr addObject:remindPersonEntity.departmentName];
        [openingInformDepartsKeyIdArr addObject:remindPersonEntity.departmentKeyId];
            
            //人员
        [openingContactsNameArr addObject:remindPersonEntity.resultName];
        [openingContactsKeyIdArr addObject:remindPersonEntity.resultKeyId];

    }
    
    NSString *openingContactsName = @"";
    NSString *openingContactsKeyId = @"";
    NSString *openingInformDepartsName = @"";
    NSString *openingInformDepartsKeyId = @"";
    if (openingContactsNameArr.count > 0)
    {
        openingContactsName = [openingContactsNameArr componentsJoinedByString:@","];
    }
    if (openingContactsKeyIdArr.count > 0)
    {
        openingContactsKeyId = [openingContactsKeyIdArr componentsJoinedByString:@","];
    }
    if (openingInformDepartsNameArr.count > 0) {
        openingInformDepartsName = [openingInformDepartsNameArr componentsJoinedByString:@","];
    }
    if (openingInformDepartsKeyIdArr.count > 0) {
        openingInformDepartsKeyId = [openingInformDepartsKeyIdArr componentsJoinedByString:@","];
    }
    
    NSString *contactNameStr = @"";
    NSString *contactPhoneStr = @"";
    if ((_contactPersonName &&
        ![_contactPersonName isEqualToString:@""])||
        
        (_contactPersonPhone &&
         ![_contactPersonPhone isEqualToString:@""]) ||
        _selectContactType ||
        _selectContactSex) {
        

        //去掉两端的空格
        NSString *trimedNameString = [_contactPersonName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //判断输入内容是否全是空格
        BOOL isEmptyName = [NSString isEmptyWithLineSpace:_contactPersonName];

        if ([NSString isNilOrEmpty:_contactPersonName] || isEmptyName) {
            showMsg(@"请输入联系人姓名!");
            return;
        }
        
        if ([NSString isNilOrEmpty:_contactPersonPhone]) {
            showMsg(@"请输入联系人电话");
            return;
        }
        
        if ([NSString isNilOrEmpty:_selectContactType.itemText]) {
            showMsg(@"请输入联系人类型");
            return;
        }
        
        if ([NSString isNilOrEmpty:_selectContactSex.itemText]) {
            showMsg(@"请输入联系人性别");
            return;
        }
        
        
        if (![CommonMethod isMobile:_contactPersonPhone]) {
            showMsg(@"请输入正确的手机号!");
            return;
            
        }
        
        if (trimedNameString &&
            ![trimedNameString isEqualToString:@""]) {
            contactNameStr = trimedNameString;
        }
    
        if (_contactPersonPhone &&
            ![_contactPersonPhone isEqualToString:@""]) {
            
            contactPhoneStr = _contactPersonPhone;
        }
    }
    
    
    
    /**
     *  开盘类型
     */
    NSString *openingType = @"";
    if ([_selectOpeningStatus.itemText isEqualToString:@"租开售"]) {
        openingType = @"1";
    }else if ([_selectOpeningStatus.itemText isEqualToString:@"售开租"]){
        openingType = @"2";
    }else if ([_selectOpeningStatus.itemText isEqualToString:@"新开租"]){
        openingType = @"3";
    }else{
        openingType = @"4"; //新开售
    }
    
    _isSubmit = YES;
    [self showLoadingView:@"提交中..."];


    PropertyFollowAllAddApi *propertyFollowAllAddApi = [[PropertyFollowAllAddApi alloc] init];
    propertyFollowAllAddApi.propertyFollowAllAddType = AddInfo;
    PropertyFollowAllAddEntity *entity = [[PropertyFollowAllAddEntity alloc] init];
    entity.PropertyKeyId = _propertyKeyId;
    entity.FollowType = PropertyFollowTypeAddEstate;
    entity.ContactsName = contactsNameArr;
    entity.InformDepartsName = informDepartsNameArr;
    entity.FollowContent = trimedString;//
    entity.Mobile = contactPhoneStr;
    entity.TrustorName = contactNameStr;
    entity.TrustorTypeKeyId = _selectContactType?_selectContactType.itemValue:@"";
    entity.TrustorGenderKeyId = _selectContactSex?_selectContactSex.itemValue:@"";
    entity.TrustorRemark = @"";
    entity.telphone1 = @"";
    entity.telphone2 = @"";
    entity.telphone3 = @"";
    entity.TrustType = @"";
    entity.OpeningType = openingType;
    entity.OpeningPersonName = openingContactsName;
    entity.OpeningDepName = openingInformDepartsName;
    entity.RentPrice = _rentPrices?_rentPrices:@"";
    entity.RentPer = @"";
    entity.SalePrice = _salePrices?_salePrices:@"";
    entity.SalePer = @"";
    entity.OpeningPersonKeyId = openingContactsKeyId;
    entity.OpeningDepKeyId = openingInformDepartsKeyId;
    entity.TargetDepartmentKeyId = @"";
    entity.TargetUserKeyId = @"";
    entity.MsgUserKeyIds = contactsKeyIdArr;
    entity.MsgDeptKeyIds = informDepartsKeyIdArr;
    entity.MsgTime = _msgTime;
    entity.KeyId = @"";
    propertyFollowAllAddApi.entity = entity;
    propertyFollowAllAddApi.addTrustorSortNum = [_newAddTrustorSortNum mutableCopy];
    propertyFollowAllAddApi.trustorKeyIdList = [_trustorKeyIdList mutableCopy];
    [_manager sendRequest:propertyFollowAllAddApi];

}


#pragma mark - <TableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 6:
            return 86;
            break;
        case 7:
            return 92;
            break;
        case 8:
        {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight > 80.0) {
                
                return remindPersonHeight+16.0;
            }
            
            return 80.0+16.0;
        }
        case 10:
        {
            //添加提醒人
            CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
            
            if (remindPersonHeight > 80.0) {
                
                return remindPersonHeight+16.0;
            }
            
            return 80.0+16.0;
        }
           // return 94;
            break;
        default:
            break;
    }
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 是否有确认业主功能
    if ([_newOpeningPresenter haveConfirmOwnerFunction]) {
        return 11;
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newOpeningCellIdentifier = @"newOpeningCell";
    NSString *phoneNumberCellIdentifier = @"phoneNumberCell";
    NSString *openingReasonCellIdentifier = @"openingReasonCell";
    NSString *openingPersonCellIdentifier = @"openingPersonCell";
    NSString *rentalPricesCellIdentifier = @"rentalPricesCell";
    
    NewOpeningCell *newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
    if (!newOpeningCell) {
        [tableView registerNib:[UINib nibWithNibName:@"NewOpeningCell" bundle:nil]
        forCellReuseIdentifier:newOpeningCellIdentifier];
        newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
    }
    
    //租售价格
	RentalPricesCell *rentalPricesCell = [tableView dequeueReusableCellWithIdentifier:rentalPricesCellIdentifier];
    if (!rentalPricesCell) {
        [tableView registerNib:[UINib nibWithNibName:@"RentalPricesCell" bundle:nil] forCellReuseIdentifier:rentalPricesCellIdentifier];
        rentalPricesCell = [tableView dequeueReusableCellWithIdentifier:rentalPricesCellIdentifier];
    }
    
    //电话
    PhoneNumberCell *phoneNumberCell = [tableView dequeueReusableCellWithIdentifier:phoneNumberCellIdentifier];
    if (!phoneNumberCell) {
        [tableView registerNib:[UINib nibWithNibName:@"PhoneNumberCell" bundle:nil] forCellReuseIdentifier:phoneNumberCellIdentifier];
        phoneNumberCell = [tableView dequeueReusableCellWithIdentifier:phoneNumberCellIdentifier];
    }
    
    //原因
    OpeningReasonCell *openingReasonCell = [tableView dequeueReusableCellWithIdentifier:openingReasonCellIdentifier];
    if (!openingReasonCell) {
        [tableView registerNib:[UINib nibWithNibName:@"OpeningReasonCell" bundle:nil] forCellReuseIdentifier:openingReasonCellIdentifier];
        openingReasonCell = [tableView dequeueReusableCellWithIdentifier:openingReasonCellIdentifier];
    }
    
    NSMutableAttributedString *changeColorStr =  [CommonMethod setLabelMutableColorWithColor:[UIColor redColor] andStr:@"*开盘人" andStarLoc:0 andLength:1];
    NSMutableAttributedString *changeColorOwner =  [CommonMethod setLabelMutableColorWithColor:[UIColor redColor] andStr:@"*确认业主" andStarLoc:0 andLength:1];

    switch (indexPath.row) {
        case 0:
        {
            newOpeningCell.leftTitleLabel.text = @"开盘类型";
			
            if (_selectOpeningStatus.itemText &&
                ![_selectOpeningStatus.itemText isEqualToString:@""]) {
                
                newOpeningCell.rightValueLabel.text = _selectOpeningStatus.itemText;
                newOpeningCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
            }else{
				if(_tradingState.integerValue == 1){
					//出售
                   
                    SelectItemDtoEntity *firstItem = _openingTypeArr[0];
                    
                    newOpeningCell.rightValueLabel.text = firstItem.itemText;
                    _selectOpeningStatus.itemText = firstItem.itemText;
                    
					
					newOpeningCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
                    
                    if ([firstItem.itemText isEqualToString:@"售开租"]||[firstItem.itemText isEqualToString:@"新开租"]) {
                        _pricesType = @"元";
                    }else{
                        _pricesType = @"万元";
                    }
                    
				}else if (_tradingState.integerValue == 2){
					//出租
//					newOpeningCell.rightValueLabel.text = @"新开租";
//					_selectOpeningStatus.itemText = @"新开租";
                    
                    SelectItemDtoEntity *firstItem = _openingTypeArr[0];
                    
                    newOpeningCell.rightValueLabel.text = firstItem.itemText;
                    _selectOpeningStatus.itemText = firstItem.itemText;
					newOpeningCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
                    if ([firstItem.itemText isEqualToString:@"租开售"]||[firstItem.itemText isEqualToString:@"新开售"]) {
                        _pricesType = @"万元";
                    }else{
                        _pricesType = @"元";
                    }
					
				}else{
					//租售
//					newOpeningCell.rightValueLabel.text = @"新开售";
//					_selectOpeningStatus.itemText = @"新开售";
                    
                    SelectItemDtoEntity *firstItem = _openingTypeArr[0];
                    
                    newOpeningCell.rightValueLabel.text = firstItem.itemText;
                    _selectOpeningStatus.itemText = firstItem.itemText;
					newOpeningCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
					_pricesType = @"万元";
				}

            }
            
            return newOpeningCell;
        }
            break;
            
        case 1:
        {
            rentalPricesCell.leftTitleLabel.attributedText = _rentSalePricesType;
			rentalPricesCell.rightPricesTextField.keyboardType = UIKeyboardTypeNumberPad;
			rentalPricesCell.rightLabel.text = _pricesType;
			_rentalPricesCellRightLabel = rentalPricesCell.rightLabel;
			[rentalPricesCell.rightPricesTextField addTarget:self
													  action:@selector(textfieldChangingText:)
											forControlEvents:UIControlEventEditingChanged];
			rentalPricesCell.rightPricesTextField.delegate = self;
            rentalPricesCell.rightPricesTextField.tag = RentalPricesInputTag;
            if ([_pricesType isEqualToString:@"元"]) {
                rentalPricesCell.rightPricesTextField.text = _rentPrices;
            }else{
                rentalPricesCell.rightPricesTextField.text = _salePrices;
            }
            
            return rentalPricesCell;
        }
            break;
        case 2:
        {
            newOpeningCell.leftTitleLabel.text = @"联系人类型";
            if (_selectContactType.itemText &&
                ![_selectContactType.itemText isEqualToString:@""]) {
                
                newOpeningCell.rightValueLabel.text = _selectContactType.itemText;
                newOpeningCell.rightValueLabel.textColor = LITTLE_BLACK_COLOR;
                
            }else{
                
                newOpeningCell.rightValueLabel.text = @"请选择联系人类型";
                newOpeningCell.rightValueLabel.textColor = LABEL_LITTLEGRAY_COLOR;
            }
            
            return newOpeningCell;
        }
            break;
            
        case 3:
        {
            phoneNumberCell.leftTitleLabel.text = @"姓名";
            phoneNumberCell.rightPhoneTextField.placeholder = @"请输入联系人姓名";
            phoneNumberCell.rightPhoneTextField.keyboardType = UIKeyboardTypeDefault;
            phoneNumberCell.rightPhoneTextField.tag = ContactPersonNameInputTag;
            phoneNumberCell.rightPhoneTextField.text = _contactPersonName;
            return phoneNumberCell;
        }
            break;
            
        case 4:
        {
            newOpeningCell.leftTitleLabel.text = @"性别";
            
            if (_selectContactSex.itemText &&
                ![_selectContactSex.itemText isEqualToString:@""]) {
                
                newOpeningCell.rightValueLabel.text = _selectContactSex.itemText;
            }else{
                
                newOpeningCell.rightValueLabel.text = @"请选择联系人性别";
                newOpeningCell.rightValueLabel.textColor = LABEL_LITTLEGRAY_COLOR;
            }
            
            return newOpeningCell;
        }
            break;
            
        case 5:
        {
            phoneNumberCell.leftTitleLabel.text = @"手机";
            phoneNumberCell.rightPhoneTextField.placeholder = @"请输入联系人电话";
            phoneNumberCell.rightPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
            phoneNumberCell.rightPhoneTextField.tag = ContactPersonPhoneInputTag;
			phoneNumberCell.rightPhoneTextField.delegate = self;
            phoneNumberCell.rightPhoneTextField.text = _contactPersonPhone;
            return phoneNumberCell;
        }
            break;
            
        case 6:
        {
            //开盘内容
            openingReasonCell.rightInputTextView.text = _openingReasonContent;
            openingReasonCell.rightInputTextView.delegate = self;
			openingReasonCell.rightInputTextView.tag = ApplyReasonInputTag;
            [openingReasonCell.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];
            return openingReasonCell;
			
        }
            break;
            
        case 7:
        {
            //开盘人
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier forIndexPath:indexPath];

            UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                      bundle:nil];
            _OpeningPersonCollectionView = openingPersonCell.showRemindListCollectionView;
            [_OpeningPersonCollectionView registerNib:collectionCellNib
                          forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _OpeningPersonCollectionView.delegate = self;
            _OpeningPersonCollectionView.dataSource = self;
            
            openingPersonCell.leftPersonLabel.attributedText = changeColorStr;
            [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddOpeningPersonMethod) forControlEvents:UIControlEventTouchUpInside];
            
            return openingPersonCell;
        }
            break;
            
        case 8:
        {
            //提醒人
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier forIndexPath:indexPath];
            
            UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                      bundle:nil];
            _remindPersonCollectionView = openingPersonCell.showRemindListCollectionView;
            [_remindPersonCollectionView registerNib:collectionCellNib
                          forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _remindPersonCollectionView.delegate = self;
            _remindPersonCollectionView.dataSource = self;
            
            openingPersonCell.leftPersonLabel.text = @"提醒人";
            [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(clickAddRemindPersonMethod) forControlEvents:UIControlEventTouchUpInside];
            return openingPersonCell;
            break;
        }
           
        case 9:
        {
            newOpeningCell.leftTitleLabel.text = @"提醒时间";
            if (_msgTime) {
                newOpeningCell.rightValueLabel.text = _msgTime;
            }else{
                newOpeningCell.rightValueLabel.text = @"点击选择时间";
            }
            return newOpeningCell;
        }
        case 10:
        {
            //选择业主
            OpeningPersonCell * openingPersonCell = [tableView dequeueReusableCellWithIdentifier:openingPersonCellIdentifier forIndexPath:indexPath];
            
            UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
                                                      bundle:nil];
            _confirmOwnerCollectionView = openingPersonCell.showRemindListCollectionView;
            [_confirmOwnerCollectionView registerNib:collectionCellNib
                           forCellWithReuseIdentifier:@"applyRemindPersonCollectionCell"];
            _confirmOwnerCollectionView.delegate = self;
            _confirmOwnerCollectionView.dataSource = self;
            
            openingPersonCell.leftPersonLabel.attributedText = changeColorOwner;
            [openingPersonCell.addOpeningPersonBtn addTarget:self action:@selector(selectOwner) forControlEvents:UIControlEventTouchUpInside];
            
            return openingPersonCell;
        }
            break;
        
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc]init];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    _selectListIndex = indexPath.row;
    _selectResultIndex = 0;
    
    [_listTitleArray removeAllObjects];
    
    switch (indexPath.row) {
        case 0:
        {
            //选择开盘类型
            [_listTitleArray addObjectsFromArray:_openingTypeArr];
            [self createPickerMethod];
        }
            break;
		case 1:{
			RentalPricesCell *rentalPricesCell = [tableView cellForRowAtIndexPath:indexPath];
			[rentalPricesCell.rightPricesTextField becomeFirstResponder];
			break;
		}
        case 2:
        {
            //选择联系人类型
            [_listTitleArray addObjectsFromArray:_contactTypeArr];
            [self createPickerMethod];
        }
            break;
        case 4:
        {
            //选择联系人性别
            
            [_listTitleArray addObjectsFromArray:_contactSexArr];
            [self createPickerMethod];
        }
            break;
        case 9:
        {
            //提醒时间
			if (!_selectedDate) {
				_selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
			}
			
			dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
																	 andDelegate:self
																		  andTag:@"start"];
			
			[dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
			
            
        }
            break;
        default:
            break;
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
        
        _openingReasonContent = [NSString stringWithFormat:@"%@%@",
                          _openingReasonContent?_openingReasonContent:@"",
                          vcnMutlResultValue];
        
        if (_openingReasonContent.length > 200) {
            
            _openingReasonContent = [_openingReasonContent substringToIndex:200];
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

#pragma mark - <InputViewTextChangeDelegate>
- (void)textfieldChangeInput:(NSNotification *)notification
{
    UITextField *inputTextfield = (UITextField *)notification.object;
    
    switch (inputTextfield.tag) {
        case ContactPersonNameInputTag:
        {
            //联系人姓名（不超过20个文字）
            if (_contactPersonName.length <= 20 ||
                _contactPersonName.length > inputTextfield.text.length) {
                
                _contactPersonName = inputTextfield.text;
            }else{
                
                [_mainTableView reloadData];
                
                [CustomAlertMessage showAlertMessage:@"请输入不超过20个字的姓名\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            
            
        }
            break;
        case ContactPersonPhoneInputTag:
        {
            //联系人手机
            _contactPersonPhone = inputTextfield.text;
        }
            break;
        case RentalPricesInputTag:
        {
            //租售价格
            if ([_pricesType isEqualToString:@"元"]) {
                    _rentPrices = inputTextfield.text;
            }else{
                 _salePrices = inputTextfield.text;
            }
            
           
        }
            break;
        default:
            break;
    }
}

#pragma mark - <TextViewDelegate>
- (void)textViewChangeInput:(NSNotification *)notification
{
    
    UITextView *inputTextView = (UITextView *)notification.object;

    if (inputTextView.text.length > 200) {
        NSString *subStr=[inputTextView.text substringToIndex:200];
        inputTextView.text = subStr;
    }else{
        _openingReasonContent = inputTextView.text;
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(range.length == 0 && range.location>=200)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                 textView.text,
                                 text];
        NSString *subStr=[inputString substringToIndex:200];
        textView.text=subStr;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}

#pragma mark - <CreatePickerView>
- (void)createPickerMethod
{
    
    _selectItemPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                           40,
                                                                           APP_SCREEN_WIDTH,
                                                                           180)];
    _selectItemPickerView.dataSource = self;
    _selectItemPickerView.delegate = self;
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_selectItemPickerView
                                                             AndHeight:284];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    switch (_selectListIndex) {
        case 0:
        {
            //选择楼盘状态
            
            [_selectItemPickerView selectRow:_selectOpeningTypeIndex
                                 inComponent:0
                                    animated:YES];
        }
            break;
        case 2:
        {
            //选择联系人类型
            
            [_selectItemPickerView selectRow:_selectContactTypeIndex
                                 inComponent:0
                                    animated:YES];
        }
            break;
        case 4:
        {
            //选择联系人性别
            
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectResultIndex = row;
}

#pragma mark - <DoneSelectDelegate>
- (void)doneSelectItemMethod
{
    switch (_selectListIndex) {
        case 0:
        {
            
            //选择楼盘状态
            _selectOpeningStatus = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectOpeningTypeIndex = _selectResultIndex;
            if ([_selectOpeningStatus.itemText isEqualToString:@"新开租"] || [_selectOpeningStatus.itemText isEqualToString:@"售开租"]) {
                _rentSalePricesType = [self setupLeftTitleWithString:@"*租价"];
                _pricesType = @"元";
            }else{
                _rentSalePricesType = [self setupLeftTitleWithString:@"*售价"];
                _pricesType = @"万元";
            }
            
            if (![_selectOpeningStatus.itemText isEqualToString:_oldOpeningStatus])
            {
                _rentPrices = nil;
                _salePrices = nil;
                _oldOpeningStatus = _selectOpeningStatus.itemText;
            }
            
            
        }
            break;
        case 2:
        {
            //选择联系人类型
            
            _selectContactType = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectContactTypeIndex = _selectResultIndex;
        }
            break;
        case 4:
        {
            //选择联系人性别
            
            _selectContactSex = [_listTitleArray objectAtIndex:_selectResultIndex];
            _selectContactSexIndex = _selectResultIndex;
        }
            break;
            
        default:
            break;
    }
    
    [_mainTableView reloadData];
}


#pragma mark - <UICollectionViewDelegate/DataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _remindPersonCollectionView)
    {
        // 提醒人
        return _remindPersonsArr.count;
    }
    else if(collectionView ==_OpeningPersonCollectionView)
    {
        // 开盘人
        return _openingPersonArr.count;
    }
    else
    {
        // 确认业主
        return _confirmOwnerArr.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat collectionViewWidth = (202.0/320.0)*APP_SCREEN_WIDTH;
    
    CGFloat resultStrWidth ;
    
    RemindPersonDetailEntity *remindPersonEntity;
    OwnerEntity *ownerEntity;
    
    if (collectionView == _remindPersonCollectionView)
    {
        // 提醒人
       remindPersonEntity = [_remindPersonsArr objectAtIndex:indexPath.row];
        
        resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                        size:14.0]
                                                 Height:25.0
                                                   size:14.0];
    }
    else if(collectionView == _OpeningPersonCollectionView)
    {
        // 开盘人
        remindPersonEntity = [_openingPersonArr objectAtIndex:indexPath.row];
        resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
                                                                                       size:14.0]
                                                                Height:25.0
                                                                  size:14.0];
        
    }
    else
    {
        // 提醒业主
        ownerEntity = [_confirmOwnerArr objectAtIndex:indexPath.row];
        resultStrWidth = [ownerEntity.trustorName getStringWidth:[UIFont fontWithName:FontName
                                                                                       size:14.0]
                                                                Height:25.0
                                                                  size:14.0];
    }
    
    
  
    
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
    if (collectionView == _remindPersonCollectionView)
    {
        // 提醒人
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
    else if(collectionView == _OpeningPersonCollectionView)
    {
        // 开盘人
        ApplyRemindPersonCollectionCell *openingPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_OpeningPersonCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                                                                                                                forIndexPath:indexPath];
        
        openingPersonCollectionCell.rightDeleteBtn.tag = DeleteOpeningPersonBtnTag+indexPath.row;
        [openingPersonCollectionCell.rightDeleteBtn addTarget:self
                                                      action:@selector(deleteOpeningPersonMethod:)
                                            forControlEvents:UIControlEventTouchUpInside];
        
        RemindPersonDetailEntity *curRemindPersonEntity = [_openingPersonArr objectAtIndex:indexPath.row];
        openingPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;
        
        return openingPersonCollectionCell;
    }
    else
    {
        // 业主
        ApplyRemindPersonCollectionCell *openingPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_confirmOwnerCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
                                                                                                                                                                 forIndexPath:indexPath];
        
        openingPersonCollectionCell.rightDeleteBtn.tag = DeleteOwnerBtnTag + indexPath.row;
        [openingPersonCollectionCell.rightDeleteBtn addTarget:self
                                                       action:@selector(deleteOwnerMethod:)
                                             forControlEvents:UIControlEventTouchUpInside];
        
        OwnerEntity *ownerEntity = [_confirmOwnerArr objectAtIndex:indexPath.row];
        openingPersonCollectionCell.leftValueLabel.text = ownerEntity.trustorName;
        
        return openingPersonCollectionCell;
    }
}


#pragma mark - <DateTimeSelected>
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
	
	NSDate *date = [NSDate date];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	NSInteger interval = [zone secondsFromGMTForDate: date];
	NSDate *now = [date  dateByAddingTimeInterval: interval];//当前时间
	NSDate *selectTime = [DateTimePickerDialog ConversionTimeZone:dateTime];
	
	NSTimeInterval secondsInterval= [selectTime timeIntervalSinceDate:now];
	
	//不可是之前的日期
	if (secondsInterval > 0) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:YearToMinFormat];
		
		_selectedDate = dateTime;
		_msgTime = [dateFormatter stringFromDate:dateTime];
//		[_mainTableView reloadData];
		
	}else{
		showMsg(@"请选择有效日期");
	}
}

/**
 *  点击确定
 */
- (void)clickDone{

    if (_msgTime == nil) {
        //没有滑动
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        _msgTime = [dateFormatter stringFromDate:_selectedDate];
    }
    
    _oldTime = _selectedDate;
    
    [_mainTableView reloadData];
}

/**
 *  点击取消
 */
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
    
    
    [_mainTableView reloadData];
}





//
//#pragma mark - <BYActionSheetViewDelegate>
//- (void)actionSheetView:(BYActionSheetView *)alertView
//  clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//
//    switch (alertView.tag) {
//        case AddRemindPersonActionTag:
//        {
//            //添加提醒人
//
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

#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (textField.tag == RentalPricesInputTag) {
		
		if ([_pricesType isEqualToString:@"万元"]) {
			return range.location > 5? NO:YES;
		}else{
			return range.location > 7? NO: YES;
		}
	}else if (textField.tag == ContactPersonPhoneInputTag){
		return range.location > 10? NO:YES;
	}
	
	return YES;
}

/** TextField 监听  */
- (void)textfieldChangingText:(UITextField *)textField{
	if (textField.text.length == 0) {
		_rentalPricesCellRightLabel.textColor = LABEL_LITTLEGRAY_COLOR;
	}else{
		_rentalPricesCellRightLabel.textColor = LITTLE_BLACK_COLOR;
	}
	
}


#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    if (_isSelectOpeningPersonCollectionView) {
        [_openingPersonArr addObject:selectRemindItem];
    }
    else
    {
        [_remindPersonsArr addObject:selectRemindItem];
    }
    
    [_remindPersonCollectionView reloadData];
    [_OpeningPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}

- (void)reloadRemindCellHeight
{
    [_mainTableView reloadData];
}

#pragma mark - <添加提醒人>
- (void)clickAddRemindPersonMethod
{
    _isSelectOpeningPersonCollectionView = NO;
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
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                  initWithNibName:@"SearchRemindPersonViewController"
                                                                  bundle:nil];
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

#pragma mark - <删除提醒人>
- (void)deleteRemindPersonMethod:(UIButton *)button
{
    
    NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
    
    [_remindPersonsArr removeObjectAtIndex:deleteItemIndex];
    
    [_remindPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}

#pragma mark - <添加开盘人>
- (void)clickAddOpeningPersonMethod
{
    if (_openingPersonArr.count >2) {
        showMsg(@"开盘人最多添加3个")
        return;
    }
    _isSelectOpeningPersonCollectionView = YES;
    [self.view endEditing:YES];
    
    SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                              initWithNibName:@"SearchRemindPersonViewController"
                                                              bundle:nil];
    searchRemindPersonVC.selectRemindType = PersonType;
    searchRemindPersonVC.selectRemindTypeStr = PersonRemindType;
    searchRemindPersonVC.selectedRemindPerson = _openingPersonArr;
    searchRemindPersonVC.delegate = self;
    [self.navigationController pushViewController:searchRemindPersonVC
                                         animated:YES];
}

#pragma mark - <删除开盘人>
- (void)deleteOpeningPersonMethod:(UIButton*)button
{
    NSInteger deleteItemIndex = button.tag-DeleteOpeningPersonBtnTag;
    
    [_openingPersonArr removeObjectAtIndex:deleteItemIndex];
    
    [_OpeningPersonCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}


#pragma mark - <选择业主>
- (void)selectOwner
{
    [self.view endEditing:YES];
    
    
    [_trustorsArray removeAllObjects];
    [_newAddTrustorSortNum removeAllObjects];
    [_trustorKeyIdList removeAllObjects];
    
    
    if ([self checkAddOwner])
    {
        // 添加了业主的情况
        OwnerEntity *owner = [OwnerEntity new];
        owner.trustorName = _contactPersonName;
        owner.mobile = _contactPersonPhone;
        owner.trustorType = _selectContactType.itemText;
        [_trustorsArray addObject:owner];
    }
    
    
    
    [self showLoadingView:nil];
    _getTrustorslistApi.keyId = _propertyKeyId;
    [_manager sendRequest:_getTrustorslistApi];
    
   
}

// 检查是否添加了联系人
- (BOOL)checkAddOwner
{
    if ((_contactPersonName &&
         ![_contactPersonName isEqualToString:@""])||
        
        (_contactPersonPhone &&
         ![_contactPersonPhone isEqualToString:@""]) ||
        _selectContactType ||
        _selectContactSex) {
        
        //判断输入内容是否全是空格
        BOOL isEmptyName = [NSString isEmptyWithLineSpace:_contactPersonName];
        
        if ([NSString isNilOrEmpty:_contactPersonName] || isEmptyName)
        {
            return NO;
        }
        
        if ([NSString isNilOrEmpty:_contactPersonPhone])
        {
            return NO;
        }
        
        if ([NSString isNilOrEmpty:_selectContactType.itemText])
        {
            return NO;
        }
        
        if ([NSString isNilOrEmpty:_selectContactSex.itemText])
        {
            return NO;
        }
        
        if (![CommonMethod isMobile:_contactPersonPhone])
        {
            return NO;
        }
        
        return YES;
    }
    else
    {
        //无添加联系人
        return NO;
    }
}

#pragma mark - <删除业主>
- (void)deleteOwnerMethod:(UIButton*)button
{
    NSInteger deleteItemIndex = button.tag - DeleteOwnerBtnTag;
    
    OwnerEntity *ownerEntity = _confirmOwnerArr[deleteItemIndex];
    
    if (ownerEntity.keyId)
    {
        [_trustorKeyIdList removeObject:ownerEntity.keyId];
    }
    else
    {
        [_newAddTrustorSortNum removeAllObjects];
    }
    
    [_confirmOwnerArr removeObjectAtIndex:deleteItemIndex];
    
    [_confirmOwnerCollectionView reloadData];
    
    [self performSelector:@selector(reloadRemindCellHeight)
               withObject:nil
               afterDelay:0.1];
}



#pragma mark -MultiSelectViewDelegate
/// 选择业主 (取消)
- (void)cancelAction
{
    [_mainWindow resignKeyWindow];
    [_mainWindow removeFromSuperview];
    
    [[self sharedAppDelegate].window makeKeyAndVisible];
}

/// 选择业主 (确定)
- (void)determineAction:(NSMutableArray *)array
{
    
    [_mainWindow resignKeyWindow];
    [_mainWindow removeFromSuperview];
    
    [[self sharedAppDelegate].window makeKeyAndVisible];
    
    int m = 0;
    if (_newAddTrustorSortNum.count > 0)
    {
        m = 1;
    }
    
    NSInteger arrCount = array.count;
    for (int i = m; i < arrCount; i++)
    {
        OwnerEntity *owner = array[i];
        [_trustorKeyIdList addObject:owner.keyId];
    }
    
    [_confirmOwnerArr removeAllObjects];
    _confirmOwnerArr = [NSMutableArray arrayWithArray:array];
    [_confirmOwnerCollectionView reloadData];
}

/// 选择业主
- (void)switchAction:(UISwitch *)swith
{
    if (swith.tag == 15001 && ![NSString isNilOrEmpty:_contactPersonName]) {
        if (swith.on) {
            [_newAddTrustorSortNum addObject:@"0"];
        }else{
            [_newAddTrustorSortNum removeObject:@"0"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    
    
    if ([modelClass isEqual:[GetTrustorListEntity class]])
    {
        GetTrustorListEntity *trustorlistEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        [_trustorsArray addObjectsFromArray:trustorlistEntity.trustors];
        
        if (_trustorsArray.count <= 0) {
            showMsg(@"请至少选择或添加一个联系人");
            return;
        }

        _mainWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
        
        _customView = [[MultiSelectView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT) andDataSourceArray:_trustorsArray];
        _customView.delegate = self;
        
        [_mainWindow makeKeyAndVisible];
        [_mainWindow addSubview:_customView];
        
    }
    
    if ([modelClass isEqual:[AgencyBaseEntity class]]) {
        AgencyBaseEntity *reciveEntity = [DataConvert convertDic:data toEntity:modelClass];
        _isSubmit = NO;
        if (reciveEntity.flag == YES) {
            showMsg(@"提交成功");
            
            NSInteger tradingState = [_newOpeningPresenter getTradingState:_tradingState.integerValue andPropertyStatus:_propertyStatus andOpeningStatus:_selectOpeningStatus.itemText];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:2.0f];

            
            if ([_delegate respondsToSelector:@selector(newOpenSuccess:)])
            {
                [_delegate newOpenSuccess:tradingState];
            }
            
            
            
        }else{
            _isSubmit = NO;
            showMsg(@"提交失败，请重试");
        }
    }
    
    [self hiddenLoadingView];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    _isSubmit = NO;

}

@end
