//
//  EditViewController.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/21.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "EditViewController.h"
#import "EditOneSectionCell.h"
#import "CustomActionSheet.h"
#import "GetPropertyDetailApi.h"
#import "EditPropertyApi.h"
#import "EditPropertyDetailEntity.h"

#define PickerViewBaseTag  1000

@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,
UIPickerViewDelegate,UIPickerViewDataSource,doneSelect>
{
    UITableView *_tableView;
    UIPickerView *_mPickerView;
    NSArray *_orientationArr;//朝向数组
    NSArray *_propertyRightArr;//产权性质数组
    NSArray *_purposeArr;//房屋用途数组
    UITextField *_rentTextField;
    UITextField *_saleTextField;

    NSString *_rentPrice;           //租价
    NSString *_salePrice;           //售价
    NSString *_sumSquare;           //房屋总面积
    NSString *_useSuare;            //实用面积
    NSInteger _selectOrientation;   //选择朝向
    NSInteger _selectPropertyRight; //选择产权
    NSInteger _selectpPurpose;      //选择用途
    NSInteger _selectSection;

    SelectItemDtoEntity *_selectOrientationEntity;
    SelectItemDtoEntity *_selectPropertyRightEntity;
    SelectItemDtoEntity *_selectpPurposeEntity;
    EditPropertyDetailEntity *_editPropertyDetailEntity;
}

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNav];
    [self initUI];
    [self initData];
    [self receiveNotificationCenter];
}

#pragma mark - init

- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
}

- (void)initNav
{
    [self setNavTitle:@"编辑房源"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    UIButton *commitBtn = [self customBarItemButton:@"  保存"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(commitClick:)];
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    UIButton *againSetting = [self customBarItemButton:@"重置  "
                                       backgroundImage:nil
                                            foreground:nil
                                                   sel:@selector(setOriginalProgram)];
    
    UIBarButtonItem *againSettingItem = [[UIBarButtonItem alloc]initWithCustomView:againSetting];
    self.navigationItem.rightBarButtonItems = @[commitBtnItem,againSettingItem];
}

- (void)initData
{
    GetPropertyDetailApi *getPropertyDetailApi = [[GetPropertyDetailApi alloc] init];
    getPropertyDetailApi.propertyKeyId = _propertyKeyId;
    [_manager sendRequest:getPropertyDetailApi];
    
    [self showLoadingView:nil];
}

#pragma mark - ClickEvents

/// 保存
- (void)commitClick:(UIButton *)btn
{
    // 收起键盘
     [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    if (_selectOrientationEntity == nil)
    {
        showMsg(@"朝向不能为空!");
        return;
    }

    if (_selectPropertyRightEntity == nil)
    {
        showMsg(@"产权性质不能为空!");
        return;
    }

    if (_selectpPurposeEntity == nil)
    {
        showMsg(@"房屋用途不能为空");
        return;
    }

    if ([_propTrustType isEqualToString:@"1"])
    {
        //售价
        BOOL isNotEmpty = (_salePrice.length > 0)?YES:NO;
        if (!isNotEmpty)
        {
            showMsg(@"售价不能为空!");
            return;
        }
    }

    if ([_propTrustType isEqualToString:@"2"])
    {
        //租价
        BOOL isNotEmpty = (_rentPrice.length > 0)?YES:NO;
        if (!isNotEmpty)
        {
            showMsg(@"租价不能为空!");
            return;
        }
    }

    if ([_propTrustType isEqualToString:@"3"])
    {
        // 售价
        BOOL isNotEmpty1 = (_salePrice.length > 0)?YES:NO;
        // 租价
        BOOL isNotEmpty2 = (_rentPrice.length > 0)?YES:NO;

        if (isNotEmpty1 == NO || isNotEmpty2 == NO)
        {
            showMsg(@"售价或租价不能为空!");
            return;
        }
    }

    BOOL bool1 = (_sumSquare.length == 0 || [_sumSquare isEqualToString:@"0"] || [_sumSquare isEqualToString:@""])?YES:NO;
    BOOL bool2 = (_useSuare.length == 0 || [_useSuare isEqualToString:@"0"] || [_useSuare isEqualToString:@""])?YES:NO;

    if (bool1 && bool2)
    {
        showMsg(@"建筑面积和实用面积不能全部为空！");
        return;
    }

    if (_salePrice.length > 0)
    {
        if ([_salePrice floatValue] < 5.00)
        {
            showMsg(@"售价必须 >= 5万!");
            return;
        }
    }

    if (_rentPrice.length > 0)
    {
        if ([_rentPrice floatValue] < 120.00)
        {
            showMsg(@"租价必须 >= 120元!");
            return;
        }
    }

    EditPropertyApi *editPropertyApi = [[EditPropertyApi alloc] init];
    editPropertyApi.square = _sumSquare;
    editPropertyApi.squareUse = _useSuare;
    editPropertyApi.rentPrice = _rentPrice;
    editPropertyApi.salePrice = _salePrice;
    editPropertyApi.houseDirectionKeyId = _selectOrientationEntity.itemValue;
    editPropertyApi.propertyRightNatureKeyId = _selectPropertyRightEntity.itemValue;
    editPropertyApi.propertyUsageKeyId = _selectpPurposeEntity.itemValue;
    editPropertyApi.trustType = _propTrustType;
    editPropertyApi.keyId = _propertyKeyId;
    [_manager sendRequest:editPropertyApi];
    
    [self showLoadingView:nil];
}

/// 重置
- (void)setOriginalProgram
{
    SysParamItemEntity *entity1 = [AgencySysParamUtil getSysParamByTypeId:8];//朝向
    SysParamItemEntity *entity2 = [AgencySysParamUtil getSysParamByTypeId:53];//产权
    SysParamItemEntity *entity3 = [AgencySysParamUtil getSysParamByTypeId:3];//房屋用途
    
    _orientationArr = entity1.itemList;
    _propertyRightArr = entity2.itemList;
    _purposeArr = entity3.itemList;
    
    _selectOrientation = -1;
    _selectPropertyRight = -1;
    _selectpPurpose = -1;
    
    // 朝向
    for (SelectItemDtoEntity *entity in _orientationArr)
    {
        if ([entity.itemValue isEqualToString:_editPropertyDetailEntity.houseDirectionKeyId])
        {
            _selectOrientationEntity = entity;
            _selectOrientation = [_orientationArr indexOfObject:entity];
            break;
        }
    }
    
    // 产权性质
    for (SelectItemDtoEntity *entity in _propertyRightArr)
    {
        if ([entity.itemValue isEqualToString:_editPropertyDetailEntity.propertyRightNatureKeyId])
        {
            _selectPropertyRightEntity = entity;
            _selectPropertyRight = [_propertyRightArr indexOfObject:entity];
            break;
        }
    }
    
    // 房屋用途
    for (SelectItemDtoEntity *entity in _purposeArr)
    {
        if ([entity.itemValue isEqualToString:_editPropertyDetailEntity.propertyUsageKeyId])
        {
            _selectpPurposeEntity = entity;
            _selectpPurpose = [_purposeArr indexOfObject:entity];

            break;
        }
    }
    
    // 建筑面积
    _sumSquare = _editPropertyDetailEntity.square;
    if ([_sumSquare isEqualToString:@"0.00"])
    {
        _sumSquare = @"";
    }
    
    // 实用面积
    _useSuare = _editPropertyDetailEntity.squareUse;
    if ([_useSuare isEqualToString:@"0.00"])
    {
        _useSuare = @"";
    }
    
    
    if ([_propTrustType isEqualToString:@"1"])
    {
        // 售价
        _salePrice = _editPropertyDetailEntity.salePrice;
        _rentPrice = nil;
        if ([_editPropertyDetailEntity.salePrice isEqualToString:@"0.00"])
        {
            _salePrice = @"";
        }
    }
    else if ([_propTrustType isEqualToString:@"2"])
    {
        // 租价
        _rentPrice = _editPropertyDetailEntity.rentPrice;
        _salePrice = nil;
        if ([_editPropertyDetailEntity.rentPrice isEqualToString:@"0.00"])
        {
            _rentPrice = @"";
        }
    }
    else
    {
        // 售价＋租价
        _salePrice = _editPropertyDetailEntity.salePrice;
        _rentPrice = _editPropertyDetailEntity.rentPrice;
        
        if ([_editPropertyDetailEntity.salePrice isEqualToString:@"0.00"])
        {
            _salePrice = @"";
        }
        if ([_editPropertyDetailEntity.rentPrice isEqualToString:@"0.00"])
        {
            _rentPrice = @"";
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - PermisstionCheck

/// 判断编辑基本信息权限
- (BOOL)isHaveBasicPremission
{
    IdentifyEntity *idenEntity = [AgencyUserPermisstionUtil getIdentify];

    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_BASICINFORMATION_MODIFY_MYSELF])
    {
        //本人---判断该房源是否是本人房源
        if ([_editPropertyDetailEntity.propertyChiefKeyId isEqualToString:idenEntity.uId])
        {
            return YES;
        }
        return NO;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_BASICINFORMATION_MODIFY_MYDEPARTMENT])
    {
        //本部---判断该房源是否是本部房源
        if ([_editPropertyDetailEntity.propertyChiefDepartmentKeyId isEqualToString:idenEntity.departId])
        {
            return YES;
        }
        return NO;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_BASICINFORMATION_MODIFY_ALL])
    {
        //全部
       return YES;
    }

    return NO;
}

/// 判断编辑交易信息权限
- (BOOL)isHaveTransactionPremission
{
    IdentifyEntity *idenEntity = [AgencyUserPermisstionUtil getIdentify];

    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_TRANSACTIONINFORMATION_MODIFY_MYSELF])
    {
        // 本人---判断该房源是否是本人房源
        if ([_editPropertyDetailEntity.propertyChiefKeyId isEqualToString:idenEntity.uId])
        {
            return YES;
        }
        return NO;
    }

    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_TRANSACTIONINFORMATION_MYDEPARTMENT])
    {
        // 本部---判断该房源是否是本部房源
        if ([_editPropertyDetailEntity.propertyChiefDepartmentKeyId isEqualToString:idenEntity.departId])
        {
            return YES;
        }
        return NO;
    }
    
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_TRANSACTIONINFORMATION_MODIFY_ALL])
    {
        // 全部
        return YES;
    }

    return NO;
}

#pragma mark - <UITableViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        _tableView.transform = CGAffineTransformIdentity;

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 3;
    }

    if ([_propTrustType isEqualToString:@"3"])
    {
        // 租售
        return 2;
    }

    // 出租或出售
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
    {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        if ([_propTrustType isEqualToString:@"3"])
        {
            return APP_SCREEN_HEIGHT - 7 * 50 - 64 - 90;
        }
        
        return APP_SCREEN_HEIGHT - 6 * 50 -64 - 90;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 40)];
        label.font =[UIFont systemFontOfSize:16.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = RGBColor(249, 249, 249);
        if (section == 0)
        {
            label.text = @"   基本信息";
        }
        else if (section == 2)
        {
            label.text = @"   交易信息";
        }
        return label;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        CGFloat height;
        if ([_propTrustType isEqualToString:@"3"])
        {
            height = APP_SCREEN_HEIGHT - 7 * 50 - 64 - 90;
        }
        else
        {
            height = APP_SCREEN_HEIGHT - 6 * 50 - 64 - 90;
        }

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH,height)];
        view.backgroundColor = RGBColor(249, 249, 249);
        return view;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一组
    if (indexPath.section == 0)
    {
        NSArray *array = @[@"建筑面积:",@"实用面积:"];
        NSArray *array2 = @[@"㎡",@"㎡"];
        
        EditOneSectionCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EditOneSectionCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.textColor = [UIColor blackColor];
        cell.contentLabel.text = array[indexPath.row];
        cell.unitLabel.text = array2[indexPath.row];
        cell.myTextFiled.delegate = self;
        cell.myTextFiled.tag = 100 + indexPath.row;
        cell.myTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if (indexPath.row == 0)
        {
            cell.myTextFiled.text = _sumSquare;
        }
        else
        {
            cell.myTextFiled.text = _useSuare;
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        // 第二组
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Mycell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Mycell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10 , 80, 30)];
            leftLabel.font = [UIFont systemFontOfSize:16.0];
            leftLabel.textColor = [UIColor redColor];
            leftLabel.tag = 123 + indexPath.row;
            [cell.contentView addSubview:leftLabel];
        }
        
        UILabel *leftLabel = [cell.contentView viewWithTag:123 + indexPath.row];
        NSArray *array = @[@"朝向:",@"产权性质:",@"房屋用途:"];
        leftLabel.text = array[indexPath.row];

        SelectItemDtoEntity *entity;
        if (indexPath.row == 0)
        {
            entity = _selectOrientationEntity;
        }
        else if (indexPath.row == 1)
        {
            entity = _selectPropertyRightEntity;
        }
        else
        {
            entity = _selectpPurposeEntity;
        }

        cell.detailTextLabel.text = entity.itemText;

        return cell;
    }
    
    NSString *salePriceStr = _salePrice;
    NSString *rentPriceStr = _rentPrice;
    
    if (_salePrice)
    {
        salePriceStr = [self cutStringDecimal:_salePrice];
    }
    
    if (_rentPrice)
    {
        rentPriceStr = [self cutStringDecimal:_rentPrice];
    }
    
    // 第三组
    EditOneSectionCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EditOneSectionCell" owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLabel.textColor = [UIColor redColor];
    if ([_propTrustType isEqualToString:@"3"])
    {
        NSArray *array = @[@"售价:",@"租价:"];
        NSArray *array2 = @[@"万",@"元/月"];
        cell.contentLabel.text = array[indexPath.row];
        cell.unitLabel.text = array2[indexPath.row];
        if (indexPath.row == 0)
        {
            cell.myTextFiled.text = salePriceStr;
            _saleTextField = cell.myTextFiled;
        }
        else
        {
            cell.myTextFiled.text = rentPriceStr;
            _rentTextField = cell.myTextFiled;
        }
    }
    else if ([_propTrustType isEqualToString:@"1"])
    {
        cell.contentLabel.text = @"售价";
        cell.unitLabel.text = @"万";
        cell.myTextFiled.text = salePriceStr;
        _saleTextField = cell.myTextFiled;
    }
    else
    {
        cell.contentLabel.text = @"租价";
        cell.unitLabel.text = @"元/月";
        cell.myTextFiled.text = rentPriceStr;
        _rentTextField = cell.myTextFiled;
    }
    cell.myTextFiled.delegate = self;
    cell.myTextFiled.tag = 200 + indexPath.row;
    cell.myTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        // 收起键盘
         [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        // 判断是否有基本信息编辑权限
        BOOL havepremisson = [self isHaveBasicPremission];
        if (havepremisson)
        {
            _selectSection = 1;
            
            NSInteger defaultSelect = 0;
            
            if (indexPath.row == 0)
            {
                // 朝向
                for (SelectItemDtoEntity *entity in _orientationArr)
                {
                    if ([entity.itemValue isEqualToString:_selectOrientationEntity.itemValue])
                    {
                        defaultSelect = [_orientationArr indexOfObject:entity];
                    }
                }
            }
            
            if (indexPath.row == 1)
            {
                // 产权性质
                for (SelectItemDtoEntity *entity in _propertyRightArr)
                {
                    if ([entity.itemValue isEqualToString:_selectPropertyRightEntity.itemValue])
                    {
                        defaultSelect = [_propertyRightArr indexOfObject:entity];
                    }
                }

            }
            
            if (indexPath.row == 2)
            {
                // 房屋用途
                for (SelectItemDtoEntity *entity in _purposeArr)
                {
                    if ([entity.itemValue isEqualToString:_selectpPurposeEntity.itemValue])
                    {
                        defaultSelect = [_purposeArr indexOfObject:entity];
                    }
                }
            }

            [self showPickView:defaultSelect andTagnum:indexPath.row + PickerViewBaseTag];
        }
        else
        {
            showMsg(@"您没有编辑基本信息权限!");
            return;
        }
    }
}

#pragma mark - <UIPickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == PickerViewBaseTag)
    {
        return _orientationArr.count;
    }
    else if (pickerView.tag == PickerViewBaseTag + 1)
    {
        return _propertyRightArr.count;
    }
    
    return _purposeArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSString *cusStr;
    SelectItemDtoEntity *entity;
    
    if (pickerView.tag == PickerViewBaseTag)
    {
        if (_orientationArr.count > 0)
        {
            entity = _orientationArr[row];
        }
    }
    else if (pickerView.tag == PickerViewBaseTag + 1)
    {
        if (_propertyRightArr.count > 0)
        {
            entity = _propertyRightArr[row];
        }
    }
    else
    {
        if (_purposeArr.count > 0)
        {
            entity = _purposeArr[row];
        }
    }
    
    cusStr = entity.itemText;
    
    cusPicLabel.text = cusStr;
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
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
    if (pickerView.tag == PickerViewBaseTag)
    {
        _selectOrientation = row;
    }
    else if (pickerView.tag == PickerViewBaseTag + 1)
    {
        _selectPropertyRight = row;
    }
    else
    {
        _selectpPurpose = row;
    }
}

#pragma mark - PrivateMethod

/// 接受通知
- (void)receiveNotificationCenter
{
    // 使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    // 使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
}

- (CustomActionSheet *)showPickView:(NSInteger)selectIndex andTagnum:(NSInteger)tag
{
    _mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    _mPickerView.dataSource = self;
    _mPickerView.tag = tag;
    _mPickerView.delegate = self;
    [_mPickerView selectRow:selectIndex inComponent:0 animated:YES];

    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_mPickerView AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];

    return sheet;
}

/// 实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    // kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    if (_selectSection == 2)
    {
        [UIView animateWithDuration:0.1 animations:^{
            _tableView.transform = CGAffineTransformMakeTranslation(0, -100);
        }];
    }
}

/// 当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (_selectSection == 2)
    {
        [UIView animateWithDuration:0.1 animations:^{
            _tableView.transform = CGAffineTransformIdentity;
        }];
    }
}

/// 去掉无用的小数点
- (NSString *)cutStringDecimal:(NSString *)str
{
    if (str.length < 3)
    {
        return str;
    }
    NSString *salePriceDecimal = [str substringWithRange:NSMakeRange(str.length - 3, 3)];
    NSString *price = str;
    
    if ([salePriceDecimal isEqualToString:@".00"])
    {
        price = [str substringToIndex:str.length - 3];
    }
    
    return price;
}

#pragma mark - <doneSelect>

/// 确定
- (void)doneSelectItemMethod
{
    SelectItemDtoEntity *entity;
    
    if (_mPickerView.tag == PickerViewBaseTag)
    {
        if (_selectOrientation < 0)
        {
            _selectOrientation = 0;
        }

        entity = _orientationArr[_selectOrientation];
        
        if (_selectOrientationEntity != entity)
        {
            _selectOrientationEntity = entity;
            [_tableView reloadData];
        }
    }
    else if (_mPickerView.tag == PickerViewBaseTag + 1)
    {
        if (_selectPropertyRight < 0)
        {
            _selectPropertyRight = 0;
        }
        
        entity = _propertyRightArr[_selectPropertyRight];
      
        if (_selectPropertyRightEntity != entity)
        {
            _selectPropertyRightEntity = entity;
            [_tableView reloadData];
        }
    }
    else
    {
        if (_selectpPurpose < 0)
        {
            _selectpPurpose = 0;
        }

        entity = _purposeArr[_selectpPurpose];

        if (_selectpPurposeEntity != entity)
        {
            _selectpPurposeEntity = entity;
            [_tableView reloadData];
        }
    }
}

/// 取消
- (void)haveHidden
{

}

#pragma mark - <UITextFieldDelegate>

- (void)textFiledChanged:(NSNotification *)notification
{
    UITextField *textFiled = (UITextField *)notification.object;
    NSString *textStr;

    // 验证是否为纯数字
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:textFiled.text];
    if (!isMatch)
    {
        // 如果不是纯数字
        if (textFiled.text.length == 1)
        {
            showMsg(@"只能输入数字")
            textFiled.text = @"";
        }
        else if (textFiled.text.length > 1)
        {
            // 取出非数字和.的部分的部分
            NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789."]
             invertedSet ];
            NSString *numText  = [[textFiled.text componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
            NSString *notnumText = [textFiled.text stringByReplacingOccurrencesOfString:numText withString:@""];

            if (notnumText.length > 0)
            {
                showMsg(@"只能输入数字")
            }
            textFiled.text = numText;
        }
    }

    textStr = textFiled.text;

    if (textFiled.tag == 100)
    {
        // 建筑面积
         _sumSquare = textStr;
    }
    else if (textFiled.tag == 101)
    {
        // 实用面积
        _useSuare = textStr;
    }
    
    if (textFiled == _saleTextField)
    {
        // 售价
        _salePrice = textStr;
    }
    else if (textFiled == _rentTextField)
    {
        // 租价
        _rentPrice = textStr;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100 || textField.tag == 101)
    {
        // 判断面积是否被锁定
        if ([_editPropertyDetailEntity.isLockSquare integerValue]== 1)
        {
            showMsg(@"该房源面积被锁定,不能更改！");
            return NO;
        }
        
        // 判断是否有编辑基本信息权限
        BOOL havePremisson = [self isHaveBasicPremission];
        if (havePremisson)
        {
            _selectSection = 0;
            return YES;
        }
        else
        {
            return NO;
            showMsg(@"您没有编辑基本信息相关权限!");
        }
    }

    if (textField.tag == 200 || textField.tag == 201)
    {
        // 判断是否有编辑交易信息权限
        BOOL havePremisson = [self isHaveTransactionPremission];
        if (havePremisson)
        {
            _selectSection = 2;
            return YES;
        }
        else
        {
            return NO;
            showMsg(@"您没有编辑交易信息相关权限!");
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "])
    {
        return NO;
    }

    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        
        if (textField == _rentTextField)
        {
            // 租价---正整数  最多八位
            if (textField.text.length > 7)
            {
                return NO;
            }

            if (!(single >= '0' && single <= '9'))
            {
                showMsg(@"租价只能为正整数！");
                return NO;
            }
        }
        else
        {
            if (textField.tag == 100 || textField.tag == 101)
            {
                // 面积
                if (textField.text.length > 9)
                {
                    return NO;
                }
            }

            if (textField == _saleTextField)
            {
                // 售价
                if (textField.text.length > 5)
                {
                    return NO;
                }
            }
            if ([textField.text rangeOfString:@"."].location == NSNotFound)
            {
                isHaveDian = NO;
            }

            if ((single >= '0' && single <= '9') || single == '.')
            {
                // 数据格式正确
                if([textField.text length] == 0)
                {
                    if(single == '.')
                    {
                        showMsg(@"首字符不能为.");
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }

                if (single == '.')
                {
                    // 输入的字符是小数点
                    if(!isHaveDian)
                    {
                        // text中还没有小数点
                        isHaveDian = YES;
                        return YES;
                    }
                    else
                    {
                        showMsg(@"数据格式有误");
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    // 输入的字符不是小数点
                    return YES;
                }
            }
            else
            {
                // 输入的数据格式不正确
                showMsg(@"只能输入数字");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[EditPropertyDetailEntity class]])
    {
        _editPropertyDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [self setOriginalProgram];
    }
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        // 编辑房源成功
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self back];
        });
        
    }
}

- (void)respSuc:(id)data andRespClass:(id)cls
{
    [super respSuc:data andRespClass:cls];
}


@end
