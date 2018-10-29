//
//  BJTurnPrivateCustomerVC.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BJTurnPrivateCustomerVC.h"
#import "AgencyUserPermisstionUtil.h"



#import "BJTurnPrivateCustomerZJPresenter.h"


@interface BJTurnPrivateCustomerVC ()
{
    TurnPrivateCustomerEntity *_turnPrivateCustomerEntity;
    
    NSInteger _pickType;
    
    NSArray *_trustSelectItemDtoArr;
    NSArray *_statusSelectItemDtoArr;
    NSArray *_genderSelectItemDtoArr;
    NSArray *_purchaseReasonSelectItemDtoArr;
    
    NSString *_trustSelected;
    NSString *_genderSelected;
    NSString *_contactTypeSelected;
    NSString *_purchaseReasonSelected;
    
    NSString *_trustValue;
    NSString *_genderValue;
    NSString *_statusValue;
    NSString *_purchaseReasonValue;
    
    NSString *_contactName;
    NSString *_buyPriceFrom;
    NSString *_buyPriceTo;
    NSString *_rentPriceFrom;
    NSString *_rentPriceTo;
    //手机号
    NSString *_newPhoneNumber;
    //座机号
    NSString *_areaCodeString;
    NSString *_telString;
    NSString *_extensionString;
    NSString *_fullTelString;
    
    BOOL _isAdding;
    
    NSInteger _tradeTypeIndex;            //当前选择的交易类型索引
    NSInteger _contactTypeIndex;            //当前选择的联系人状态索引
    NSInteger _contactGenderIndex;            //当前选择的联系人性别索引
    NSInteger _purchaseReasonIndex;         //当前选择的购房原因索引
    
    
    NSString *_defaultStatusKeyId;

    BJTurnPrivateCustomerBasePresenter *_turnPrivateCustomerPresenter;
}


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation BJTurnPrivateCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPresenter];
    [self initNavTitleView];
    
    [self initData];
    
    
}

- (void)initPresenter
{
 
        _turnPrivateCustomerPresenter = [[BJTurnPrivateCustomerZJPresenter alloc] initWithDelegate:self];
   
}

- (void)initData
{
    //默认筛选全部类型的跟进列表
    _tradeTypeIndex = 0;
    _contactTypeIndex = 0;
    _contactGenderIndex = 0;
    _purchaseReasonIndex = 0;
    _fullTelString = @"";
    
    ValidBlackMobileApi *validBlackMobileApi = [[ValidBlackMobileApi alloc] init];
    validBlackMobileApi.mobile = _phoneNumber;
    [_manager sendRequest:validBlackMobileApi sucBlock:^(id result) {
        _turnPrivateCustomerEntity = [DataConvert convertDic:result toEntity:[TurnPrivateCustomerEntity class]];
        if(!_turnPrivateCustomerEntity.flag){
            showMsg(_turnPrivateCustomerEntity.errorMsg);
        }
        
        
    } failBlock:^(NSError *error) {
        _isAdding = NO;
    }];
    
    SysParamItemEntity *clientStatus= [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_STATUS];
    
    NSUInteger sysCount = clientStatus.itemList.count;
    NSString *tagCode = @"100";
    for (int i = 0; i < sysCount; i++) {
        SelectItemDtoEntity *dto = clientStatus.itemList[i];
        if([dto.itemCode isEqualToString:tagCode])
        {
            _defaultStatusKeyId = dto.itemValue;
            break;
        }
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    self.mainTableView.tableFooterView = footerView;
    
    // 点击其他位置，键盘隐藏
    UITapGestureRecognizer *rootViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [footerView addGestureRecognizer:rootViewGesture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
    
    _isAdding = NO;
    
    
    if(![AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_ADD_ALL]){
        showMsg(@(NotHavePermissionTip));
        return;
    }
}

- (void)textChanged:(NSNotification *)text
{
    UITextField *nameTextField = (UITextField *)[self.view viewWithTag:3];
    UITextField *priceFromTextField1 = (UITextField *)[self.view viewWithTag:7];
    UITextField *priceToTextField1 = (UITextField *)[self.view viewWithTag:8];
    UITextField *phoneTextField = (UITextField *)[self.view viewWithTag:14];
    UITextField *areaCodeTextField = (UITextField *)[self.view viewWithTag:15];
    UITextField *telTextField = (UITextField *)[self.view viewWithTag:16];
    UITextField *extensionTextField = (UITextField *)[self.view viewWithTag:17];

    
    NSInteger saleLength = 6;
    NSInteger rentLength = 8;
    NSInteger areaCodeLength = 5;//区号
    NSInteger telLength = 13;
    NSInteger extensionLength = 6;//分机号
    NSInteger phoneLength = 11;
    
    
    //座机号(如果传过来的是手机号  座机才可以编辑)
    if ([CommonMethod isMobile:self.phoneNumber])
    {
        if (areaCodeTextField.text.length > areaCodeLength) {
            areaCodeTextField.text = _areaCodeString;
        }else{
            _areaCodeString = areaCodeTextField.text;
        }
        
        if (telTextField.text.length > telLength) {
            telTextField.text = _telString;
        }else{
            _telString = telTextField.text;
        }
        
        if (extensionTextField.text.length > extensionLength) {
            extensionTextField.text = _extensionString;
        }else{
            _extensionString = extensionTextField.text;
        }
        
        
    }else{
        //修改手机号(如果传过来是座机号,手机号才可以编辑)
        if (phoneTextField.text.length > phoneLength) {
            phoneTextField.text = _newPhoneNumber;
        }else{
            _newPhoneNumber = phoneTextField.text;
        }
    }
    
    
    if(nameTextField.text.length > 20){
        nameTextField.text = _contactName;
    }else
    {
        _contactName = nameTextField.text;
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
    }else{
        
        UITextField *priceFromTextField2 = (UITextField *)[self.view viewWithTag:9];
        UITextField *priceToTextField2 = (UITextField *)[self.view viewWithTag:10];
        
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
    
}

#pragma mark - <初始化导航>
- (void)initNavTitleView
{
    [self setNavTitle:@"转私客"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submit)]];
    
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{//重写textField这个方法
    
    NSLog(@"开始编辑");
    
    NSInteger y = 100;
    
    if (textField.tag == 7||textField.tag == 8||textField.tag == 9 ||textField.tag == 10 ||textField.tag == 15 ||textField.tag == 16||textField.tag == 17)
    {
        y = 200;
    }
    
    if([_trustSelected isEqualToString:@"求购"]){
        if (textField.tag == 7||textField.tag == 8||textField.tag == 9 ||textField.tag == 10 ){
            
            y = 250;
            
        }
    }
    if([_trustSelected isEqualToString:@"租购"]){
        if (textField.tag == 7||textField.tag == 8||textField.tag == 9 ||textField.tag == 10 ){
          
            y = 270;
            
        }
    }
    
    
    CGFloat offset = self.view.frame.size.height - (y + textField.frame.size.height + 216 + 150);
    
    
    if (offset <= 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _mainTableView.y = offset;
            
        }];
        
    }

    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //重写textField这个方法
    NSLog(@"将要结束编辑");
    
    return YES;
}

#pragma mark - <TableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_trustSelected)
    {
        if([_trustSelected isEqualToString:@"租购"]){
            return 10;
        }else if([_trustSelected isEqualToString:@"求购"]){
            return 9;
        }else{
            return 8;
        }
    }
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectionCellIdentifier = @"selectionCell";
    static NSString *inputCellIdentifier = @"inputCell";
    static NSString *priceCellIdentifier = @"priceCell";
    static NSString *showLabelCellIdentifier = @"showLabelCell";
    static NSString *telCellIdentifier = @"addTelCell";

    NSInteger rowIndex = indexPath.row;

    BOOL isSelection = NO;
    BOOL isPrice = NO;
    BOOL firstInput = NO;
    if([_trustSelected isEqualToString:@"租购"]){
        //selection type
        if(rowIndex == 0 || rowIndex == 2 || rowIndex == 4|| rowIndex == 7)
        {
            isSelection = YES;
        }
        if(rowIndex == 8 || rowIndex == 9){
            isPrice = YES;
        }
        if(rowIndex == 8){
            firstInput = YES;
        }
        
    }else if([_trustSelected isEqualToString:@"求购"]){
        if(rowIndex == 0 || rowIndex == 2 || rowIndex == 4|| rowIndex == 7)
        {
            isSelection = YES;
        }
        if(rowIndex == 8 || rowIndex == 9){
            isPrice = YES;
        }
        if(rowIndex == 8){
            firstInput = YES;
        }
        
    }else{
        if(rowIndex == 0 || rowIndex == 2 || rowIndex == 4)
        {
            isSelection = YES;
        }
        if(rowIndex == 7){
            isPrice = YES;
        }
        if(rowIndex == 7){
            firstInput = YES;
        }
    }
    
    
    // selection type
    if(isSelection)
    {
        AddCustomerSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectionCellIdentifier];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"AddCustomerSelectionTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:selectionCellIdentifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:selectionCellIdentifier];
        }
        
        switch (rowIndex) {
            case 0:
                cell.labelForKey.text = @"交易类型:";
                if(_trustSelected)
                {
                    cell.labelForValue.text = _trustSelected;
                }
                else
                {
                    cell.labelForValue.text = @"请选择交易类型";
                }
                break;
            case 2:
                cell.labelForKey.text = @"联系人类型:";
                if(_contactTypeSelected){
                    cell.labelForValue.text = _contactTypeSelected;
                }else{
                    cell.labelForValue.text = @"请选择联系人类型";
                }
                break;
            case 4:
                cell.labelForKey.text = @"联系人性别:";
                if(_genderSelected){
                    cell.labelForValue.text = _genderSelected;
                }else{
                    cell.labelForValue.text = @"请选择联系人性别";
                }
                break;
            case 7:
                cell.labelForKey.text = @"购房原因:";
                if(_purchaseReasonSelected){
                    cell.labelForValue.text = _purchaseReasonSelected;
                }else{
                    cell.labelForValue.text = @"请选择购房原因";
                }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    
    if (rowIndex == 6) {
        
        //座机号码
        if (![CommonMethod isMobile:self.phoneNumber]) {
            //座机号码确定
            TurnCustomerLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showLabelCellIdentifier];
            if (!cell) {
                
                [tableView registerNib:[UINib nibWithNibName:@"TurnCustomerLabelTableViewCell"
                                                      bundle:nil]
                forCellReuseIdentifier:showLabelCellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:showLabelCellIdentifier];
            }
            
            [cell.textFieldForValue setBorderStyle:UITextBorderStyleNone];
            cell.textFieldForValue.userInteractionEnabled = NO;
            cell.labelForKey.text = @"座机：";
            cell.textFieldForValue.text =  self.phoneNumber;
            return cell;

        }else{
            //座机号可编辑
        AddTelephoneCell *cell = [tableView dequeueReusableCellWithIdentifier:telCellIdentifier];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"AddTelephoneCell"
                                                  bundle:nil]
            forCellReuseIdentifier:telCellIdentifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:telCellIdentifier];
        }
        
        
        cell.areaCodeTextField.userInteractionEnabled = YES;
        cell.areaCodeTextField.delegate = self;
        cell.areaCodeTextField.tag = 15;
            
        cell.telTextField.userInteractionEnabled = YES;
        cell.telTextField.delegate = self;
        cell.telTextField.tag = 16;
            
        cell.extensionTextField.userInteractionEnabled = YES;
        cell.extensionTextField.delegate = self;
        cell.extensionTextField.tag = 17;

        
        return cell;
        }
    }
    

    
    //showLabel
    if(rowIndex == 1 || rowIndex == 5)
    {
        TurnCustomerLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:showLabelCellIdentifier];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"TurnCustomerLabelTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:showLabelCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:showLabelCellIdentifier];
        }
        
        [cell.textFieldForValue setBorderStyle:UITextBorderStyleNone];
        cell.textFieldForValue.userInteractionEnabled = YES;

        
        if(rowIndex == 1){
            cell.labelForKey.text = @"来源：";
            cell.textFieldForValue.text = self.channel;
            cell.textFieldForValue.userInteractionEnabled = NO;
        }else{
            cell.labelForKey.text = @"手机：";
            if ([CommonMethod isMobile:self.phoneNumber]) {
                cell.textFieldForValue.text = self.phoneNumber;
                cell.textFieldForValue.userInteractionEnabled = NO;
            }else{
                cell.textFieldForValue.userInteractionEnabled = YES;
                cell.textFieldForValue.delegate = self;
                cell.textFieldForValue.textColor = [UIColor blackColor];
                cell.textFieldForValue.tag = 14;
                [cell.textFieldForValue setBorderStyle:UITextBorderStyleRoundedRect];
            }
        }
        
        return cell;
    }
    
    // input type
    if(rowIndex == 3 )
    {
        AddCustomerInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCellIdentifier];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"AddCustomerInputTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:inputCellIdentifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:inputCellIdentifier];
            
        }
        cell.textForValue.tag = rowIndex;
        
        
        
        switch (rowIndex) {
            case 3:
                cell.labelForKey.text = @"联系人姓名:";
                cell.textForValue.placeholder = @"请输入联系人姓名";
                cell.textForValue.delegate = self;
                break;
            default:
                break;
        }
        
        return cell;
    }
    
    
    
    // price type
    if(isPrice)
    {
        AddCustomerPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceCellIdentifier];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"AddCustomerPriceTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:priceCellIdentifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:priceCellIdentifier];
            
        }
        
        cell.textPriceFrom.delegate = self;
        cell.textPriceTo.delegate = self;
        
        
        
        if ([_trustSelected isEqualToString:@"求租"]) {
            
            cell.textPriceFrom.text = _rentPriceFrom;
            cell.textPriceTo.text = _rentPriceTo;
            
        }else if ([_trustSelected isEqualToString:@"求购"]){
            
            cell.textPriceFrom.text = _buyPriceFrom;
            cell.textPriceTo.text = _buyPriceTo;
            
        }else{
            
            if (firstInput) {
                
                cell.textPriceFrom.text = _buyPriceFrom;
                cell.textPriceTo.text = _buyPriceTo;
            }else{
                
                cell.textPriceFrom.text = _rentPriceFrom;
                cell.textPriceTo.text = _rentPriceTo;
            }
        }
        
        if(firstInput){
            cell.textPriceFrom.tag = 7;
            cell.textPriceTo.tag = 8;
        }else{
            cell.textPriceFrom.tag = 9;
            cell.textPriceTo.tag = 10;
        }
        
        if(firstInput){
            if([_trustSelected isEqualToString:@"求租"]){
                cell.labelForKey.text = @"心理租价(元):";
            }else{
                cell.labelForKey.text = @"心理购价(万元):";
            }
        }else{
            cell.labelForKey.text = @"心理租价(元):";
        }
        
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
    
    switch (indexPath.row) {
        case 0:
            [self tradeTypeTap];
            break;
        case 2:
            [self customerStatusTap];
            break;
        case 4:
            [self customerGenderTap];
            break;
            
        default:
            break;
    }
    
    if([_trustSelected isEqualToString:@"租购"]||[_trustSelected isEqualToString:@"求购"]){
        if(indexPath.row == 7){
            [self purchaseReasonTap];
        }
    }
    
}

#pragma mark - 点击事件处理

#pragma mark - 导航返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 主界面的点击
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - 提交新增私客
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
    
    if(!self.channel){
        showMsg(@"来源不可为空！");
        return;
    }
    
    if(_statusValue == nil ||[_statusValue isEqualToString:@""]){
        showMsg(@"请选择联系人类型！");
        return;
    }

    BOOL isEmpty = [NSString isEmptyWithLineSpace:_contactName];
    if(_contactName == nil||[_contactName isEqualToString:@""] || isEmpty){
        showMsg(@"请输入联系人姓名！");
        return;
    }

    if(_genderValue == nil || [_genderValue isEqualToString:@""]){
        showMsg(@"请选择联系人性别！");
        return;
    }
    
    if([_trustSelected isEqualToString:@"租购"]||[_trustSelected isEqualToString:@"求购"]){
        if(_purchaseReasonValue == nil || [_purchaseReasonValue isEqualToString:@""]){
            showMsg(@"请选择购房原因！");
            return;
        }
    }
    
    // 检查座机号码
    NSString *errorMsg = [_turnPrivateCustomerPresenter checkTelephoneAreaCode:_areaCodeString andTel:_telString andExtension:_extensionString];
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showMsg(errorMsg);
        return;
    }
    
    // 获得座机号码
    _fullTelString = [_turnPrivateCustomerPresenter getTelephoneNumWithAreaCode:_areaCodeString andTel:_telString andExtension:_extensionString andPhoneNum:self.phoneNumber];
    
    if (_newPhoneNumber.length > 0 && ![CommonMethod isMobile:_newPhoneNumber])
    {
        showMsg(@"请输入正确的手机号码!");
        return;
    }
    
    BOOL buyFrom = YES;
    BOOL buyTo = YES;
    BOOL rentFrom = YES;
    BOOL rentTo = YES;
    
    NSString *temp = @"心理购价";
    if([_trustSelected isEqualToString:@"求购"]){
        temp = @"心理购价";
    }else{
        temp = @"心理租价";
    }
    
    NSString *tip = [NSString stringWithFormat:@"请输入%@！",temp];
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
    
    NSString *buyTip = @"心理购价结束价格不得低于心理购价起始价格！";
    NSString *rentTip = @"心理租价结束价格不得低于心理租价起始价格！";
    
    // 求购
    if([_trustValue isEqualToString:@"10"])
    {
        if(!buyFrom || !buyTo){
            showMsg(tip);
            return;
        }
        
        if(mbuyFrom > mbuyTo){
            showMsg(buyTip);
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
        
        if(mrentFrom > mrentTo){
            showMsg(rentTip);
            return;
        }
    }
    // 租购
    if([_trustValue isEqualToString:@"30"])
    {
        if(!buyFrom || !buyTo){
            showMsg(@"请输入心理购价！");
            return;
        }
        if(!rentFrom || !rentTo){
            showMsg(@"请输入心理租价！");
            return;
        }
        
        if(mbuyFrom > mbuyTo){
            showMsg(buyTip);
            return;
        }
        if(mrentFrom > mrentTo){
            showMsg(rentTip);
            return;
        }
    }
    
    
    [self.view endEditing:YES];
    
    _isAdding = YES;
    [self showLoadingView:@"正在添加..."];

    TurnPrivateCustomerApi *turnPrivateCustomerApi = [[TurnPrivateCustomerApi alloc] init];
    turnPrivateCustomerApi.TurnPrivateCustomerType = BJ;
    turnPrivateCustomerApi.contactName = _contactName;
    turnPrivateCustomerApi.inquiryStatusKeyId = _defaultStatusKeyId;
    turnPrivateCustomerApi.channelInquiryKeyId = self.keyId;
    turnPrivateCustomerApi.genderKeyId = _genderValue;
    turnPrivateCustomerApi.contactTypeKeyId = _statusValue;
    turnPrivateCustomerApi.inquirySourceKeyId = _channelKeyId;
    turnPrivateCustomerApi.buyReasonKeyId = _purchaseReasonValue;
    turnPrivateCustomerApi.mobile = _newPhoneNumber?_newPhoneNumber:_phoneNumber;
    turnPrivateCustomerApi.inquiryTradeTypeId = _trustValue;
    turnPrivateCustomerApi.salePriceFrom = _buyPriceFrom;
    turnPrivateCustomerApi.salePriceTo = _buyPriceTo;
    turnPrivateCustomerApi.rentPriceFrom = _rentPriceFrom;
    turnPrivateCustomerApi.rentPriceTo = _rentPriceTo;
    turnPrivateCustomerApi.tel = _fullTelString;
    turnPrivateCustomerApi.isMyPayChannelInquiry = self.isMyPayChannelInquiry;
    
    [_manager sendRequest:turnPrivateCustomerApi sucBlock:^(id result) {
        [self hiddenLoadingView];
        _turnPrivateCustomerEntity = [DataConvert convertDic:result toEntity:[TurnPrivateCustomerEntity class]];

        if(_turnPrivateCustomerEntity.flag)
        {
           // 转私客成功
            if (MODEL_VERSION >= 8.0)
            {
                __weak typeof(self) weakSelf = self;

                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"添加私客成功！"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {

                                                                          [weakSelf back];
                                                                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(turnPrivateDoneInBeijing)]) {
                                                                              [weakSelf.delegate turnPrivateDoneInBeijing];
                                                                          }
                                                                      }];

                [alertCtrl addAction:confirmAction];

                [self presentViewController:alertCtrl
                                   animated:YES
                                 completion:nil];
            }else{

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加私客成功！"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"确定", nil];

                [alert show];

            }

        }else{
            _isAdding = NO;
            showMsg(_turnPrivateCustomerEntity.errorMsg);
        }

    } failBlock:^(NSError *error) {
        _isAdding = NO;

    }];



    NSLog(@"交易类型：%@",_trustValue);
    NSLog(@"来源：%@",self.channel);
    NSLog(@"联系人类型：%@",_contactTypeSelected);
    NSLog(@"联系人姓名：%@",_contactName);
    NSLog(@"联系人性别：%@",_genderSelected);
    NSLog(@"电话：%@",_newPhoneNumber?_newPhoneNumber:_phoneNumber);
    NSLog(@"购房原因：%@---%@",_purchaseReasonSelected,_purchaseReasonValue);
    
    NSLog(@"租价start：%@",_rentPriceFrom);
    NSLog(@"租价end：%@",_rentPriceTo);
    NSLog(@"售价start：%@",_buyPriceFrom);
     NSLog(@"座机电话: %@",_fullTelString);
    NSLog(@"售价end：%@",_buyPriceTo);
   
    
}


#pragma mark - <交易类型选择>
-(void)tradeTypeTap
{
    _trustSelectItemDtoArr = [[NSArray alloc]initWithObjects:@"求租",@"求购",@"租购", nil];
    
    _pickType = 1;
    
    [self showPickView:_tradeTypeIndex];
}

#pragma mark - <联系人类型选择>
- (void)customerStatusTap
{
    
    SysParamItemEntity *statusSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TYPE];
    _statusSelectItemDtoArr = statusSysParamItemEntity.itemList;
    
    _pickType = 2;
    
    [self showPickView:_contactTypeIndex];
}

#pragma mark - <选择性别>
- (void)customerGenderTap
{
    SysParamItemEntity *genderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    _genderSelectItemDtoArr = genderSysParamItemEntity.itemList;
    
    _pickType = 3;
    
    [self showPickView:_contactGenderIndex];
}

#pragma mark - <选择购房原因>
- (void)purchaseReasonTap
{
    SysParamItemEntity *purchaseReason = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PURCHASE_REASON];
    _purchaseReasonSelectItemDtoArr = purchaseReason.itemList;
    
    _pickType = 4;
    
    [self showPickView:_purchaseReasonIndex];
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
    if(_pickType == 1)
    {
        return _trustSelectItemDtoArr.count;
    }else if(_pickType == 2)
    {
        return _statusSelectItemDtoArr.count;
    }else if(_pickType == 3)
    {
        return _genderSelectItemDtoArr.count;
    }else{
        return _purchaseReasonSelectItemDtoArr.count;
    }
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
        case 1:
        {
            cusStr = _trustSelectItemDtoArr[row];
        }
            
            break;
        case 2:
        {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_statusSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case 3:
        {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_genderSelectItemDtoArr[row];
            cusStr = itemDto.itemText;
        }
            break;
        case 4:
        {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_purchaseReasonSelectItemDtoArr[row];
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
        case 1:
        {
            _tradeTypeIndex = row;
        }
            
            break;
        case 2:
        {
            _contactTypeIndex = row;
        }
            break;
        case 3:
        {
            _contactGenderIndex = row;
        }
            break;
        case 4:
        {
            _purchaseReasonIndex = row;
        }
            break;
            
        default:
            break;
    }
}


- (void)doneSelectItemMethod
{
    switch (_pickType) {
        case 1:
        {
            //            _tradeTypeIndex = _tempTradeTypeIndex;
            
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
            
            
            _purchaseReasonIndex = 0;
            _purchaseReasonValue = @"";
            _purchaseReasonSelected = nil;
            
        }
            break;
        case 2:
        {
            //            _customerStatusIndex = _tempCustomerStatusIndex;
            
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_statusSelectItemDtoArr[_contactTypeIndex];
            _contactTypeSelected = itemDto.itemText;
            _statusValue =itemDto.itemValue;
        }
            
            break;
        case 3:
        {
            //            _customerGenderIndex = _tempCustomerGenderIndex;
            
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_genderSelectItemDtoArr[_contactGenderIndex];
            _genderSelected = itemDto.itemText;
            _genderValue =itemDto.itemValue;
        }
            
            break;
            
        case 4:
        {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_purchaseReasonSelectItemDtoArr[_purchaseReasonIndex];
            _purchaseReasonSelected = itemDto.itemText;
            _purchaseReasonValue =itemDto.itemValue;
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


#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    [self.view endEditing:YES];
    _mainTableView.y = 0;
    
}
@end