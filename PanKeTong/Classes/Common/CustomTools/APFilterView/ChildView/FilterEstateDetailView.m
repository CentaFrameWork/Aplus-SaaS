//
//  FilterEstateDetailView.m
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "FilterEstateDetailView.h"
#import "JMFilterCustomPriceView.h"
#import "APFilterView.h"
#import "ItemView.h"

#import "FilterListCell.h"

#import "CAShapeLayer+Category.h"

@interface FilterEstateDetailView () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    // 价格需要用两个tablew关联
    UITableView *_firstTableView;
    UITableView *_secondTableView;
    
    UITextField *_minPriceTextField;
    UITextField *_maxPriceTextField;
    
    NSMutableArray *_dataSourceArray;
    NSMutableArray *_itemTitleArray;
    NSInteger _selectIndex;
    NSInteger _firstTabSelectCellIndex;     // 第一个tablew选中的行数  0:出租，1:出售
    FilterType _estateFilterListType;
    FilterEntity *_filterEntity;
}

//自定义价格View
@property (nonatomic, weak) JMFilterCustomPriceView * customPriceView;

@end

@implementation FilterEstateDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 默认选中第一行
        _firstTabSelectCellIndex = 0;
    }
    return self;
}

- (void)setTableViewNumber:(NSInteger)tableViewNumber
{
    _tableViewNumber = tableViewNumber;
    
    _firstTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _firstTableView.delegate = self;
    _firstTableView.dataSource = self;
    _firstTableView.tableFooterView = [[UIView alloc]init];
    _firstTableView.separatorColor = YCOtherColorDivider;
    
    // 当输入价格键盘出来时判断上移高度
    CGFloat moveUpHeight = 0;
    if (kDevice_Is_iPhone6Plus)
    {
        moveUpHeight = 0;
    }
    {
        moveUpHeight = 12;
    }
    
    //TPKeyboardAvoidingScrollView替换为UIView
    UIView * keyboardAvoiding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - moveUpHeight)];
    [keyboardAvoiding addSubview:_firstTableView];
    
    // 如需要两个tableView则添加两个
    if (tableViewNumber == 2)
    {
        _firstTableView.backgroundColor = [UIColor whiteColor];
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.tableFooterView = [[UIView alloc]init];
        _secondTableView.separatorColor = YCOtherColorDivider;
        
        [keyboardAvoiding addSubview:[self createInputView]];
        [keyboardAvoiding addSubview:_secondTableView];
        
        CAShapeLayer * vShapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(130, 0) toPoint:CGPointMake(130, TableViewCellHeight * 8) andColor:YCThemeColorGreen];
        
        [keyboardAvoiding.layer addSublayer:vShapeLayer];
        
        CAShapeLayer * hShapeLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(0, TableViewCellHeight * 8) toPoint:CGPointMake(APP_SCREEN_WIDTH, TableViewCellHeight * 8) andColor:YCOtherColorBorder];
        
        [keyboardAvoiding.layer addSublayer:hShapeLayer];
        
//        keyboardAvoiding.scrollEnabled = NO;
        
    }
    
    [self addSubview:keyboardAvoiding];
}

/// 创建价格输入视图
- (UIView *)createInputView{
    // item下标为1是价格
    if (_selectIndex == 1){
        
        JMFilterCustomPriceView * customPriceView = [JMFilterCustomPriceView viewFromXib];

        self.customPriceView = customPriceView;

        customPriceView.frame = CGRectMake(0, TableViewCellHeight * 8, APP_SCREEN_WIDTH, 50);

        _minPriceTextField = customPriceView.minPriceTextField;
        _minPriceTextField.delegate = self;
        _maxPriceTextField = customPriceView.maxPriceTextField;
        _maxPriceTextField.delegate = self;

        if (_firstTabSelectCellIndex == 0) {
            
            _minPriceTextField.text = _filterEntity.minRentPrice;
            _maxPriceTextField.text = _filterEntity.maxRentPrice;
            
        }else{
            
            _minPriceTextField.text = _filterEntity.minSalePrice;
            _maxPriceTextField.text = _filterEntity.maxSalePrice;
            
        }
        
        [customPriceView.ensureBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self.customPriceView;
}

//- (UIView *)setInputView
//{
//    UIToolbar * toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 44)];
//    [toolView setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
//    [toolView setItems:[NSArray arrayWithObjects:space,doneButton,nil]];
//    return toolView;
//}

- (void)resignKeyboard
{
    [self endEditing:YES];
}

/// 自定义价格确定按钮
- (void)confirmClick
{
    
    // 改变ItemView箭头文字颜色以及将选择的文字回调
    UILabel *lastSelectLabel = (UILabel *)[[super superview] viewWithTag:ItemTitleBaseTag + _selectIndex];
    UIImageView *selectArrowImg = (UIImageView *)[[super superview] viewWithTag:ArrowImageBaseTag + _selectIndex];
    
    NSInteger temp = 0;
    NSInteger minPrice = [_minPriceTextField.text integerValue];
    NSInteger maxPrice = [_maxPriceTextField.text integerValue];
    if (maxPrice < minPrice)
    {
        if (maxPrice > 0)
        {
            temp = maxPrice;
            maxPrice = minPrice;
            minPrice = temp;
        }
    }

    NSString *priceUnit = @"";
    [self clearPrice];
    if (_firstTabSelectCellIndex == 0)
    {
        // 出租
        _filterEntity.maxRentPrice = maxPrice > 0? [NSString stringWithFormat:@"%@",@(maxPrice)] : @"";
//        _filterEntity.maxRentPrice = maxPrice > 0? [NSString stringWithFormat:@"%@",@(maxPrice)] : @"9999999";
        _filterEntity.minRentPrice = [NSString stringWithFormat:@"%@",@(minPrice)];
        priceUnit = @"元";
    }
    else
    {
        // 出售
        _filterEntity.maxSalePrice = maxPrice > 0? [NSString stringWithFormat:@"%@",@(maxPrice)] : @"";
//        _filterEntity.maxSalePrice = maxPrice > 0? [NSString stringWithFormat:@"%@",@(maxPrice)] : @"9999999";
        _filterEntity.minSalePrice = [NSString stringWithFormat:@"%@",@(minPrice)];
        priceUnit = @"万";
        
    }
    
    if (minPrice == 0 && maxPrice > 0)
    {
        lastSelectLabel.text = [NSString stringWithFormat:@"%@%@以下",@(maxPrice),priceUnit];
    }
    else if (maxPrice == 0 && minPrice > 0)
    {
        lastSelectLabel.text = [NSString stringWithFormat:@"%@%@以上",@(minPrice),priceUnit];
    }else
    {
        lastSelectLabel.text = [NSString stringWithFormat:@"%@-%@%@",@(minPrice),@(maxPrice),priceUnit];
    }
    
    if ([priceUnit isEqualToString:@"元"])
    {
        _filterEntity.salePriceText = @"";
        _filterEntity.rentPriceText = lastSelectLabel.text;
    }else
    {
        _filterEntity.rentPriceText = @"";
        _filterEntity.salePriceText = lastSelectLabel.text;
    }
    
    // 没有选择价格则不变
    if (minPrice == 0 && maxPrice == 0)
    {
        lastSelectLabel.text = @"价格";
        lastSelectLabel.textColor = YCTextColorBlack;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
    }
    else
    {
        _filterEntity.isInpuntPrice = YES;
        _filterEntity.salePriceText = lastSelectLabel.text;
        lastSelectLabel.textColor = YCTextColorSelect;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
    }
    
    if (self.block)
    {
        self.block(lastSelectLabel.text);
    }
}

/// 设置输入框的值
- (void)setInputPriceValue
{
    if (_filterEntity.isInpuntPrice)
    {
        if (_firstTabSelectCellIndex == 0)
        {
            _minPriceTextField.text = _filterEntity.minRentPrice;
            _maxPriceTextField.text = _filterEntity.maxRentPrice;
//            if ([_filterEntity.maxRentPrice isEqualToString:@"9999999"])
//            {
//                _maxPriceTextField.text = @"";
//            }else
//            {
//                _maxPriceTextField.text = _filterEntity.maxRentPrice;
//            }
        }
        else
        {
            _minPriceTextField.text = _filterEntity.minSalePrice;
            _maxPriceTextField.text = _filterEntity.maxSalePrice;
//            if ([_filterEntity.maxSalePrice isEqualToString:@"9999999"])
//            {
//                _maxPriceTextField.text = @"";
//            }
//            else
//            {
//                _maxPriceTextField.text = _filterEntity.maxSalePrice;
//            }
        }
    }
    
    // 限制价格输入长度
    if (_firstTabSelectCellIndex == 0)
    {
        [_minPriceTextField setValue:@8 forKey:@"limit"];
        [_maxPriceTextField setValue:@8 forKey:@"limit"];
    }else
    {
        [_minPriceTextField setValue:@6 forKey:@"limit"];
        [_maxPriceTextField setValue:@6 forKey:@"limit"];
    }
}

// 清除筛选价格
- (void)clearPrice
{
    _filterEntity.maxRentPrice = @"";
    _filterEntity.minRentPrice = @"";
    _filterEntity.maxSalePrice = @"";
    _filterEntity.minSalePrice = @"";
}

// 清除筛选标签
- (void)clearTagText
{
    _filterEntity.isNewProInThreeDay = @"false";
    _filterEntity.isRecommend = @"false";
    _filterEntity.isOnlyTrust = @"false";
    _filterEntity.hasPropertyKey = @"false";
    _filterEntity.isPanorama = @"false";
    _filterEntity.isNoCall = @"false";
    _filterEntity.isPropertyKey = @"false";
    _filterEntity.isRealSurvey = @"false";
    
}

- (void)setDataSourceWithDataArray:(NSArray *)dataArray
                 andItemTitleArray:(NSArray *)itemTitleArray
                    andSelectIndex:(NSInteger)selectIndex
                   andFilterEntity:(FilterEntity *)filterEntity
{
    _dataSourceArray = [[NSMutableArray alloc] initWithArray:dataArray];
    _itemTitleArray = [itemTitleArray mutableCopy];
    _selectIndex = selectIndex;
    _filterEntity = filterEntity;
    
    // 默认第一个tablew选中第一行
    if ([_filterEntity.salePriceText contains:@"万"] || [_filterEntity.estDealTypeText isEqualToString:@"出售"])
    {
        _firstTabSelectCellIndex = 1;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewNumber == 1)
    {
        return [_dataSourceArray[_selectIndex] count];
    }
    else
    {
        if (tableView == _firstTableView)
        {
            if ([_filterEntity.estDealTypeText contains:@"出"])
            {
                return 1;
            }
            return [_dataSourceArray[_selectIndex] count];
        }
        else
        {
            NSDictionary *dic = _dataSourceArray[_selectIndex];
            return [[dic objectForKey:[_dataSourceArray[_selectIndex] allKeys][_firstTabSelectCellIndex]] count];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterListCell * filterListCell = [FilterListCell cellWithTableView:tableView];
    
    filterListCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (self.tableViewNumber == 1)
    {
        NSString *itemText;
        if ([_dataSourceArray[_selectIndex][indexPath.row] isKindOfClass:[SelectItemDtoEntity class]])
        {
           SelectItemDtoEntity * entity = _dataSourceArray[_selectIndex][indexPath.row];
            itemText = entity.itemText;
        }
        else
        {
            itemText = _dataSourceArray[_selectIndex][indexPath.row];
        }
        filterListCell.filterLabel.text = itemText;

        // 筛选实体中的字段设为红色
        if ([itemText isEqualToString: _filterEntity.estDealTypeText])
        {
            filterListCell.filterLabel.textColor = YCTextColorSelect;
        }else if([_filterEntity.tagText isEqualToString:@"标签"] && indexPath.row == 0)
        {
            if (_selectIndex == 2)
            {
                filterListCell.filterLabel.textColor = YCTextColorSelect;
            }else
            {
                filterListCell.filterLabel.textColor = YCTextColorBlack;
            }
            
        }else if ([itemText isEqualToString: _filterEntity.tagText])
        {
            filterListCell.filterLabel.textColor = YCTextColorSelect;
        }
        else if ([itemText isEqualToString: _filterEntity.clientDealTypeText])
        {
            filterListCell.filterLabel.textColor = YCTextColorSelect;
        }else if ([itemText isEqualToString: _filterEntity.clientStatuText])
        {
            filterListCell.filterLabel.textColor = YCTextColorSelect;
        }else
        {
            filterListCell.filterLabel.textColor = YCTextColorBlack;

        }
    }
    else
    {
        if (tableView == _firstTableView)
        {
            // 选中时的状态，字体变红，背景变白
            if (indexPath.row == _firstTabSelectCellIndex || [_filterEntity.estDealTypeText contains:@"出"])
            {
                filterListCell.filterLabel.textColor = [UIColor whiteColor];
                filterListCell.contentView.backgroundColor = YCThemeColorGreen;
            }
            else
            {
                filterListCell.filterLabel.textColor = YCTextColorBlack;
                filterListCell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            if ([_filterEntity.estDealTypeText isEqualToString:@"出售"])
            {
                filterListCell.filterLabel.text = [_dataSourceArray[_selectIndex] allKeys][indexPath.row + 1];
            }
            else
            {
               filterListCell.filterLabel.text = [_dataSourceArray[_selectIndex] allKeys][indexPath.row];
            }
        }
        else
        {
            NSArray * dataArray = [_dataSourceArray[_selectIndex] allKeys];
            NSString *priceStr = [_dataSourceArray[_selectIndex] objectForKey:dataArray[_firstTabSelectCellIndex]][indexPath.row];
            
            filterListCell.filterLabel.textColor = YCTextColorBlack;
            
            // 如果筛选过价格筛选实体中的字段设为选中，没有默认选中第一行不限
            if (_filterEntity.salePriceText.length > 0 || _filterEntity.rentPriceText.length > 0)
            {
                if ([priceStr isEqualToString:_filterEntity.salePriceText] || [priceStr isEqualToString:_filterEntity.rentPriceText])
                {
                    filterListCell.filterLabel.textColor = YCTextColorSelect;
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    filterListCell.filterLabel.textColor = YCTextColorSelect;
                }
            }
            
            filterListCell.filterLabel.text = priceStr;
        }
    }

    return filterListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    // 改变ItemView箭头文字颜色以及将选择的文字回调
    UILabel *lastSelectLabel = (UILabel *)[[super superview] viewWithTag:ItemTitleBaseTag + _selectIndex];
    UIImageView *selectArrowImg = (UIImageView *)[[super superview] viewWithTag:ArrowImageBaseTag + _selectIndex];

    if (self.tableViewNumber == 2)
    {
        // 第一个tablew
        if (tableView == _firstTableView)
        {
            if (indexPath.row == 0)
            {
                // 出租
                _firstTabSelectCellIndex = 0;
                [_minPriceTextField setValue:@8 forKey:@"limit"];
                [_maxPriceTextField setValue:@8 forKey:@"limit"];
            }
            else
            {
                // 出售
                _firstTabSelectCellIndex = 1;
                if (_minPriceTextField.text.length > 6)
                {
                    _minPriceTextField.text = @"";
                }
                if (_maxPriceTextField.text.length > 6)
                {
                    _maxPriceTextField.text = @"";
                }
                [_minPriceTextField setValue:@6 forKey:@"limit"];
                [_maxPriceTextField setValue:@6 forKey:@"limit"];
            }
            [self setInputPriceValue];
            [_secondTableView setContentOffset:CGPointMake(0,0) animated:NO];
            [_firstTableView reloadData];
            [_secondTableView reloadData];
            return;
        }
        else
        {
            // 第二个tablew
            NSArray * dataArray = [_dataSourceArray[_selectIndex] allKeys];
            NSString *priceStr = [_dataSourceArray[_selectIndex] objectForKey:dataArray[_firstTabSelectCellIndex]][indexPath.row];
            _filterEntity.isInpuntPrice = NO;
            
            [self clearPrice];
            
            if (_firstTabSelectCellIndex == 0)
            {
                _filterEntity.priceType = @"出租价格(元)";
                _filterEntity.rentPriceText = [priceStr isEqualToString:@"不限"] ? @"" : priceStr;
                _filterEntity.salePriceText = @"";
                
                if (indexPath.row == 0) {
                    
                    _filterEntity.rentPriceText = [priceStr isEqualToString:@"不限"] ? @"" : priceStr;
                    _filterEntity.salePriceText = @"";
                    
                }else if (indexPath.row == 1)
                {
                    _filterEntity.maxRentPrice = @"2000";
                    _filterEntity.minRentPrice = @"";
//                    _filterEntity.minRentPrice = @"0";
                }
                else if (indexPath.row == [[_dataSourceArray[_selectIndex] objectForKey:dataArray[_firstTabSelectCellIndex]] count] - 1)
                {
//                    _filterEntity.maxRentPrice = @"9999999";
                    _filterEntity.maxRentPrice = @"";
                    _filterEntity.minRentPrice = @"12000";
                }
                else
                {
                    _filterEntity.maxRentPrice = [[[priceStr componentsSeparatedByString:@"~"] lastObject]stringByReplacingOccurrencesOfString:@"元" withString:@""];
                    _filterEntity.minRentPrice = [[[priceStr componentsSeparatedByString:@"~"] firstObject]stringByReplacingOccurrencesOfString:@"元" withString:@""];
                }
            }
            else
            {
                _filterEntity.priceType = @"出售价格(万)";
                _filterEntity.salePriceText = [priceStr isEqualToString:@"不限"] ? @"" : priceStr;
                _filterEntity.rentPriceText = @"";
                
                if (indexPath.row == 0) {
                    
                    _filterEntity.rentPriceText = [priceStr isEqualToString:@"不限"] ? @"" : priceStr;
                    _filterEntity.salePriceText = @"";
                    
                }else if (indexPath.row == 1)
                {
                    _filterEntity.maxSalePrice = @"150";
                    _filterEntity.minSalePrice = @"";
//                    _filterEntity.minSalePrice = @"0";
                }
                else if (indexPath.row == [[_dataSourceArray[_selectIndex] objectForKey:dataArray[_firstTabSelectCellIndex]] count] - 1)
                {
//                    _filterEntity.maxSalePrice = @"9999999";
                    _filterEntity.maxSalePrice = @"";
                    _filterEntity.minSalePrice = @"1000";
                }
                else
                {
                    _filterEntity.maxSalePrice = [[[priceStr componentsSeparatedByString:@"~"] lastObject]stringByReplacingOccurrencesOfString:@"万" withString:@""];
                    _filterEntity.minSalePrice = [[[priceStr componentsSeparatedByString:@"~"] firstObject]stringByReplacingOccurrencesOfString:@"万" withString:@""];
                }
            }
            lastSelectLabel.text = [priceStr isEqualToString:@"不限"]? @"价格":priceStr;
        }
    }
    else
    {
        // 只有一个tablew
        NSString *selectLabel;
        if ([_dataSourceArray[_selectIndex][indexPath.row] isKindOfClass:[SelectItemDtoEntity class]])
        {
            SelectItemDtoEntity * entity = _dataSourceArray[_selectIndex][indexPath.row];
            selectLabel = entity.itemText;
        }
        else
        {
            selectLabel = _dataSourceArray[_selectIndex][indexPath.row];
        }
        
        if (_selectIndex == 0)  // 全部
        {
            _filterEntity.estDealTypeText = selectLabel;
            lastSelectLabel.text = _filterEntity.estDealTypeText;
            
            // 选择房源类型，清空价格标签
            _filterEntity.priceType = @"价格";
            _filterEntity.rentPriceText = @"";
            _filterEntity.salePriceText = @"";
            [self clearPrice];
            UILabel *priceLabel =  (UILabel *)[[super superview] viewWithTag:ItemTitleBaseTag + 1];
            UIImageView *priceArrowImg = (UIImageView *)[[super superview] viewWithTag:ArrowImageBaseTag + 1];
            priceLabel.text = @"价格";
            priceLabel.textColor = YCTextColorBlack;
            [priceArrowImg setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
        }
        else if (_selectIndex == 2)     // 标签
        {
            _filterEntity.tagText = [selectLabel isEqualToString:@"不限"]? @"标签":selectLabel;
            lastSelectLabel.text = _filterEntity.tagText;
            
            [self clearTagText];
            if ([_filterEntity.tagText isEqualToString:@"推荐房源"])
            {
                _filterEntity.isRecommend = @"true";
            }
            else if ([_filterEntity.tagText isEqualToString:@"新上房源"])
            {
                _filterEntity.isNewProInThreeDay = @"true";
            }
            else if([_filterEntity.tagText isEqualToString:@"签约"]||[_filterEntity.tagText isEqualToString:@"独家"])
            {
                _filterEntity.isOnlyTrust = @"true";
            }
            else if([_filterEntity.tagText isEqualToString:@"钥匙"])
            {
                _filterEntity.isPropertyKey = @"true";
            }
            else if ([_filterEntity.tagText isEqualToString:@"360度全景"])
            {
                _filterEntity.isPanorama = @"true";
            }
            else if ([_filterEntity.tagText isEqualToString:@"实勘"])
            {
                _filterEntity.isRealSurvey = @"true";
            }
            else if ([_filterEntity.tagText isEqualToString:@"免扰房"])
            {
                _filterEntity.isNoCall = @"true";
            }
        }
        else if ([_itemTitleArray[_selectIndex] isEqualToString:@"交易类型"])
        {
            _filterEntity.clientDealTypeText = [selectLabel isEqualToString:@"不限"]? @"交易类型":selectLabel;
            lastSelectLabel.text = _filterEntity.clientDealTypeText;
        }
        else if ([_itemTitleArray[_selectIndex] isEqualToString:@"客户状态"])
        {
            _filterEntity.clientStatuText = [selectLabel isEqualToString:@"有效"]? @"客户状态":selectLabel;
            lastSelectLabel.text = _filterEntity.clientStatuText;
        }
    }
    
    if (self.block)
    {
        self.block(lastSelectLabel.text);
    }
    
    // 选择的是第一行 则ItemView上的颜色不变
    if (indexPath.row == 0)
    {
        lastSelectLabel.textColor = YCTextColorBlack;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
    }
    else
    {
        lastSelectLabel.textColor = YCTextColorSelect;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _firstTableView.frame = CGRectMake(0, 0, self.frame.size.width, [_dataSourceArray[_selectIndex] count] * TableViewCellHeight);
    
    if (self.tableViewNumber == 2)
    {   
        _firstTableView.frame = CGRectMake(0, 0, 130, TableViewRowNumber * TableViewCellHeight);
        _secondTableView.frame = CGRectMake(130, 0, self.frame.size.width - self.frame.size.width / 3, (TableViewRowNumber -1) * TableViewCellHeight);
    }
}

@end
