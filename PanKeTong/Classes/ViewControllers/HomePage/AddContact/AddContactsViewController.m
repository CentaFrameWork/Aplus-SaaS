//
//  AddContactsViewController.m
//  PanKeTong
//
//  Created by TailC on 16/4/5.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AddContactsViewController.h"
#import "ApplyTransferEstSelectItemCell.h"
#import "ApplyTransferEstInputItemCell.h"
#import "TCPickView.h"
#import "ApplyReasonInputCell.h"
#import "ApplyTransferPubEstRemindPersonCell.h"
#import "PropertyFollowAllAddApi.h"
#import "PropertysModelEntty.h"
#import "PropertyFollowAllAddEntity.h"
#import "FollowTypeDefine.h"
#import "DateTimePickerDialog.h"
#import "CustomActionSheet.h"

#define MobileTextfieldTag  5000
#define FollowIpTextfieldTag    6000    // 跟进
#define ContactsTextfieldTag    6001    // 联系人

typedef NS_ENUM(NSInteger, selectType) {
    ContactsType = 1,   // 联系人类型
    SexSelection,       // 性别选择
    RegionalChoice,     // 区域选择
};

#pragma mark Staic
static NSString * const defealtSelectCellID = @"applyTransferEstSelectItemCell";
static NSString * const ApplyTransferEstInputItemCellID = @"applyTransferEstInputItemCell";
static NSString * const followCententCellID = @"applyReasonInputCell";
static NSString * const ApplyTransferPubEstRemindPersonCellID = @"applyTransferPubEstRemindPersonCell";
static NSString * const RemindTimeCellID = @"kRemindTimeCellID";

/** 
 *  数据库字段 
 */
static NSString * const AddContactsViewController_ContactType = @"AddContactsViewController_ContactType";
static NSString * const AddContactsViewController_ContactRender = @"AddContactsViewController_ContactRender";

@interface AddContactsViewController ()<UITableViewDelegate,UITableViewDataSource,DateTimeSelected,
UITextViewDelegate,doneSelect,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UICollectionView *remindPersonCollectionView;

@property (assign,nonatomic) BOOL isSubmit;

@property (nonatomic,readwrite,strong) NSDate *selectedDate;
@property (nonatomic,readwrite,strong) DateTimePickerDialog *dateTimePickerDialog;

@property (nonatomic,readwrite,strong) TCPickView *typePickView;        // 联系人类型选择器
@property (nonatomic,readwrite,strong) TCPickView *renderPickView;		// 性别选择器
@property (nonatomic,readwrite,strong) TCPickView *phoneTypePickView;	// 手机号类型选择器

@property (nonatomic,readwrite,strong) NSMutableArray *typeNameArr;		// 联系人类型名
@property (nonatomic,readwrite,strong) NSMutableArray *typeIdArr;		// 联系人类型ID
@property (nonatomic,readwrite,strong) NSMutableArray *renderNameArr;	// 性别名
@property (nonatomic,readwrite,strong) NSMutableArray *renderIdArr;		// 性别ID

@property (nonatomic, assign) NSInteger pickType;
@property (nonatomic, assign) NSInteger contactsTypeIndex;              // 联系人类型 当前索引
@property (nonatomic, assign) NSInteger sexSelectionIndex;              // 性别 当前索引
@property (nonatomic, assign) NSInteger regionalChoiceIndex;            // 区域选择 当前索引


@property (nonatomic, strong)NSDate *oldTime;                           // 记录时间


@end

@implementation AddContactsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    
	[self initNavigationBar];
	[self initTableView];
	[self initData];
	[self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}

#pragma mark - init

- (void)initView
{
	self.typePickView = [[TCPickView alloc] initPickViewWithArray:@[self.typeNameArr]];
	self.renderPickView = [[TCPickView alloc] initPickViewWithArray:@[self.renderNameArr]];
    
}



- (void)initData
{
	self.typeIdArr = [[NSMutableArray alloc] init];
	self.typeNameArr = [[NSMutableArray alloc] init];
	self.renderIdArr = [[NSMutableArray alloc] init];
	self.renderNameArr = [[NSMutableArray alloc] init];
    self.phoneTypeArray = [NSMutableArray array];
    self.phoneTypeVauleArray = [NSMutableArray array];
    
	_isSubmit = NO;
    _contactsTypeIndex = 0;
    _sexSelectionIndex = 0;
    _regionalChoiceIndex = 0;
    
	_propertyFollowAllAddEntity = [[PropertyFollowAllAddEntity alloc] init];
	_propertyFollowAllAddEntity.FollowType = 5;
	_propertyFollowAllAddEntity.PropertyKeyId = _propertyKeyId;
	_propertyFollowAllAddEntity.FollowType = PropertyFollowTypeAddLinker;
	
	// 获取联系人类型&ID 性别类型&ID
	SysParamItemEntity *sysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_TRUST_CONTACT_TYPE];
    SysParamItemEntity *renderSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    SysParamItemEntity *regionSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_REGION_SELECTION];

	NSArray *itemList = sysParamItemEntity.itemList;
    NSArray *renderItemList = renderSysParamItemEntity.itemList;
    NSArray *regionItemList = regionSysParamItemEntity.itemList;
    
    for (SelectItemDtoEntity *typeEntity in itemList)
    {
		[self.typeNameArr addObject:typeEntity.itemText];
		[self.typeIdArr addObject:typeEntity.itemValue];
	}
    
	for (SelectItemDtoEntity *entity in renderItemList)
    {
		[self.renderNameArr addObject:entity.itemText];
		[self.renderIdArr addObject:entity.itemValue];
	}
    
    for (SelectItemDtoEntity *entity in regionItemList)
    {
        [self.phoneTypeArray addObject:entity.itemText];
        [self.phoneTypeVauleArray addObject:entity.itemCode];
    }
    
    _regionalChoiceIndex  = [self.phoneTypeArray indexOfObject:@"大陆"];
}

- (void)initTableView
{
    _tableView.tableFooterView=[[UITableViewHeaderFooterView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstSelectItemCell" bundle:nil]
     forCellReuseIdentifier:defealtSelectCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyTransferEstInputItemCell" bundle:nil]
     forCellReuseIdentifier:ApplyTransferEstInputItemCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyReasonInputCell" bundle:nil]
     forCellReuseIdentifier:followCententCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyTransferPubEstRemindPersonCell" bundle:nil]
     forCellReuseIdentifier:ApplyTransferPubEstRemindPersonCellID];
}

- (void)initNavigationBar
{
	[self setNavTitle:@"新增联系人"
	   leftButtonItem:[self customBarItemButton:nil
								backgroundImage:nil
									 foreground:@"backBtnImg"
											sel:@selector(back)]
	  rightButtonItem:[self customBarItemButton:@"提交"
								backgroundImage:nil
									 foreground:nil
											sel:@selector(onClickSubmitButton)]
	 ];
}

#pragma mark - <UITextViewTextDidChangeNotification>

- (void)textViewChangeInput:(NSNotification *)notifi
{
    switch (_indexPath.row) {
        case 3:
        {
            ApplyReasonInputCell *cell = (ApplyReasonInputCell *)[_tableView cellForRowAtIndexPath:_indexPath];
            if (cell.rightInputTextView.text.length > 200)
            {
                NSString *subStr = [cell.rightInputTextView.text substringToIndex:200];
                cell.rightInputTextView.text = subStr;
            }
            else
            {
                _propertyFollowAllAddEntity.FollowContent = cell.rightInputTextView.text;
            }
            break;
        }

        default:
            break;
    }
}

#pragma mark <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == FollowIpTextfieldTag)
    {
        // 跟进内容
        _propertyFollowAllAddEntity.FollowContent = [textView.text stringByAppendingString:text];
    }
    else if (textView.tag == ContactsTextfieldTag)
    {
        // 联系人备注
        _propertyFollowAllAddEntity.TrustorRemark = [textView.text stringByAppendingString:text];
    }
    
    return YES;
}

#pragma mark <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        switch (indexPath.row) {
            case 0:
            case 1:
            case 2:
            case 4:
            case 7:
            {
                return 37;
            }
                break;
                
            case 3:
            case 5:
            {
                return 116;
            }
                break;
                
            case 6:
            {
                // 添加提醒人
                CGFloat remindPersonHeight = _remindPersonCollectionView.contentSize.height;
                if (remindPersonHeight > 84.0)
                {
                    return remindPersonHeight+16.0;
                }
                
                return 84.0+16.0;
            }
                break;
                
            default:
                break;
        }

    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (MODEL_VERSION >= 7.0)
    {
		if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
			[cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
		}
		
		if (MODEL_VERSION >= 8.0)
        {
			if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
				[cell setPreservesSuperviewLayoutMargins:NO];
			}
			
			if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
				[cell setLayoutMargins:UIEdgeInsetsZero];
			}
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
    {
		case 0:
        {
			// 联系人类型
			ApplyTransferEstSelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:defealtSelectCellID forIndexPath:indexPath];
			
			[cell setupLeftTitleWithString:@"*联系人类型" rightLabelString:@"请选择联系人类型"];
			if (_propertyFollowAllAddEntity.TrustorTypeKeyId)
            {
				[cell rightLabelWithString:_contactTypeStr];
			}
			
			return cell;
		}
            break;
            
		case 1:
        {
			// 联系人姓名
			ApplyTransferEstInputItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyTransferEstInputItemCellID forIndexPath:indexPath];
			[cell setupCellWithLeftLabelTitle:@"*联系人姓名" rightTextFieldPlaceholderTitle:@"点输入联系人姓名"];
            [cell textFieldEndEditBlock:^(NSString *textFieldTextStr){
                
				_propertyFollowAllAddEntity.TrustorName = textFieldTextStr;
			}];
			
			return cell;
		}
            break;
            
		case 2:
        {
			// 性别
			ApplyTransferEstSelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:defealtSelectCellID forIndexPath:indexPath];
            [cell setupLeftTitleWithString:@"*性别" rightLabelString:@"请选择联系人性别"];
			if (_propertyFollowAllAddEntity.TrustorGenderKeyId)
            {
				[cell rightLabelWithString:_contactRender];
			}
			
			return cell;
		}
            break;
            
		case 3:
        {
			// 跟进备注
			ApplyReasonInputCell *cell = [tableView dequeueReusableCellWithIdentifier:followCententCellID
																					  forIndexPath:indexPath];
			[cell setupFollowCententCellWithViewController:self title:@"*跟进内容"];
			cell.rightInputTextView.text = _propertyFollowAllAddEntity.FollowContent;
            cell.rightInputTextView.delegate = self;
            cell.rightInputTextView.tag = FollowIpTextfieldTag;
			
			__weak typeof(self) weakSelf = self;
			[cell onClickVoiceInputButtonWithContentBlock:^(NSString *contentStr, ApplyReasonInputCellContentType type)
            {
                if (_propertyFollowAllAddEntity.FollowContent.length < 200)
                {
                    _propertyFollowAllAddEntity.FollowContent = [NSString stringWithFormat:@"%@%@",_propertyFollowAllAddEntity.FollowContent,contentStr];
                }

				if (type == ApplyReasonInputCellContentTypeVoice)
                {
					NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
					[weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath]
											  withRowAnimation:UITableViewRowAnimationNone];
				}
			}];
			
			return cell;
		}
            break;
            
		case 4:
        {
            return [self getFourthCell:indexPath];;
        }
            break;
            
		case 5:
        {
            return [self getFifthCell:indexPath];;
		}
            break;
            
		case 6:
        {
            return  [self getSexthCell:indexPath];
		}
            break;
            
		case 7:
        {
            return  [self getSeventhCell:indexPath];
		}
            break;
            
        case 8:
        {
            // 提醒时间
            UITableViewCell *remindTimeCell = [tableView dequeueReusableCellWithIdentifier:RemindTimeCellID];
            if (!remindTimeCell)
            {
                remindTimeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:RemindTimeCellID];
                remindTimeCell.textLabel.text = @"提醒时间";
                remindTimeCell.textLabel.font = [UIFont fontWithName:FontName size:14.0f];
                remindTimeCell.detailTextLabel.font = [UIFont fontWithName:FontName size:14.0f];
                remindTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (_propertyFollowAllAddEntity.MsgTime.length > 0)
            {
                remindTimeCell.detailTextLabel.text = _propertyFollowAllAddEntity.MsgTime;
            }
            else
            {
                remindTimeCell.detailTextLabel.text = @"点击选择时间";
            }
            
            return remindTimeCell;
        }
            break;
            
		default:
			return nil;
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 是否含有区域选择

        switch (indexPath.row)
        {
            case 0:
            {
                // 联系人类型
               [self contactsTypeTap];
            }
                break;

            case 2:
            {
                // 性别
                 [self sexTypeTap];
            }
                break;

            case 7:
            {
                // 选择时间
                if (!_selectedDate)
                {
                    _selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];
                }
                
                self.dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                                         andDelegate:self
                                                                              andTag:@"start"];
                
                [self.dateTimePickerDialog showWithDate:_selectedDate andTipTitle:@"选择提醒时间"];
            }
                break;
                
            default:
                break;
        
    }
}

#pragma mark - <联系人类型选择>

- (void)contactsTypeTap
{
    _pickType = ContactsType;
    [self showPickView:_contactsTypeIndex];
}

#pragma mark - <性别选择>

- (void)sexTypeTap
{
    _pickType = SexSelection;
    [self showPickView:_sexSelectionIndex];
}

#pragma mark - <区域选择>

- (void)regionalChoiceTypeTap
{
    _pickType = RegionalChoice;
    [self showPickView:_regionalChoiceIndex];
}

#pragma mark - <PickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(_pickType == ContactsType)
    {
        // 联系人类型
        return _typeNameArr.count;
    }
    else if(_pickType == SexSelection)
    {
        // 性别
        return _renderNameArr.count;
    }
    else if(_pickType == RegionalChoice)
    {
        // 性别
        return _phoneTypeArray.count;
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
    
    switch (_pickType)
    {
        case ContactsType:
        {
            // 联系人类型
            cusStr = _typeNameArr[row];
        }
            break;
            
        case SexSelection:
        {
            // 性别
            cusStr = _renderNameArr[row];
        }
            break;
            
        case RegionalChoice:
        {
            // 区域选择
            cusStr = _phoneTypeArray[row];
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (_pickType)
    {
        case ContactsType:
        {
            // 联系人类型
            _contactsTypeIndex = row;
        }
            break;
            
        case SexSelection:
        {
            // 性别
            _sexSelectionIndex = row;
        }
            break;
            
        case RegionalChoice:
        {
            // 区域选择
            _regionalChoiceIndex = row;
        }
            break;
            
        default:
            break;
    }
}

- (void)doneSelectItemMethod
{
    switch (_pickType)
    {
        case ContactsType:
        {
            // 联系人类型
            _contactTypeStr = _typeNameArr[_contactsTypeIndex];
            _propertyFollowAllAddEntity.TrustorTypeKeyId = _typeIdArr[_contactsTypeIndex];
        }
            break;
            
        case SexSelection:
        {
            // 性别选择
            _contactRender = _renderNameArr[_sexSelectionIndex];
            _propertyFollowAllAddEntity.TrustorGenderKeyId = _renderIdArr[_sexSelectionIndex];

        }
            break;
            
        case RegionalChoice:
        {
            // 区域选择
            _phoneType = _phoneTypeArray[_regionalChoiceIndex];
            _propertyFollowAllAddEntity.MobileAttribution = _phoneTypeVauleArray[_regionalChoiceIndex];
            
        }
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
}

#pragma mark - [私有方法]

- (CustomActionSheet *)showPickView:(NSInteger)selectIndex
{
    
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    [mPickerView selectRow:selectIndex inComponent:0 animated:YES];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView
                                                             AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    return sheet;
}

#pragma mark - AddContactsViewProtocol
/// 获得row == 4 时的cell
- (UITableViewCell *)getFourthCell:(NSIndexPath *)index
{
    
        // 手机
        ApplyTransferEstInputItemCell *cell = [_tableView dequeueReusableCellWithIdentifier:ApplyTransferEstInputItemCellID forIndexPath:index];
        [cell setupCellWithLeftLabelTitle:@"*手机" rightTextFieldPlaceholderTitle:@"请输入联系人电话"];
        cell.rightInputTextfield.keyboardType = UIKeyboardTypeNumberPad;
        cell.rightInputTextfield.tag = MobileTextfieldTag;
        [cell textFieldEndEditBlock:^(NSString *textFieldTextStr) {
            
            _propertyFollowAllAddEntity.Mobile = textFieldTextStr;
            
        }];
        
        return cell;
    
}

/// 获得row == 5 时的cell
- (UITableViewCell *)getFifthCell:(NSIndexPath *)index
{

        // 联系人备注
        ApplyReasonInputCell *cell = [_tableView dequeueReusableCellWithIdentifier:followCententCellID
                                                                     forIndexPath:index];
        
        [cell setupFollowCententCellWithViewController:self title:@" 联系人备注"];
        
        cell.rightInputTextView.text = _propertyFollowAllAddEntity.TrustorRemark;
        cell.rightInputTextView.tag = ContactsTextfieldTag;
        
        __weak typeof(self) weakSelf = self;
        [cell onClickVoiceInputButtonWithContentBlock:^(NSString *contentStr, ApplyReasonInputCellContentType type) {
            
            if (_propertyFollowAllAddEntity.TrustorRemark.length < 200 || contentStr.length > 0)
            {
                _propertyFollowAllAddEntity.TrustorRemark = [_propertyFollowAllAddEntity.TrustorRemark stringByAppendingString:contentStr];
                
            }
            
            if (type == ApplyReasonInputCellContentTypeVoice)
            {
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        
        return cell;
    
}

/// 获得row == 6 时的cell
- (UITableViewCell *)getSexthCell:(NSIndexPath *)index
{

        // 提醒人
        ApplyTransferPubEstRemindPersonCell *cell= [_tableView dequeueReusableCellWithIdentifier:ApplyTransferPubEstRemindPersonCellID
                                                                                   forIndexPath:index];
        [cell setupCellWithViewController:self tableView:_tableView];
        _remindPersonCollectionView = cell.showRemindListCollectionView;
        
        [cell passingSelectedContactsArrBlock:^(NSArray *contacts) {
            
            _propertyFollowAllAddEntity.ContactsName = contacts[0];
            _propertyFollowAllAddEntity.InformDepartsName = contacts[1];
            _propertyFollowAllAddEntity.MsgUserKeyIds = contacts[2];
            _propertyFollowAllAddEntity.MsgDeptKeyIds = contacts[3];
            
        }];
        
        return cell;
    
}

/// 获得row == 7 时的cell
- (UITableViewCell *)getSeventhCell:(NSIndexPath *)index
{

        // 提醒时间
        UITableViewCell *remindTimeCell = [_tableView dequeueReusableCellWithIdentifier:RemindTimeCellID];
        if (!remindTimeCell)
        {
            remindTimeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                    reuseIdentifier:RemindTimeCellID];
            remindTimeCell.textLabel.text = @"提醒时间";
            remindTimeCell.textLabel.font = [UIFont fontWithName:FontName size:14.0f];
            remindTimeCell.detailTextLabel.font = [UIFont fontWithName:FontName size:14.0f];
            remindTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (_propertyFollowAllAddEntity.MsgTime.length > 0)
        {
            remindTimeCell.detailTextLabel.text = _propertyFollowAllAddEntity.MsgTime;
        }
        else
        {
            remindTimeCell.detailTextLabel.text = @"点击选择时间";
        }
        
        return remindTimeCell;
    
}

#pragma mark Private Method
/**
 *  保存数据到数据库 
 */
- (void)saveToDatabaseWithConditionName:(NSString *)conditionName value:(NSString *)value key:(NSString *)key
{
	DataBaseOperation *database = [DataBaseOperation sharedataBaseOperation];
	// 是否存在该字段
	NSString *aStr = [database selectValueInConditionWithViewControllerName:NSStringFromClass(self.class)
															  conditionName:conditionName];
	if (aStr.length > 0)
    {
		// 更新
		[database updateSelectedViewController:NSStringFromClass(self.class)
								 ConditionName:conditionName
										 value:value
										   key:key];
	}
    else
    {
		// 新建
		[database insertSelectedConditionViewControllerName:NSStringFromClass(self.class)
											  conditionName:conditionName
													  value:value
														key:key];
	}
}


/**
 *  点击导航栏右侧按钮  
 */
- (void)onClickSubmitButton
{
	[self.view endEditing:YES];
	
	if (_isSubmit)
    {
		return;
	}

	if (_propertyFollowAllAddEntity.TrustorTypeKeyId.length == 0)
    {
		showMsg(@"请选择联系人类型");
		[self hiddenLoadingView];
        
		return;
	}

    // 去掉两端的空格
    NSString *trimedNameString = [_propertyFollowAllAddEntity.TrustorName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 判断输入内容是否全是空格
    BOOL isEmptyName = [NSString isEmptyWithLineSpace:_propertyFollowAllAddEntity.TrustorName];

    if (_propertyFollowAllAddEntity.TrustorName.length == 0 || isEmptyName)
    {
		showMsg(@"请输入联系人姓名");
		[self hiddenLoadingView];
        
		return;
    }
    else
    {
        _propertyFollowAllAddEntity.TrustorName = trimedNameString;
    }

    if (_propertyFollowAllAddEntity.TrustorGenderKeyId.length == 0)
    {
		showMsg(@"请选择性别");
		[self hiddenLoadingView];
	
        return;
	}


    NSString *trimedString1 = [_propertyFollowAllAddEntity.FollowContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL isEmpty = [NSString isEmptyWithLineSpace:_propertyFollowAllAddEntity.FollowContent];
    if (_propertyFollowAllAddEntity.FollowContent.length == 0 || isEmpty)
    {
		showMsg(@"请输入跟进内容");
		[self hiddenLoadingView];
	
        return;
    }
    else
    {
        _propertyFollowAllAddEntity.FollowContent = trimedString1;
    }

    if (_propertyFollowAllAddEntity.Mobile.length == 0)
    {
		showMsg(@"请输入电话");
		[self hiddenLoadingView];
		
        return;
    }
    if (_propertyFollowAllAddEntity.Mobile.length < 7 || _propertyFollowAllAddEntity.Mobile.length > 11)
    {
        
    }
    
    // 验证手机号
    
    if (![CommonMethod isMobile:_propertyFollowAllAddEntity.Mobile]) {
        
        [self hiddenLoadingView];
        showMsg(@"请输入正确的手机号!")
        
        return;
    }
    

    
    if (_propertyFollowAllAddEntity.TrustorRemark.length > 0)
    {
        // 判断输入内容是否全是空格
        NSString *trimedString2 = [_propertyFollowAllAddEntity.TrustorRemark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        BOOL isEmpty = [NSString isEmptyWithLineSpace:_propertyFollowAllAddEntity.TrustorRemark];
        if (isEmpty)
        {
            _propertyFollowAllAddEntity.TrustorRemark = @"";
        }
        else
        {
            _propertyFollowAllAddEntity.TrustorRemark = trimedString2;

        }
    }

	[self showLoadingView:@"提交中..."];
	_isSubmit = YES;
    PropertyFollowAllAddApi *propertyFollowAllAddApi = [[PropertyFollowAllAddApi alloc] init];
    propertyFollowAllAddApi.propertyFollowAllAddType = AddContact;
    propertyFollowAllAddApi.entity = _propertyFollowAllAddEntity;
    [_manager sendRequest:propertyFollowAllAddApi];
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
	
	// 不可是之前的日期
	if (secondsInterval > 0)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:YearToMinFormat];
		
		_propertyFollowAllAddEntity.MsgTime = [dateFormatter stringFromDate:dateTime];
		_selectedDate = dateTime;
	}
    else
    {
		showMsg(@"请选择有效日期");
	}
}

/**
 *  点击确定
 */
- (void)clickDone
{
    if (_propertyFollowAllAddEntity.MsgTime == nil || _propertyFollowAllAddEntity.MsgTime.length == 0)
    {
        // 没有滑动
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        _propertyFollowAllAddEntity.MsgTime = [dateFormatter stringFromDate:_selectedDate];
    }

    _oldTime = _selectedDate;
    
    [self.tableView reloadData];
}

/**
 *  点击取消
 */
- (void)clickCancle
{
    if (!_oldTime)
    {
        _propertyFollowAllAddEntity.MsgTime = nil;
        _selectedDate = nil;
    }
    else
    {
        _selectedDate = _oldTime;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        
        _propertyFollowAllAddEntity.MsgTime = [dateFormatter stringFromDate:_oldTime];
    }
    
    [_tableView reloadData];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        AgencyBaseEntity *receiveEntity = [DataConvert convertDic:data toEntity:modelClass];
        if (receiveEntity.flag == YES)
        {
            showMsg(@"新增成功");
            
            [self performSelector:@selector(back) withObject:nil afterDelay:2.0f];
            
            if ([_delegate respondsToSelector:@selector(transferEstSuccess)])
            {
                [_delegate performSelector:@selector(transferEstSuccess)];
            }
        }
        else
        {
            showMsg(@"新增失败");
        }
    }
    
    _isSubmit = NO;
    [self hiddenLoadingView];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    _isSubmit = NO;
}


@end
