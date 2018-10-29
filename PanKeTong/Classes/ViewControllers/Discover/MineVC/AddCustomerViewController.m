//
//  AddCustomerViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 15/9/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AddCustomerViewController.h"
#import "AddCustomerApi.h"

#import "NSString+RemoveEmoji.h"
#import "MyClientVC.h"

typedef NS_ENUM(NSInteger, selectType) {
    
    TransactionType = 1, // 交易类型
    CustomerStatus, // 客户状态
    SexSelection,  // 性别选择
    MarriageSelection,  // 婚姻选择
    AreaSelection,   // 区域选择
    BuyHouseReason,  // 购房原因
    PaymentMethon,  // 支付方式
    LayoutOfHouse, // 房型
    DecorationSituation , // 装修情况
    BuildingType , // 建筑类型
    
};

@interface AddCustomerViewController ()<UITextFieldDelegate>
{
    
    
    AddCustomerResultEntity *_addCustomerResultEntity;
    NSInteger _pickType;
    
    NSArray *_trustSelectItemDtoArr;
    NSArray *_statusSelectItemDtoArr;
    NSArray *_genderSelectItemDtoArr;
    NSArray *_marriageSelectItemDtoArr;
    NSArray *_regionSelectItemDtoArr;
    NSArray *_buyHouseReasonItemDtoArr; // 购房原因
    NSMutableArray *_paymentMethonItemDtoArr;  // 支付方式
    NSArray *_layoutOfHouseItemDtoArr;  // 房型
    NSArray *_decorationSituationItemDtoArr;  // 装修情况
    NSArray *_buildingTypeItemDtoArr; // 建筑类型
    
    NSString *_trustSelected;
    NSString *_genderSelected;
    NSString *_marriageSelected;
    NSString *_statusSelected;
    NSString *_regionSelected; // 区域选择
    NSString *_buyHouseReasonsSelected; // 购房原因
    NSString *_paymentMethodSelected; // 付款方式
    NSString *_layoutOfHouseSelected; // 房型
    NSString *_decorationSituationSelected; // 装修情况
    NSString *_buildingTypeSelected; // 建筑类型
    
    NSString *_trustValue;
    NSString *_genderValue;
    NSString *_marriageValue;
    NSString *_statusValue;
    NSString *_regionValue;
    NSString *_buyHouseValue; // 购房原因
    NSString *_paymentMothedValue; // 支付方式
    NSString *_layoutOfHouseValue; //房型
    NSString *_decorationSituationValue; // 装修情况
    NSString *_buildingTypeValue; // 建筑类型
    
    NSString *_customerName;
    NSString *_customerPhone;
    
    NSString *_buyPriceFrom;
    NSString *_buyPriceTo;
    NSString *_rentPriceFrom;
    NSString *_rentPriceTo;
    
    NSString *_areaFrom;
    NSString *_areaTo;
    NSString *_firstPayment;
    
    BOOL _isAdding;
    
    NSInteger _tradeTypeIndex;            //当前选择的交易类型索引
    NSInteger _customerStatusIndex;            //当前选择的客户状态索引
    NSInteger _customerGenderIndex;            //当前选择的客户性别索引
    NSInteger _customerMarriageIndex;           // 当前选择的婚姻索引
    NSInteger _regionGenderIndex;            //当前选择的区域
    NSInteger _buyHouseReasonsIndex;            //当前选择购房原因索引
    NSInteger _paymentMethodIndex;            //当前选择的付款方式索引
    NSInteger _layoutOfHousIndex;           // 房型 当前索引
    NSInteger _deorationSituationIndex;     // 装修情况  当前索引
    NSInteger _buildingTypeIndex;           // 建筑类型  当前索引
    
    UITextField *_nameTextField;
    
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@end

@implementation AddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(![AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_ADD_ALL]){
        showMsg(@(NotHavePermissionTip));
        return;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(searchBarChangeInput:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    [self initNavTitleView];

    [self initData];
    [self initView];
}

- (void)initView {
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AddCustomerSelectionTableViewCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"selectionCell"];
   
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AddCustomerPriceTableViewCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"priceCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AddCustomerInputTableViewCell"
                                          bundle:nil]
    forCellReuseIdentifier:@"inputCell"];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    self.mainTableView.tableFooterView = footerView;
    
    // 点击其他位置，键盘隐藏
    UITapGestureRecognizer *rootViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [footerView addGestureRecognizer:rootViewGesture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
}

- (void)initData
{
    // 区域选择
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_REGION_SELECTION];
    _regionSelectItemDtoArr = genderSysParamItemEntity.itemList;
    
    _paymentMethonItemDtoArr = [NSMutableArray array];
    //默认筛选全部类型的跟进列表
    _tradeTypeIndex = 0;
    _customerStatusIndex = 0;
    _customerGenderIndex = 0;
    _customerMarriageIndex = 0;
    _buyHouseReasonsIndex = 0;
    _paymentMethodIndex = 0;
    _layoutOfHousIndex = 0;
    _deorationSituationIndex = 0;
    _buildingTypeIndex = 0;
    
    _isAdding = NO;
}



- (void)textChanged:(NSNotification *)text
{
    UITextField *nameTextField = (UITextField *)[self.view viewWithTag:2];
    UITextField *phoneTextField = (UITextField *)[self.view viewWithTag:4];
    UITextField *priceFromTextField1 = (UITextField *)[self.view viewWithTag:15];
    UITextField *priceToTextField1 = (UITextField *)[self.view viewWithTag:16];
    
    NSInteger saleLength = 6;
    NSInteger rentLength = 8;
    
    if (nameTextField)
    {
        if(nameTextField.text.length > 20){
            nameTextField.text = _customerName;
        }else
        {
            _customerName = nameTextField.text;
        }

    }
    
    if([_trustSelected isEqualToString:@"求租"]){
        
        if(priceFromTextField1.text.length > rentLength){
            priceFromTextField1.text = _rentPriceFrom;
        }else
        {
            _rentPriceFrom = priceFromTextField1.text;
        }
        
        if(priceToTextField1.text.length > rentLength){
            priceToTextField1.text = _rentPriceTo;
        }else
        {
            _rentPriceTo = priceToTextField1.text;
        }
        
    }else if([_trustSelected isEqualToString:@"求购"]){
        
        if(priceFromTextField1.text.length > saleLength){
            priceFromTextField1.text = _buyPriceFrom;
        }else
        {
            _buyPriceFrom = priceFromTextField1.text;
        }
        
        if(priceToTextField1.text.length > saleLength){
            priceToTextField1.text = _buyPriceTo;
        }else
        {
            _buyPriceTo = priceToTextField1.text;
        }
    }
    else
    {
        UITextField *priceFromTextField2 = (UITextField *)[self.view viewWithTag:17];
        UITextField *priceToTextField2 = (UITextField *)[self.view viewWithTag:18];
        
        if(priceFromTextField1.text.length > saleLength){
            priceFromTextField1.text = _buyPriceFrom;
        }else
        {
            _buyPriceFrom = priceFromTextField1.text;
        }
        
        if(priceToTextField1.text.length > saleLength){
            priceToTextField1.text = _buyPriceTo;
        }else
        {
            _buyPriceTo = priceToTextField1.text;
        }
        
        if(priceFromTextField2.text.length > rentLength){
            priceFromTextField2.text = _rentPriceFrom;
        }else
        {
            _rentPriceFrom = priceFromTextField2.text;
        }
        
        if(priceToTextField2.text.length > rentLength){
            priceToTextField2.text = _rentPriceTo;
        }else
        {
            _rentPriceTo = priceToTextField2.text;
        }
    }
    
    if(phoneTextField.text.length > 11){
        phoneTextField.text = _customerPhone;
    }else
    {
        _customerPhone = phoneTextField.text;
    }
}


#pragma mark - <初始化导航栏>
- (void)initNavTitleView
{
    [self setNavTitle:@"新增客户"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submit)]];
}

#pragma mark-<UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 系统九宫格
    if ([string isEqualToString:@"➋"]||[string isEqualToString:@"➌"]||[string isEqualToString:@"➍"]||[string isEqualToString:@"➎"]
        ||[string isEqualToString:@"➏"]||[string isEqualToString:@"➐"]||[string isEqualToString:@"➑"]||[string isEqualToString:@"➒"])
    {
        return YES;
    }
    
    //   限制苹果系统输入法  禁止输入表情
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
    }
    //禁止输入emoji表情
    if ([self stringContainsEmoji:string]) {
        return NO;
    }
    
    return YES;
}

//判断是否输入了emoji 表情

- (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    
                                    if (substring.length > 1) {
                                        
                                        const unichar ls = [substring characterAtIndex:1];
                                        
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            
                                            returnValue = YES;
                                            
                                        }
                                        
                                    }
                                    
                                } else if (substring.length > 1) {
                                    
                                    const unichar ls = [substring characterAtIndex:1];
                                    
                                    if (ls == 0x20e3) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                    
                                    
                                } else {
                                    
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        
                                        returnValue = YES;
                                        
                                    }else if (hs == 0x200d){
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                }
                                
                            }];
    
    
    
    return returnValue;
    
}

#pragma mark - 搜索框监听的回调方法
- (void)searchBarChangeInput:(NSNotification *)notificationObj
{
    //禁止输入emoji表情
    if ([self stringContainsEmoji:_nameTextField.text]) {
        NSString* removedEmoji = [_nameTextField.text removedEmojiString];
        _customerName = removedEmoji;
        _nameTextField.text  = removedEmoji;
    }
}

#pragma mark - ************TableView**********

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       
            return 6;
        
    }else {
        
        if(_trustSelected)
        {
            if([_trustSelected isEqualToString:@"租购"]){
                return 2;
            }else{
                return 1;
            }
        }
        return 1;
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowIndex = indexPath.row;
    
    if (indexPath.section == 0) {
        
            if(rowIndex == 0 || rowIndex == 1 || rowIndex == 3 || rowIndex == 5)
            {
                AddCustomerSelectionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"selectionCell" forIndexPath:indexPath];
              
                
                switch (rowIndex) {
                    case 0:
                        [cell setupLeftTitleWithString:@"*  交易类型"];
                      
                        if(_trustSelected){
                            cell.labelForValue.text = _trustSelected;
                        }else{
                            cell.labelForValue.text = @"请选择交易类型";
                        }
                        
                        break;
                    case 1:
                        [cell setupLeftTitleWithString:@"*  客户状态"];
                       
                        if(_statusSelected){
                            cell.labelForValue.text = _statusSelected;
                        }else{
                            cell.labelForValue.text = @"请选择客户状态";
                        }
                        
                        break;
                    case 3:
                        [cell setupLeftTitleWithString:@"*  联系人性别"];
                        
                        if(_genderSelected){
                            cell.labelForValue.text = _genderSelected;
                        }else{
                            cell.labelForValue.text = @"请选择联系人性别";
                        }
                        break;
                    case 5:
                        [cell setupLeftTitleWithString:@"*  婚姻情况"];
                       
                        if(_marriageSelected){
                            cell.labelForValue.text = _marriageSelected;
                        }else{
                            cell.labelForValue.text = @"请选择婚姻情况";
                        }
                        
                        break;
                        
                    default:
                        break;
                }
                
                if ([cell.labelForValue.text contains:@"请选择"]) {
                    
                    cell.labelForValue.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
                    
                }else{
                    cell.labelForValue.textColor = YCTextColorBlack;
                    
                }
                
                
                
                
                
                
                return cell;
          
            }else {  //if(rowIndex == 2 || rowIndex == 4)
                
                AddCustomerInputTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"inputCell"];
               
                cell.textForValue.tag = rowIndex;
                
                switch (rowIndex) {
                    case 2:
                        [cell setupLeftTitleWithString:@"*  联系人姓名"];
                        cell.textForValue.placeholder = @"请输入联系人姓名";
                        cell.textForValue.text = _customerName ? _customerName : @"";
                        cell.textForValue.delegate = self;
                        _nameTextField = cell.textForValue;
                        break;
                    case 4:
                        [cell setupLeftTitleWithString:@"*  电话"];
                        cell.textForValue.placeholder = @"请输入联系人电话";
                        cell.textForValue.keyboardType = UIKeyboardTypeNumberPad;
                        cell.textForValue.text = _customerPhone ? _customerPhone : @"";
                        break;
                    default:
                        break;
                }
                
                return cell;
            }
  
        

    }else  { // 心理租价/心理购价
        
            AddCustomerPriceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
        
            
            
            if ([_trustSelected isEqualToString:@"求租"]) {
                
                cell.textPriceFrom.text = _rentPriceFrom;
                cell.textPriceTo.text = _rentPriceTo;
                
            }else if ([_trustSelected isEqualToString:@"求购"]){
                
                cell.textPriceFrom.text = _buyPriceFrom;
                cell.textPriceTo.text = _buyPriceTo;
                
            }else{
                
                if (rowIndex == 0) {
                    
                    cell.textPriceFrom.text = _buyPriceFrom;
                    cell.textPriceTo.text = _buyPriceTo;
                }else if (rowIndex == 1){
                    
                    cell.textPriceFrom.text = _rentPriceFrom;
                    cell.textPriceTo.text = _rentPriceTo;
                }
            }
            
            if(rowIndex == 0){
                cell.textPriceFrom.tag = 15;
                cell.textPriceTo.tag = 16;
            }else{
                cell.textPriceFrom.tag = 17;
                cell.textPriceTo.tag = 18;
            }
            
            if(rowIndex == 0)
            {
                if([_trustSelected isEqualToString:@"求租"])
                {
                    [cell setupLeftTitleWithString:@"*  心理租价(元)"];
                }else{
                    [cell setupLeftTitleWithString:@"*  心理购价(万元)"];
                }
            }
            else
            {
                [cell setupLeftTitleWithString:@"*  心理租价(元)"];
            }
            
            return cell;
        
    }
    
}

#pragma mark - <TableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
    
    if (indexPath.section == 0)
    {
        // 是否含有区域选择

            switch (indexPath.row) {
                case 0:
                    [self tradeTypeTap];
                    break;
                case 1:
                    [self customerStatusTap];
                    break;
                case 3:
                    [self customerGenderTap];
                    break;
                case 5:
                    [self customerMarriage];
                    break;
                default:
                    break;
            
            
        }

    }
    
 
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 10)];//
    
    //add your code behind
    view.backgroundColor = RGBColor(242, 242, 242);
    
    if(section == 0){
        view.height = 0;
    }
    
    return view;
    
}

//自定义section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    return 10.0;
}


#pragma mark - <主界面的点击>
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - ***提交新增客户****
- (void)submit
{
    if(![AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_ADD_ALL]){
        showMsg(@(NotHavePermissionTip));
        return;
    }
    
    if(_isAdding){
        return;
    }
    
    
    if(_trustValue ==nil || [_trustValue isEqualToString:@""]){
        showMsg(@"请选择交易类型！");
        [self hiddenLoadingView];
        return;
    }
    
    if(_statusValue == nil ||[_statusValue isEqualToString:@""]){
        showMsg(@"请选择客户状态！");
        return;
    }

    BOOL isEmpty = [NSString isEmptyWithLineSpace:_customerName];
    if(_customerName == nil||[_customerName isEqualToString:@""] || isEmpty){
        showMsg(@"请输入客户姓名！");
        return;
    }
    if(_genderValue == nil || [_genderValue isEqualToString:@""]){
        showMsg(@"请选择联系人性别！");
        return;
    }
    if(_marriageValue == nil || [_marriageValue isEqualToString:@""]){
        showMsg(@"请选择客户婚姻情况！");
        return;
    }
    if(_customerPhone == nil || [_customerPhone isEqualToString:@""]){
        showMsg(@"请输入联系人电话！");
        return;
    }
    
     // 验证手机号
    if(![CommonMethod isMobile:_customerPhone]){
        showMsg(@"请输入正确的手机号码！");
        return;
    }
    
    
    BOOL buyFrom = YES;
    BOOL buyTo = YES;
    BOOL rentFrom = YES;
    BOOL rentTo = YES;
    
    NSString *temp = _trustSelected == nil ? @"求购":_trustSelected;
    NSString *tip = [NSString stringWithFormat:@"请输入心理%@价格！",temp];
    if(_buyPriceFrom == nil || [_buyPriceFrom isEqualToString:@""])
    {
        buyFrom = NO;
    }
    if(_buyPriceTo == nil || [_buyPriceTo isEqualToString:@""])
    {
        buyTo = NO;
    }
    if(_rentPriceFrom == nil || [_rentPriceFrom isEqualToString:@""])
    {
        rentFrom = NO;
    }
    if(_rentPriceTo == nil || [_rentPriceTo isEqualToString:@""])
    {
        rentTo = NO;
    }
    
    if(_buyPriceFrom == nil){
        _buyPriceFrom = @"";
    }
    if(_buyPriceTo == nil){
        _buyPriceTo = @"";
    }
    if(_rentPriceFrom == nil){
        _rentPriceFrom = @"";
    }
    if(_rentPriceTo == nil){
        _rentPriceTo = @"";
    }
    
    NSInteger mrentFrom = [_rentPriceFrom integerValue];
    NSInteger mrentTo = [_rentPriceTo integerValue];
    NSInteger mbuyFrom = [_buyPriceFrom integerValue];
    NSInteger mbuyTo = [_buyPriceTo integerValue];
    
    // 求购
    if([_trustValue isEqualToString:@"10"])
    {
        if(!buyFrom || !buyTo){
            showMsg(tip);
            return;
        }
        
        if ( ![NSString isNum:_buyPriceFrom] || ![NSString isNum:_buyPriceTo])
        {
            showMsg(@"价格必须为整数！");
            return;
        }
        
        if(mbuyFrom > mbuyTo){
            showMsg(@"结束价格不得低于起始价格！");
            return;
        }

    }
    // 求租
    if([_trustValue isEqualToString:@"20"])
    {
        if(!rentFrom || !rentTo){
            showMsg(tip);
            return;
        }
        
        if (![NSString isNum:_rentPriceFrom] || ![NSString isNum:_rentPriceTo] )
        {
            showMsg(@"价格必须为整数！");
            return;
        }

        
        if(mrentFrom > mrentTo){
            showMsg(@"结束价格不得低于起始价格！");
            return;
        }
    }
    // 租购
    if([_trustValue isEqualToString:@"30"])
    {
        if(!buyFrom || !buyTo){
            showMsg(@"请输入心理求购价格！");
            return;
        }
        if(!rentFrom || !rentTo){
            showMsg(@"请输入心理求租价格！");
            return;
        }
        
        if (![NSString isNum:_rentPriceFrom] || ![NSString isNum:_rentPriceTo] || ![NSString isNum:_buyPriceFrom] || ![NSString isNum:_buyPriceTo])
        {
            showMsg(@"价格必须为整数！");
            return;
        }
        
        if(mbuyFrom > mbuyTo){
            showMsg(@"结束价格不得低于起始价格！");
            return;
        }
        if(mrentFrom > mrentTo){
            showMsg(@"结束价格不得低于起始价格！");
            return;
        }
    }


    [self.view endEditing:YES];
    
    _isAdding = YES;
    [self showLoadingView:@"正在添加..."];

    AddCustomerApi *addCustomerApi = [[AddCustomerApi alloc] init];
    addCustomerApi.contactName = _customerName;
    addCustomerApi.genderKeyId = _genderValue;
    addCustomerApi.maritalStatusKeyId = _marriageValue;
    addCustomerApi.mobile = _customerPhone;
    addCustomerApi.inquiryTradeTypeCode = _trustValue;
    addCustomerApi.salePriceFrom = _buyPriceFrom;
    addCustomerApi.salePriceTo = _buyPriceTo;
    addCustomerApi.rentPriceFrom = _rentPriceFrom;
    addCustomerApi.rentPriceTo = _rentPriceTo;
    addCustomerApi.inquiryStatusKeyId = _statusValue;
    addCustomerApi.mobileAttribution = _regionValue ? _regionValue : @"";
    addCustomerApi.buyReasonKeyId = _buyHouseValue;
    addCustomerApi.inquiryPaymentTypeCode = _paymentMothedValue;
    addCustomerApi.firstPayment = _firstPayment;
    addCustomerApi.houseTypes = _layoutOfHouseValue ? @[_layoutOfHouseValue] : [NSArray array];
    addCustomerApi.areaFrom = _areaFrom;
    addCustomerApi.areaTo = _areaTo;
    addCustomerApi.decorationSituationKeyId = _decorationSituationValue;
    addCustomerApi.propertyTypeKeyId = _buildingTypeValue;
    
    [_manager sendRequest:addCustomerApi];

}

#pragma mark - <交易类型选择>
- (void)tradeTypeTap
{
    _trustSelectItemDtoArr = [[NSArray alloc]initWithObjects:@"求租",@"求购",@"租购", nil];
    
    _pickType = TransactionType;
    
    [self showPickView:_tradeTypeIndex];
}

#pragma mark - <客户状态选择>
- (void)customerStatusTap {
    SysParamItemEntity *statusSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_STATUS];
  
    _statusSelectItemDtoArr = [AgencySysParamUtil selectItemDtoSortValid:statusSysParamItemEntity.itemList];
    
    _pickType = CustomerStatus;
    
    [self showPickView:_customerStatusIndex];
}


#pragma mark - <选择性别>
-(void)customerGenderTap
{
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    _genderSelectItemDtoArr = genderSysParamItemEntity.itemList;
    
    _pickType = SexSelection;
    
    [self showPickView:_customerGenderIndex];
}
// 婚姻情况
- (void)customerMarriage {
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_MARRIAGE_STATUS];
    _marriageSelectItemDtoArr = genderSysParamItemEntity.itemList;
    
    _pickType = MarriageSelection;
    
    [self showPickView:_customerMarriageIndex];
}



#pragma mark - [私有方法]
- (CustomActionSheet *)showPickView:(NSInteger)selectIndex
{
    
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                               40,
                                                                               APP_SCREEN_WIDTH,
                                                                               180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    [mPickerView selectRow:selectIndex
                         inComponent:0
                            animated:YES];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView
                                                             AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    return sheet;
}

#pragma mark - <PickerViewDelegate>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_pickType == TransactionType)
    {
        // 交易类型
        return _trustSelectItemDtoArr.count;
    }else if(_pickType == CustomerStatus)
    {
        // 客户状态
        return _statusSelectItemDtoArr.count;
    }else if(_pickType == SexSelection)
    {
        // 性别选择
        return _genderSelectItemDtoArr.count;
    }else if(_pickType == MarriageSelection)
    {
        // 婚姻情况
        return _marriageSelectItemDtoArr.count;
    }else if(_pickType == AreaSelection)
    {
        // 区域选择
        return _regionSelectItemDtoArr.count;
    }
    else if(_pickType == BuyHouseReason)
    {
        // 购房原因
        return _buyHouseReasonItemDtoArr.count;
    }
    else if(_pickType == PaymentMethon)
    {
        // 支付方式
        return _paymentMethonItemDtoArr.count;
    }
    else if(_pickType == LayoutOfHouse)
    {
        // 房型
        return _layoutOfHouseItemDtoArr.count;
    }
    else if(_pickType == DecorationSituation)
    {
        // 装修情况
        return _decorationSituationItemDtoArr.count;
    }
    else if(_pickType == BuildingType)
    {
        // 装修情况
        return _buildingTypeItemDtoArr.count;
    }
    
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSString *cusStr;
    switch (_pickType) {
        case TransactionType:
        {
            // 交易类型
            cusStr = _trustSelectItemDtoArr[row];
        }
            
            break;
        case CustomerStatus:
        {
            // 客户状态
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_statusSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case SexSelection:
        {
            // 性别选择
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_genderSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case MarriageSelection:
        {
            // 婚姻情况
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_marriageSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case AreaSelection:
        {
            // 区域选择
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_regionSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case BuyHouseReason:
        {
            // 购房原因
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_buyHouseReasonItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case PaymentMethon:
        {
            // 支付方式
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_paymentMethonItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case LayoutOfHouse:
        {
            // 房型
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_layoutOfHouseItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case DecorationSituation:
        {
            // 装修情况
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_decorationSituationItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case BuildingType:
        {
            // 建筑类型
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_buildingTypeItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
            
            
        default:
            break;
    }
    
    
    cusPicLabel.text = cusStr;
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_pickType) {
        case TransactionType:
        {
            // 交易类型
            _tradeTypeIndex = row;
        }
            
            break;
        case CustomerStatus:
        {
            // 客户状态
            _customerStatusIndex = row;
        }
            break;
        case SexSelection:
        {
            // 性别选择
            _customerGenderIndex = row;
        }
            break;
        case MarriageSelection:
        {
            // 婚姻情况
            _customerMarriageIndex = row;
        }
            break;
        case AreaSelection:
        {
            // 区域选择
            _regionGenderIndex = row;
        }
            break;
        case BuyHouseReason:
        {
            // 购房原因
            _buyHouseReasonsIndex = row;
        }
            break;
        case PaymentMethon:
        {
            // 支付方式
            _paymentMethodIndex = row;
        }
            break;
        case LayoutOfHouse:
        {
            // 房型
            _layoutOfHousIndex = row;
        }
            break;
        case DecorationSituation:
        {
            // 装修方式
            _deorationSituationIndex = row;
        }
            break;
        case BuildingType:
        {
            // 建筑类型
            _buildingTypeIndex = row;
        }
            break;
        default:
            break;
    }
}


- (void)doneSelectItemMethod
{
    switch (_pickType) {
            
        case TransactionType: {
            // 交易类型
            _trustSelected = _trustSelectItemDtoArr[_tradeTypeIndex];
            if([_trustSelected isEqualToString:@"求购"]){
                _trustValue = @"10";
            }else if([_trustSelected isEqualToString:@"求租"]){
                _trustValue = @"20";
            }else{
                _trustValue = @"30";
            }
            
            /**
             *  修改“交易类型”后需要清空购价、租价
             */
            _buyPriceFrom = nil;
            _buyPriceTo = nil;
            _rentPriceFrom = nil;
            _rentPriceTo = nil;
            
        }
            break;
        case CustomerStatus:
        {
            // 客户状态
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_statusSelectItemDtoArr[_customerStatusIndex];
            _statusSelected = itemDto.itemText;
            _statusValue =itemDto.itemValue;
        }
            
            break;
        case SexSelection:
        {
            // 性别选择
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_genderSelectItemDtoArr[_customerGenderIndex];
            _genderSelected = itemDto.itemText;
            _genderValue =itemDto.itemValue;
        }
            break;
        case MarriageSelection:
        {
            // 婚姻情况
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_marriageSelectItemDtoArr[_customerMarriageIndex];
            _marriageSelected = itemDto.itemText;
            _marriageValue =itemDto.itemValue;
        }
            break;
        case AreaSelection:
        {
            // 区域选择
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_regionSelectItemDtoArr[_regionGenderIndex];
            _regionSelected = itemDto.itemText;
            _regionValue = itemDto.itemCode;
        }
            break;
        case BuyHouseReason:
        {
            // 购房原因
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_buyHouseReasonItemDtoArr[_buyHouseReasonsIndex];
            _buyHouseReasonsSelected = itemDto.itemText;
            _buyHouseValue =itemDto.itemValue;
        }
            break;
        case PaymentMethon:
        {
            // 支付方式
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_paymentMethonItemDtoArr[_paymentMethodIndex];
            _paymentMethodSelected = itemDto.itemText;
            _paymentMothedValue = itemDto.itemCode;
            
            [_mainTableView reloadData];
        }
            break;
        case LayoutOfHouse:
        {
            // 房型
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_layoutOfHouseItemDtoArr[_layoutOfHousIndex];
            _layoutOfHouseSelected = itemDto.itemText;
            _layoutOfHouseValue = itemDto.itemValue;
        }
            break;
        case DecorationSituation:
        {
            // 房型
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_decorationSituationItemDtoArr[_deorationSituationIndex];
            _decorationSituationSelected = itemDto.itemText;
            _decorationSituationValue = itemDto.itemValue;
        }
            break;
        case BuildingType:
        {
            // 建筑类型
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_buildingTypeItemDtoArr[_buildingTypeIndex];
            _buildingTypeSelected = itemDto.itemText;
            _buildingTypeValue = itemDto.itemValue;
        }
            break;
            
        default:
            break;
    }
    
    [_mainTableView reloadData];
}


#pragma mark - <UIAlertDialogDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass{
    [self hiddenLoadingView];
    if ([modelClass isEqual:[AddCustomerResultEntity class]]) {
        _addCustomerResultEntity = [DataConvert convertDic:data toEntity:modelClass];

        if(_addCustomerResultEntity.flag){

            /**
             添加客户成功
             */

            __weak typeof(self) weakSelf = self;

            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"添加成功！"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action)
            {
                if (self.isFromHomePage)
                {
                    MyClientVC *vc = [[MyClientVC alloc] init];
                    vc.isPopToRoot = self.isFromHomePage;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [weakSelf back];
                }

                if ([self.delegate respondsToSelector:@selector(backAddCustomerListViewController)]) {
                    [self.delegate backAddCustomerListViewController];
                }
            }];

            [alertCtrl addAction:confirmAction];

            [self presentViewController:alertCtrl
                               animated:YES
                             completion:nil];
        }
        else
        {
            _isAdding = NO;
            showMsg(@"添加失败！");
        }

    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    _isAdding = NO;

}

@end
