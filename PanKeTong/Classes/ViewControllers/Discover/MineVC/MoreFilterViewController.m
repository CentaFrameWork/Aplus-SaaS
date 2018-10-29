//
//  MoreFilterViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MoreFilterViewController.h"


#import "TextFieldTableViewCell.h"
#import "MoreFilterTableViewCell.h"
#import "SysParamItemEntity.h"
#import "SelectItemDtoEntity.h"
#import "AgencySysParamUtil.h"


#import "MoreFilterZJPresenter.h"


#define CellViewTag             1000001
#define ButtonTagBasic          10000
#define RowTextFiledTag         1000
#define PropNoTextFieldTag      200000      // 房源编号搜索框
#define Padding                 15

@interface MoreFilterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSArray *_headerTitleArray;
    NSArray *_allMessageArray;
    
    UIButton *_levelButton;                 // 等级
    UIButton *_propSituationButton;         // 房源现状
    UIButton *_levelLogButton;              // 记录等级
    UIButton *_propSituationLogButton;      // 记录房源现状
    NSInteger _section;
    NSMutableArray *_roomType;              // 房型
    NSMutableArray *_roomStatus;            // 房源状态
    NSMutableArray *_direction;             // 朝向
    NSMutableArray *_propTag;               // 房屋标签
    NSMutableArray *_buildingType;          // 建筑类型
    
    FilterEntity *_registerEntity;          // 记录筛选Entity
    MoreFilterBasePresenter *_moreFilterPresenter;
}
@end

@implementation MoreFilterViewController

#pragma mark - LifeCycle
// 通盘房源列表的更多筛选页
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPresenter];
    [self initNavigation];
    [self initData];
    
    // 添加输入价格面积通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(writeAreaOrPrice:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
}

#pragma mark - init

- (void)initPresenter
{

        _moreFilterPresenter = [[MoreFilterZJPresenter alloc] initWithDelegate:self];
    

}

- (void)initData
{
    _roomType = [NSMutableArray arrayWithCapacity:0];
    _roomStatus = [NSMutableArray arrayWithCapacity:0];
    _direction = [NSMutableArray arrayWithCapacity:0];
    _propTag = [NSMutableArray arrayWithCapacity:0];
    _buildingType = [NSMutableArray arrayWithCapacity:0];
    
    // 获得类型
    _headerTitleArray = [_moreFilterPresenter getHeaderTitleArray];
    _allMessageArray = [_moreFilterPresenter getValueArray];
    
    _filterEntity = [FilterEntity new];
    _filterEntity = [DataConvert convertDic:_dataDic toEntity:[FilterEntity class]];
    
    if ([_filterEntity.isTrustsApproved isEqualToString:@"true"])
    {
        // 委托已审筛选
        SelectItemDtoEntity *entrustExamine = [SelectItemDtoEntity new];
        entrustExamine.itemText = @"委托已审";
        
        [_filterEntity.propTag addObject:entrustExamine];
    }
    
    if ([_filterEntity.isCompleteDoc isEqualToString:@"true"])
    {
        // 证件齐全筛选
        SelectItemDtoEntity *entrustExamine = [SelectItemDtoEntity new];
        entrustExamine.itemText = @"证件齐全";
        [_filterEntity.propTag addObject:entrustExamine];
    }
    
    if ([_filterEntity.isTrustProperty isEqualToString:@"true"])
    {
        // 证件齐全筛选
        SelectItemDtoEntity *entrustExamine = [SelectItemDtoEntity new];
        entrustExamine.itemText = @"委托房源";
        [_filterEntity.propTag addObject:entrustExamine];
    }
    
    _registerEntity = [self.filterEntity copy];
    _registerEntity.roomType = [_roomType mutableCopy];
    _registerEntity.roomStatus = [_roomStatus mutableCopy];
    _registerEntity.direction = [_direction mutableCopy];
    _registerEntity.propTag = [_propTag mutableCopy];
    _registerEntity.buildingType = [_buildingType mutableCopy];
}

- (void)initNavigation
{
    [self setNavTitle:@"更多筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    UIButton *commitBtn = [self customBarItemButton:@"确定"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(commitClick)];
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    UIButton *againSetting = [self customBarItemButton:@"重置"
                                       backgroundImage:nil
                                            foreground:nil
                                                   sel:@selector(againSetClick)];
    
    UIBarButtonItem *againSettingItem = [[UIBarButtonItem alloc]initWithCustomView:againSetting];
    self.navigationItem.rightBarButtonItems = @[commitBtnItem,againSettingItem];
}

- (void)back
{
    if ([self.delegate respondsToSelector:@selector(moreFilterBack)])
    {
        [_delegate moreFilterBack];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <重置>

- (void)againSetClick
{
    [_filterEntity.roomType removeAllObjects];
    [_filterEntity.roomStatus removeAllObjects];
    [_filterEntity.direction removeAllObjects];
    [_filterEntity.propTag removeAllObjects];
    [_filterEntity.buildingType removeAllObjects];
    _filterEntity.propSituationLogButtonTag = 0;
    _filterEntity.levelLogButtonTag = 0;
    _filterEntity.propSituationLogButtonSelect = NO;
    _filterEntity.levelLogButtonSelect = NO;
    _filterEntity.roomLevelText = @"";
    _filterEntity.roomLevelValue = @"";
    _filterEntity.propSituationText = @"";
    _filterEntity.propSituationValue = @"";
    _filterEntity.moreFilterMaxRentPrice = nil;
    _filterEntity.moreFilterMinRentPrice = nil;
    _filterEntity.moreFilterMinSalePrice = nil;
    _filterEntity.moreFilterMaxSalePrice = nil;
    _filterEntity.minBuildingArea = nil;
    _filterEntity.maxBuildingArea = nil;
    _filterEntity.minRentPrice = nil;
    _filterEntity.maxRentPrice = nil;
    _filterEntity.minSalePrice = nil;
    _filterEntity.maxSalePrice = nil;
    _filterEntity.propertyNo = @"";
    
    [_mainTableView reloadData];
}

#pragma mark - <确定>

- (void)commitClick
{
    if ([_filterEntity.minBuildingArea integerValue] > [_filterEntity.maxBuildingArea integerValue]&&_filterEntity.maxBuildingArea && ![_filterEntity.maxBuildingArea isEqualToString:@""])
    {
        showMsg(@"当前最低面积大于最高面积\n请重新输入");
        return;
    }
    else if ([_filterEntity.minRentPrice integerValue] > [_filterEntity.maxRentPrice integerValue] && _filterEntity.maxRentPrice&&![_filterEntity.maxRentPrice isEqualToString:@""])
    {
        showMsg(@"当前最低租价大于最高租价\n请重新输入");
        return;
    }
    else if ([_filterEntity.minSalePrice integerValue] > [_filterEntity.maxSalePrice integerValue] && _filterEntity.maxSalePrice && ![_filterEntity.maxSalePrice isEqualToString:@""])
    {
        showMsg(@"当前最低售价大于最高售价\n请重新输入");
        return;
    }
    else
    {
        if ([NSString isNilOrEmpty:_filterEntity.minRentPrice] || [NSString isNilOrEmpty:_filterEntity.maxRentPrice])
        {
            _filterEntity.minRentPrice = @"";
            _filterEntity.maxRentPrice = @"";
            
            if ([NSString isNilOrEmpty:_filterEntity.minSalePrice] || [NSString isNilOrEmpty:_filterEntity.maxSalePrice])
            {
                _filterEntity.salePriceText = @"";
            }
        }
        
        if ([NSString isNilOrEmpty:_filterEntity.minSalePrice] || [NSString isNilOrEmpty:_filterEntity.maxSalePrice])
        {
            _filterEntity.minSalePrice = @"";
            _filterEntity.maxSalePrice = @"";
            if ([NSString isNilOrEmpty:_filterEntity.minRentPrice] || [NSString isNilOrEmpty:_filterEntity.maxRentPrice])
            {
                _filterEntity.salePriceText = @"";
            }
        }
        
        // 是否含有委托已审
        if ([_moreFilterPresenter haveTrustsApproved])
        {
            NSInteger tagCount = _filterEntity.propTag.count;
            _filterEntity.isTrustsApproved = @"false";

            if (tagCount > 0)
            {
                for (NSInteger i = tagCount - 1; i >= 0; i--)
                {
                    SelectItemDtoEntity *entity = _filterEntity.propTag[i];
                    
                    if ([entity.itemText isEqualToString:@"委托已审"])
                    {
                        [CommonMethod addLogEventWithEventId:@"House r list_c label check_F" andEventDesc:@"房源列表页-筛选-委托已审标签点击量"];
                        [_filterEntity.propTag removeObject:entity];
                        _filterEntity.isTrustsApproved = @"true";
                    }
                }
            }
        }

        if ([_moreFilterPresenter haveCompleteDoc])
        {
            // 含有证件齐全
            NSInteger tagCount = _filterEntity.propTag.count;
            _filterEntity.isCompleteDoc = @"false";

            if (tagCount > 0)
            {
                for (NSInteger i = tagCount - 1; i >= 0; i--)
                {
                    SelectItemDtoEntity *entity = _filterEntity.propTag[i];

                    if ([entity.itemText isEqualToString:@"证件齐全"])
                    {
                        [CommonMethod addLogEventWithEventId:@"House r list_c complete_F" andEventDesc:@"房源列表页-筛选-证件齐全标签点击量"];
                        [_filterEntity.propTag removeObject:entity];
                        _filterEntity.isCompleteDoc = @"true";
                    }
                }
            }
        }

        if ([_moreFilterPresenter haveTrustProperty])
        {
            // 含有委托房源
            NSInteger tagCount = _filterEntity.propTag.count;
            _filterEntity.isTrustProperty = @"false";

            if (tagCount > 0)
            {
                for (NSInteger i = tagCount - 1; i >= 0; i--)
                {
                    SelectItemDtoEntity *entity = _filterEntity.propTag[i];

                    if ([entity.itemText isEqualToString:@"委托房源"])
                    {
                        [_filterEntity.propTag removeObject:entity];
                        _filterEntity.isTrustProperty = @"true";
                    }
                }
            }
        }
        
        [self.delegate getFilterEntity:_filterEntity];
        [self back];
    }
}

#pragma mark - <TableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionNumber = [_moreFilterPresenter getPriceSectionNumber];
    
    if (section == sectionNumber)
    {
        if ([_filterEntity.estDealTypeText isEqualToString:@"全部"] || [_filterEntity.estDealTypeText isEqualToString:@"租售"])
        {
            return 2;
        }
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allMessageArray.count + [_moreFilterPresenter sectionAddCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger addCount = [_moreFilterPresenter sectionAddCount] - 2;    // 广州比其他城市多一行，房源编号搜索
    NSInteger realSection = indexPath.section - addCount;

    if (realSection == _allMessageArray.count || realSection == _allMessageArray.count+1)
    {
        return 38;
    }
    else if(realSection >= 0)
    {
        NSInteger iCount = [_allMessageArray[realSection] count];
        
        CGFloat pointX = 10;
        CGFloat pointY = 10;
        CGFloat padding = Padding;
        CGFloat btnHeight = 30.0;
        CGFloat allWidth = self.view.bounds.size.width - 10;
        for (int i = 0; i < iCount; i++)
        {
            NSArray *messageArray = _allMessageArray[realSection];
            SelectItemDtoEntity *selectEntity = messageArray[i];
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName size:14.0]};
            CGSize size = [selectEntity.itemText boundingRectWithSize:CGSizeMake(MAXFLOAT,26) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            CGFloat btnWidth = size.width + 20;
            
            if (pointX + btnWidth > allWidth)
            {
                pointX = 10;
                pointY += (btnHeight + padding);
            }
            
            pointX += (btnWidth + padding);
        }
        CGFloat cellHeight = pointY + btnHeight + 10;

        return cellHeight;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label =[[UILabel alloc]init];
    label.text = _headerTitleArray[section];
    label.textColor = LITTLE_BLACK_COLOR;
    label.font = [UIFont fontWithName:FontName size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger addCount = [_moreFilterPresenter sectionAddCount] - 2;    // 广州比其他城市多一行，房源编号搜索
    NSInteger realSection = section - addCount;

    if (realSection == _allMessageArray.count+1)
    {
        return 10;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger addCount = [_moreFilterPresenter sectionAddCount] - 2;    // 广州比其他城市多一行，房源编号搜索
    NSInteger realSection = section - addCount;
    
    if (realSection == _allMessageArray.count+1)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:245.0/255.0 blue:241.0/255.0 alpha:1.0];
        return view;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"textfieldCell";
    TextFieldTableViewCell *textfieldCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    static NSString *identify = @"moreFilterCell";
    MoreFilterTableViewCell *moreFilterCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!textfieldCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
        textfieldCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    }
    
    if (!moreFilterCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MoreFilterTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
        moreFilterCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
    }
    
    NSInteger addCount = [_moreFilterPresenter sectionAddCount] - 2;    // 广州比其他城市多一行，房源编号搜索
    if (addCount == 1) {
        if (indexPath.section == 0)
        {
            UITableViewCell *textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textcell"];
            UITextField *textField = [[UITextField alloc] init];
            textField.frame = CGRectMake(0, 0, 200, 30);
            CGPoint cellCenter = textCell.contentView.center;
            textField.center = CGPointMake(APP_SCREEN_WIDTH/2, cellCenter.y);
            [textField setBackground:[UIImage imageNamed:@"moreFilter_textBg"]];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = PropNoTextFieldTag;
            
            if (_filterEntity.propertyNo.length > 0)
            {
                textField.text = _filterEntity.propertyNo;
            }
            
            [textCell.contentView addSubview:textField];
            
            return textCell;
        }
    }
    
    NSInteger realSection = indexPath.section - addCount;
    
    if (realSection == _allMessageArray.count ||
        realSection == _allMessageArray.count+1)
    {
        textfieldCell.textFrom.delegate = self;
        textfieldCell.textTo.delegate = self;
        textfieldCell.textFrom.tag = (realSection*ButtonTagBasic+(indexPath.row*RowTextFiledTag))+1;
        textfieldCell.textTo.tag = (realSection*ButtonTagBasic+(indexPath.row*RowTextFiledTag))+2;
        
        if (realSection == _allMessageArray.count)
        {
            // 建筑面积
            textfieldCell.nameLabel.text = [_moreFilterPresenter getAreaOfBuildingTitle];
            textfieldCell.textFrom.text = _filterEntity.minBuildingArea;
            textfieldCell.textTo.text = _filterEntity.maxBuildingArea;
            
            return textfieldCell;
        }
        else
        {
            // 价格
            if ((([_filterEntity.estDealTypeText isEqualToString:@"全部"]
                  || [_filterEntity.estDealTypeText isEqualToString:@"租售"])
                 && indexPath.row == 0)
                || [_filterEntity.estDealTypeText isEqualToString:@"出租"])
            {
                textfieldCell.nameLabel.text = [NSString stringWithFormat:@"出租价格(元)"];
                textfieldCell.textFrom.text = _filterEntity.minRentPrice;
                textfieldCell.textTo.text = _filterEntity.maxRentPrice;
            }
            else
            {
                textfieldCell.nameLabel.text = [NSString stringWithFormat:@"出售价格(万元)"];
                textfieldCell.textFrom.text = _filterEntity.minSalePrice;
                textfieldCell.textTo.text = _filterEntity.maxSalePrice;
            }
            
            return textfieldCell;
        }
    }
    else
    {
        UIView *currentView = (UIView *)[moreFilterCell.contentView viewWithTag:CellViewTag];
        [currentView removeFromSuperview];
        UIView *view = [[UIView alloc] init];
        view.tag = CellViewTag;
        NSInteger iCount = [_allMessageArray[realSection] count];
        
        CGFloat pointX = 10;
        CGFloat pointY = 10;
        CGFloat padding = Padding;
        CGFloat btnHeight = 30.0;
        CGFloat allWidth = self.view.bounds.size.width - 10;
        
        for (int i = 0; i < iCount; i++)
        {
            NSArray *messageArray = _allMessageArray[realSection];
            SelectItemDtoEntity *selectEntity = messageArray[i];
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName size:14.0]};
            CGSize size = [selectEntity.itemText boundingRectWithSize:CGSizeMake(MAXFLOAT,26) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

            CGFloat btnWidth = size.width + 20;
            
            if (pointX + btnWidth > allWidth)
            {
                // 换行
                pointX = 10;
                pointY += (btnHeight + padding);
            }
            
            // 背景button
            UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bgButton.frame = CGRectMake(pointX, pointY, btnWidth, btnHeight);
            bgButton.tag = (realSection * ButtonTagBasic) + i + 100;
            bgButton.layer.masksToBounds = YES;
            bgButton.layer.cornerRadius = 5.0;
            bgButton.layer.borderWidth = 1.0;
            bgButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [bgButton addTarget:self action:@selector(theRoomTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bgButton];
            
            bgButton.titleLabel.font = [UIFont fontWithName:FontName size:14.0];

            [bgButton setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
            [bgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

            NSString *textStr = selectEntity.itemText;
            [bgButton setTitle:textStr forState:UIControlStateNormal];
            
            // 是否含有房源等级
            if ([_moreFilterPresenter haveHousingGrade])
            {
                if (indexPath.section == 2 || indexPath.section == 3)
                {
                    [bgButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                }
                else
                {
                    [bgButton setBackgroundImage:[UIImage imageNamed:@"button_select_Img.png"]
                                      forState:UIControlStateSelected];
                }
                
                // button的显示
                if (indexPath.section == 2)
                {
                    if ([selectEntity.itemValue isEqualToString:_filterEntity.propSituationValue])
                    {
                        UIButton *button = (UIButton *)[view viewWithTag:(indexPath.section * ButtonTagBasic) + i+100];
                        button.selected = YES;
                        
                    }
                }
                else if (indexPath.section == 3)
                {
                    if ([selectEntity.itemValue isEqualToString:_filterEntity.roomLevelValue])
                    {
                        UIButton *button = (UIButton *)[view viewWithTag:(indexPath.section * ButtonTagBasic) + i+100];
                        button.selected = YES;
                    }
                }
                else
                {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    switch (indexPath.section)
                    {
                        case 0:
                            [array addObjectsFromArray:_filterEntity.roomType];
                            break;
                        case 1:
                            [array addObjectsFromArray:_filterEntity.roomStatus];
                            break;
                        case 4:
                            [array addObjectsFromArray:_filterEntity.direction];
                            break;
                        case 5:
                            [array addObjectsFromArray:_filterEntity.propTag];
                            break;
                        case 6:
                            [array addObjectsFromArray:_filterEntity.buildingType];
                            break;
                            
                        default:
                            break;
                    }
                    
                    for (int j = 0; j < array.count; j++)
                    {
                        SelectItemDtoEntity *entity = array[j];
                        if ([selectEntity.itemText isEqualToString:entity.itemText])
                        {
                            UIButton *bgButton = (UIButton *)[view viewWithTag:(indexPath.section * ButtonTagBasic) + i + 100];
                            bgButton.selected = YES;
                        }
                    }
                }
            }
            else
            {
                if (realSection == 2)
                {
                    [bgButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                }
                else
                {
                    [bgButton setBackgroundImage:[UIImage imageNamed:@"button_select_Img.png"] forState:UIControlStateSelected];
                }
                                
                // button的显示
                if (realSection == 2)
                {
                    // 房屋现状
                    if ([selectEntity.itemValue isEqualToString:_filterEntity.propSituationValue])
                    {
                        UIButton *button = (UIButton *)[view viewWithTag:(realSection * ButtonTagBasic) + i+100];
                        button.selected = YES;
                    }
                }
                else
                {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    switch (realSection)
                    {
                        case 0:
                            // 房型
                            [array addObjectsFromArray:_filterEntity.roomType];
                            
                            break;
                            
                        case 1:
                            [array addObjectsFromArray:_filterEntity.roomStatus];
                            
                            break;
                            
                        case 3:
                            // 朝向
                            [array addObjectsFromArray:_filterEntity.direction];
                            
                            break;
                            
                        case 4:
                            // 房源标签
                            [array addObjectsFromArray:_filterEntity.propTag];
                            
                            break;
                            
                        case 5:
                            // 建筑类型
                            [array addObjectsFromArray:_filterEntity.buildingType];
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                    NSInteger jCount = array.count;
                    for (int j = 0; j < jCount; j++)
                    {
                        SelectItemDtoEntity *entity = array[j];
                        if ([selectEntity.itemText isEqualToString:entity.itemText])
                        {
                            UIButton *bgButton = (UIButton *)[view viewWithTag:(realSection * ButtonTagBasic) + i + 100];
                            bgButton.selected = YES;
                        }
                    }
                }
            }
            pointX += (btnWidth + padding);
        }

        view.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, pointY+btnHeight+10);
        
        moreFilterCell.contentView.tag = indexPath.section;
        [moreFilterCell.contentView addSubview:view];
        return moreFilterCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView reloadData];
}

- (void)theRoomTypeClick:(UIButton *)button
{
    NSInteger section = button.tag / ButtonTagBasic;
    // 是否含有房源等级
    if ([_moreFilterPresenter haveHousingGrade])
    {
        if (section == 2)
        {
            if (button.tag == _filterEntity.propSituationLogButtonTag)
            {
                button.selected =! _filterEntity.propSituationLogButtonSelect;
            }
            else
            {
                _propSituationButton.selected = NO;
                _propSituationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = YES;
                _propSituationButton = button;
            }
            _filterEntity.propSituationLogButtonTag = button.tag;
            _filterEntity.propSituationLogButtonSelect = button.selected;
        }
        else if (section == 3)
        {
            if (button.tag == _filterEntity.levelLogButtonTag)
            {
                button.selected =! _filterEntity.levelLogButtonSelect;
            }
            else
            {
                _levelButton.selected = NO;
                _levelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected =  YES;
                _levelLogButton = button;
            }
            _filterEntity.levelLogButtonTag = button.tag;
            _filterEntity.levelLogButtonSelect = button.selected;
        }
        else
        {
            button.selected =! button.selected;
        }
    }
    else
    {
        if (section == 2)
        {
            if (button.tag == _filterEntity.propSituationLogButtonTag)
            {
                button.selected =! _filterEntity.propSituationLogButtonSelect;
            }
            else
            {
                _propSituationButton.selected = NO;
                _propSituationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = YES;
                _propSituationButton = button;
            }
            _filterEntity.propSituationLogButtonTag = button.tag;
            _filterEntity.propSituationLogButtonSelect = button.selected;
        }
        else
        {
            button.selected =! button.selected;
        }
    }

    NSArray *messageArray = _allMessageArray[section];
    NSInteger selectBtn = (button.tag % ButtonTagBasic) - 100;
    SelectItemDtoEntity *selectEntity = messageArray[selectBtn];
    
    if([_moreFilterPresenter haveHousingGrade])
    {
        switch (section)
        {
            case 0:
                if (button.selected)
                {
                    [_filterEntity.roomType addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.roomType removeObject:selectEntity];
                }
                
                break;
            case 1:
                if (button.selected)
                {
                    [_filterEntity.roomStatus addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.roomStatus removeObject:selectEntity];
                }
                
                break;
            case 2:
                if (button.selected)
                {
                    _filterEntity.propSituationValue = selectEntity.itemValue;
                    _filterEntity.propSituationText = selectEntity.itemText;
                }
                else
                {
                    _filterEntity.propSituationValue = @"";
                    _filterEntity.propSituationText = @"";
                }
                
                break;
            case 3:
                if (button.selected)
                {
                    _filterEntity.roomLevelValue = selectEntity.itemValue;
                    _filterEntity.roomLevelText = selectEntity.itemText;
                }
                else
                {
                    _filterEntity.roomLevelValue = @"";
                    _filterEntity.roomLevelText = @"";
                }
                
                break;
            case 4:
                if (button.selected)
                {
                    [_filterEntity.direction addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.direction removeObject:selectEntity];
                }
                
                break;
            case 5:
                if (button.selected)
                {
                    [_filterEntity.propTag addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.propTag removeObject:selectEntity];
                }
                
                break;
            case 6:
                if (button.selected)
                {
                    [_filterEntity.buildingType addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.buildingType removeObject:selectEntity];
                }
                
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (section)
        {
            case 0:
                // 房型
                if (button.selected)
                {
                    [_filterEntity.roomType addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.roomType removeObject:selectEntity];
                }
                
                break;
            case 1:
                // 房源状态
                if (button.selected)
                {
                    [_filterEntity.roomStatus addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.roomStatus removeObject:selectEntity];
                }
                
                break;
            case 2:
                // 房屋现状
                if (button.selected)
                {
                    _filterEntity.propSituationValue = selectEntity.itemValue;
                    _filterEntity.propSituationText = selectEntity.itemText;
                }
                else
                {
                    _filterEntity.propSituationValue = @"";
                    _filterEntity.propSituationText = @"";
                }
                
                break;
            case 3:
                // 朝向
                if (button.selected)
                {
                    [_filterEntity.direction addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.direction removeObject:selectEntity];
                }
                
                break;
            case 4:
                // 房源标签
                if (button.selected)
                {
                    [_filterEntity.propTag addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.propTag removeObject:selectEntity];
                }
                
                break;
            case 5:
                // 建筑类型
                if (button.selected)
                {
                    [_filterEntity.buildingType addObject:selectEntity];
                }
                else
                {
                    [_filterEntity.buildingType removeObject:selectEntity];
                }
                
                break;
                
            default:
                break;
        }
    }
    
    if (button.selected)
    {
        button.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

#pragma mark - <TextFieldNotification>

- (void)writeAreaOrPrice:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    if ([_moreFilterPresenter haveHousingGrade])
    {
        if (textField.tag == 70001)
        {
            _filterEntity.minBuildingArea = textField.text;
        }
        else if (textField.tag == 70002)
        {
            _filterEntity.maxBuildingArea = textField.text;
        }
        else if (textField.tag == 80001)
        {
            if ([_filterEntity.estDealTypeText isEqualToString:@"出租"]||
                [_filterEntity.estDealTypeText isEqualToString:@"全部"]||
                [_filterEntity.estDealTypeText isEqualToString:@"租售"])
            {
                _filterEntity.minRentPrice = textField.text;
            }
            else
            {
                _filterEntity.minSalePrice = textField.text;
            }
        }
        else if (textField.tag == 80002)
        {
            if ([_filterEntity.estDealTypeText isEqualToString:@"出租"]||
                [_filterEntity.estDealTypeText isEqualToString:@"全部"]||
                [_filterEntity.estDealTypeText isEqualToString:@"租售"])
            {
                _filterEntity.maxRentPrice = textField.text;
            }
            else
            {
                _filterEntity.maxSalePrice = textField.text;
            }
        }
        else if(textField.tag == 81001)
        {
            _filterEntity.minSalePrice = textField.text;
        }
        else if(textField.tag == 81002)
        {
            _filterEntity.maxSalePrice = textField.text;
        }
    }
    else
    {
        if (textField.tag == 60001)
        {
            _filterEntity.minBuildingArea = textField.text;
        }
        else if (textField.tag == 60002)
        {
            _filterEntity.maxBuildingArea = textField.text;
        }
        else if (textField.tag == 70001)
        {
            if ([_filterEntity.estDealTypeText isEqualToString:@"出租"]||
                [_filterEntity.estDealTypeText isEqualToString:@"全部"]||
                [_filterEntity.estDealTypeText isEqualToString:@"租售"])
            {
                _filterEntity.minRentPrice = textField.text;
            }
            else
            {
                _filterEntity.minSalePrice = textField.text;
            }
        }
        else if (textField.tag == 70002)
        {
            if ([_filterEntity.estDealTypeText isEqualToString:@"出租"]||
                [_filterEntity.estDealTypeText isEqualToString:@"全部"]||
                [_filterEntity.estDealTypeText isEqualToString:@"租售"])
            {
                _filterEntity.maxRentPrice = textField.text;
            }
            else
            {
                _filterEntity.maxSalePrice = textField.text;
            }
        }
        else if(textField.tag == 71001)
        {
            _filterEntity.minSalePrice = textField.text;
        }
        else if(textField.tag == 71002)
        {
            _filterEntity.maxSalePrice = textField.text;
        }
        else if (textField.tag == PropNoTextFieldTag)
        {
            // 房源编号
            _filterEntity.propertyNo = textField.text;
        }
    }
}

#pragma mark - <TextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger section = textField.tag / ButtonTagBasic;
    
    if (section == _allMessageArray.count)
    {
        if (range.length == 0 && range.location >= 4)
        {
            NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                     textField.text,
                                     string];
            NSString *resultString = [inputString substringToIndex:5];
            textField.text = resultString;
            
            return NO;
        }
    }
    else if (section == (_allMessageArray.count + 1))
    {
        if (range.length == 0 && range.location>=7)
        {
            NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
            NSString *resultString = [inputString substringToIndex:8];
            textField.text = resultString;
            
            return NO;
        }
    }
    else if (textField.tag == PropNoTextFieldTag)
    {
        if (range.length == 0 && range.location >= 49)
        {
            NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
            NSString *resultString = [inputString substringToIndex:50];
            textField.text = resultString;
            
            return NO;
        }
    }
    
    return YES;
}

@end
