//
//  SelectPropertyVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/8.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SelectPropertyVC.h"
#import "AllRoundDetailBasicMsgCell.h"
#import "AddTakingSeeVC.h"
#import "MBProgressHUD.h"

#import "JMSelectPropertySearchHeaderView.h"

#import "GetPropListApi.h"
#import "PropListEntity.h"
#import "PropertysModelEntty.h"
#import "GetPropDetailApi.h"
#import "PropPageDetailEntity.h"

@interface SelectPropertyVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    UITextField *_searchTF;
    UITableView *_tableView;
    UITextField *_textFiled;
    UILabel *_noDatalabel;      // 暂无数据的提示
    MBProgressHUD *_showMbHUD;

    PropertysModelEntty *_propertysModelEntty;
    PropPageDetailEntity *_propPageDetailEntity;
}

@end

@implementation SelectPropertyVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    // 导航栏TitleView
    [self initNavView];

    [self initView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init 

- (void)initNavView {
    
    self.navigationItem.title = _searchText;
    
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    JMSelectPropertySearchHeaderView * headView = [JMSelectPropertySearchHeaderView viewFromXib];
    
    headView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 72);
    
    [self.view addSubview:headView];
    
    _textFiled = headView.textField;
    
    [headView.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];

//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 80)];
//    headView.backgroundColor = [UIColor whiteColor];
//    CGFloat width = APP_SCREEN_WIDTH - 60 - 80;
//    _textFiled = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 20, width, 40)];
//    _textFiled.limitLength = 10;
//    _textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _textFiled.layer.borderWidth = 1;
//    _textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
//    // 设置显示模式为永远显示(默认不显示)
//    _textFiled.leftViewMode = UITextFieldViewModeAlways;
//
//    _textFiled.placeholder = @"输入房号";
//    _textFiled.font = [UIFont systemFontOfSize:16.0];
//    [headView addSubview:_textFiled];
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.frame = CGRectMake(_textFiled.right + 20, 21, 80, 38);
//    searchBtn.backgroundColor = RGBColor(234, 39, 11);
//    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:searchBtn];

    _tableView.tableHeaderView = headView;

    _noDatalabel = [[UILabel alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 200) / 2, 200, 200, 200)];
    _noDatalabel.text = @"没有找到您需要的房源～";
    _noDatalabel.textAlignment = NSTextAlignmentCenter;
    _noDatalabel.textColor = [UIColor grayColor];
    [self.view addSubview:_noDatalabel];
    _noDatalabel.hidden = YES;
}

#pragma mark - 搜索

- (void)searchAction:(UIButton *)btn {
    [_textFiled resignFirstResponder];

    if (_textFiled.text.length == 0)
    {
        showMsg(@"请输入房号");
        return;
    }

    [self showHUDLoadingView:nil];
    SysParamItemEntity *propStatus = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_STATUS];
    NSArray *listArr = propStatus.itemList;
    NSString *statusStr;
    for (SelectItemDtoEntity *entity in listArr)
    {
        if ([entity.itemText isEqualToString:@"有效"])
        {
            statusStr = entity.itemValue;
            break;
        }
    }
    GetPropListApi *getPropListApi = [[GetPropListApi alloc] init];

    getPropListApi.keywordType = @"楼盘";

    NSArray *textArr = [_searchText componentsSeparatedByString:@"-"];
    getPropListApi.searchKeyWord = textArr[0];
    getPropListApi.buildingNames = textArr[1];
    getPropListApi.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ESTATENAME];
    NSString *searchNo = _textFiled.text;
    getPropListApi.houseNo = searchNo;
    getPropListApi.propertyTypes = @[];
    getPropListApi.popStatus = @[statusStr];
    getPropListApi.houseDirection = @[];
    getPropListApi.propertyboolTag = @[];
    getPropListApi.buildTypes = @[];
    getPropListApi.hasPropertyKey = @"false";
    getPropListApi.propListTyp = @"1";
    getPropListApi.isNewProInThreeDay = @"false";
    getPropListApi.isOnlyTrust = @"false";
    getPropListApi.pageIndex = @"1";
    getPropListApi.isRecommend = @"false";
    NSString *propScopeStr = [NSString stringWithFormat:@"%@",@([AgencyUserPermisstionUtil getPropScope])];
    getPropListApi.scope = propScopeStr;
    [_manager sendRequest:getPropListApi];
}

#pragma mark - RequestData

- (void)requestData {
    if (_propertysModelEntty.keyId.length > 0)
    {
        GetPropDetailApi *getPropDetailApi = [[GetPropDetailApi alloc] init];
        getPropDetailApi.propKeyId = _propertysModelEntty.keyId;
        [_manager sendRequest:getPropDetailApi];
    }
    else
    {
        _noDatalabel.hidden = NO;
        _propPageDetailEntity = nil;
        [self hiddenHUDLoadingView];
    }
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_propPageDetailEntity == nil)
    {
        return 0;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        return 44;
    }
    
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, APP_SCREEN_WIDTH - 24, 20)];
        leftlabel.font = [UIFont systemFontOfSize:16.0];
        leftlabel.text = [NSString stringWithFormat:@"%@%@%@",_propertysModelEntty.estateName,_propertysModelEntty.buildingName,_propertysModelEntty.houseNo];
        [cell.contentView addSubview:leftlabel];
        
        return cell;
    }

    // 房源详情
    AllRoundDetailBasicMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allRoundDetailBasicMsgCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllRoundDetailBasicMsgCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    /**
     *  设置页面价格
     */
    NSString *propSalePriceResultStr;  // 房源售价
    NSString *propRentPriceResultStr;  // 房源租价
    NSString *propSalePriceUnitStr;    // 售价单位
    NSString *propSquareResultStr;     // 房屋面积

    //只显示万
    propSalePriceResultStr = _propPageDetailEntity.salePrice;
    propSalePriceUnitStr = @"万";
//    // 计算售价
//    if (_propPageDetailEntity.salePrice.doubleValue >= 10000)
//    {
//        propSalePriceResultStr = [NSString stringWithFormat:@"%.f", [_propPageDetailEntity.salePrice doubleValue] / 10000.0];
//
//        propSalePriceUnitStr = @"亿";
//    }
//    else
//    {
//        propSalePriceResultStr = [NSString stringWithFormat:@"%.f", _propPageDetailEntity.salePrice.doubleValue];
//        propSalePriceUnitStr = @"万";
//    }
//
//    if ([propSalePriceResultStr rangeOfString:@".00"].location != NSNotFound)
//    {
//        // 不是有效的数字，去除小数点后的0
//        propSalePriceResultStr = [propSalePriceResultStr substringToIndex:propSalePriceResultStr.length - 3];
//    }

    propSquareResultStr = [NSString stringWithFormat:@"%.2f", _propPageDetailEntity.square.doubleValue];

    if ([propSquareResultStr rangeOfString:@".00"].location != NSNotFound)
    {
        // 不是有效面积，去掉小数点后面的0
        propSquareResultStr = [propSquareResultStr substringToIndex:propSquareResultStr.length - 3];
    }

    propSalePriceResultStr = [NSString stringWithFormat:@"%@%@/%@平"
                              ,propSalePriceResultStr
                              ,propSalePriceUnitStr
                              ,propSquareResultStr];
    /**
     *
     * 售价处显示的不同颜色字体
     *
     */
    NSMutableAttributedString *propSaleAttriStr;
    if (propSalePriceResultStr)
    {

        propSaleAttriStr = [[NSMutableAttributedString alloc] initWithString:propSalePriceResultStr];

        NSInteger grayColorStarIndex = propSalePriceResultStr.length - propSquareResultStr.length - 2;
        NSInteger grayColorLength = propSquareResultStr.length+2;

        [propSaleAttriStr addAttribute:NSForegroundColorAttributeName
                                 value:LITTLE_GRAY_COLOR
                                 range:NSMakeRange(grayColorStarIndex, grayColorLength)];
        [propSaleAttriStr addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:FontName
                                                       size:11.0]
                                 range:NSMakeRange(grayColorStarIndex, grayColorLength)];
    }

    /**
     *  计算售单价
     */
    NSString *propSaleUnitPriceValueStr = nil;
    
    //陈行修改287bug
//    if (_propPageDetailEntity.saleUnitPrice.doubleValue > 0) {
    
    propSaleUnitPriceValueStr = [NSString stringWithFormat:@"%.2f",_propPageDetailEntity.saleUnitPrice.doubleValue];
    
    if ([propSaleUnitPriceValueStr rangeOfString:@".00"].location != NSNotFound){
        
        // 不是有效面积，去掉小数点后面的0
        propSaleUnitPriceValueStr = [propSaleUnitPriceValueStr substringToIndex:propSaleUnitPriceValueStr.length - 3];
    }
    
    propSaleUnitPriceValueStr = [NSString stringWithFormat:@"%@元/平",propSaleUnitPriceValueStr];
        
//    }else{
//
//        propSaleUnitPriceValueStr = @"-";
//
//    }

    /**
     *  计算租价
     */
    propRentPriceResultStr = [NSString stringWithFormat:@"%.2f", _propPageDetailEntity.rentPrice.doubleValue];
    if ([propRentPriceResultStr rangeOfString:@".00"].location != NSNotFound)
    {
        // 不是有效的数字，去除小数点后的0
        propRentPriceResultStr = [propRentPriceResultStr substringToIndex:propRentPriceResultStr.length - 3];
    }
    propRentPriceResultStr = [NSString stringWithFormat:@"%@元/月", propRentPriceResultStr];

    /**
     *  租价处显示的不同颜色字体
     */
    NSMutableAttributedString *propRentAttriStr;
    if (propRentPriceResultStr)
    {

        propRentAttriStr = [[NSMutableAttributedString alloc] initWithString:propRentPriceResultStr];

        [propRentAttriStr addAttribute:NSForegroundColorAttributeName
                                 value:LITTLE_GRAY_COLOR
                                 range:NSMakeRange(propRentPriceResultStr.length-3, 3)];
        [propRentAttriStr addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:FontName
                                                       size:11.0]
                                 range:NSMakeRange(propRentPriceResultStr.length-3, 3)];
    }

    /**
     *  设置页面价格
     */
    NSInteger propTrustType = [_propertysModelEntty.trustType integerValue];
    if (propTrustType == SALE)
    {
        // 出售
        cell.propFirstPriceTitleLabel.text = @"售价：";
        [cell.propSalePriceLabel setAttributedText:propSaleAttriStr];
        cell.propSalePriceUnitLabel.text = propSaleUnitPriceValueStr;

         cell.propRentTitleLabel.text = nil;
         cell.propRentValueTitleLabel.text = nil;
         cell.propRentPriceTitleTopHeight.constant = 0;
         cell.propRentPriceValueTopHeight.constant = 0;
    }
    else if (propTrustType == RENT)
    {
        /**
         *  只有租价的时候，显示的格式为：租价/平米
         */
        propRentPriceResultStr = [NSString stringWithFormat:@"%@/%@平", propRentPriceResultStr, propSquareResultStr];

        NSMutableAttributedString *onlyPropRentPriceAttrStr;

        if (propRentPriceResultStr)
        {
            onlyPropRentPriceAttrStr= [[NSMutableAttributedString alloc] initWithString:propRentPriceResultStr];

            [onlyPropRentPriceAttrStr addAttribute:NSForegroundColorAttributeName
                                             value:LITTLE_GRAY_COLOR
                                             range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-5,
                                                               propSquareResultStr.length+5)];
            [onlyPropRentPriceAttrStr addAttribute:NSFontAttributeName
                                             value:[UIFont fontWithName:FontName
                                                                   size:11.0]
                                             range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-5,
                                                               propSquareResultStr.length+5)];
        }

        cell.propFirstPriceTitleLabel.text = @"租价：";
        [cell.propSalePriceLabel setAttributedText:onlyPropRentPriceAttrStr];
        cell.propSalePriceUnitTitleLabel.hidden = YES;
        cell.propRentPriceTitleTopHeight.constant = 0;
        cell.propRentPriceValueTopHeight.constant = 0;
        cell.propRentTitleLabel.text = nil;
        cell.propRentValueTitleLabel.text = nil;
        cell.propSalePriceUnitLabel.hidden = YES;
    }
    else if (propTrustType == BOTH)
    {
        // 租售
        cell.propFirstPriceTitleLabel.text = @"售价：";
        cell.propRentTitleLabel.text = @"租价：";
        cell.propRentPriceTitleTopHeight.constant = 15.0;
        cell.propRentPriceValueTopHeight.constant = 15.0;

        [cell.propSalePriceLabel setAttributedText:propSaleAttriStr];
        [cell.propRentValueTitleLabel setAttributedText:propRentAttriStr];
        cell.propSalePriceUnitLabel.text = propSaleUnitPriceValueStr;
    }

    cell.propHouseTypeLabel.text = _propPageDetailEntity.roomType;
    cell.propFloorLabel.text = _propPageDetailEntity.floor;
    cell.propRightLabel.text = _propPageDetailEntity.propertyCardClassName;
    cell.propDirectionLabel.text = _propPageDetailEntity.houseDirection;
    cell.propHouseSituationLabel.text = _propPageDetailEntity.propertySituation;
    cell.propBringSeeTimesLabel.text = [NSString stringWithFormat:@"%@",_propPageDetailEntity.takeSeeCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_propPageDetailEntity != nil)
    {
        if (indexPath.row == 1)
        {
            // 选择房源---(关闭当前页面返回新增约看)
            NSArray *vcArr = self.navigationController.viewControllers;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectProperty" object:_propertysModelEntty];
            [self.navigationController popToViewController:[vcArr objectAtIndex:vcArr.count - 4] animated:YES];
        }
    }
}

#pragma mark - <MBProgressHUD>

- (void)initShowHUDView {
    [_showMbHUD removeFromSuperview];

    _showMbHUD = nil;

    _showMbHUD = [[MBProgressHUD alloc]initWithView:self.view];
    _showMbHUD.mode = MBProgressHUDModeCustomView;

    UIImageView *hudBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -6, 45, 45)];
    [hudBgImageView setImage:[UIImage imageNamed:@"spinner_outer"]];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = MAXFLOAT * 0.4;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
    animation.repeatCount = MAXFLOAT;
    [hudBgImageView.layer addAnimation:animation forKey:nil];

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -3, 35, 35)];
    [iconView setImage:[UIImage imageNamed:@"zy_icon"]];

    [iconView addSubview:hudBgImageView];

    _showMbHUD.customView = iconView;
    [self.view addSubview:_showMbHUD];
}

- (void)showHUDLoadingView:(NSString *)message {
    [self initShowHUDView];

    _showMbHUD.labelText = message ? message : @"";
    [_showMbHUD show:YES];
}

- (void)hiddenHUDLoadingView {
    if (_showMbHUD)
    {
        [_showMbHUD hide:YES];
    }
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    if ([modelClass isEqual:[PropListEntity class]])
    {
        PropListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.propertysModel.count > 0)
        {
            _noDatalabel.hidden = YES;
            _propertysModelEntty = entity.propertysModel[0];
            // 加载房源详情
            [self requestData];
        }
        else
        {
            // 没有该房源消息
            _noDatalabel.hidden = NO;
            _propPageDetailEntity = nil;
            [_tableView reloadData];
            [self hiddenHUDLoadingView];
        }
    }

    if ([modelClass isEqual:[PropPageDetailEntity class]])
    {
        _propPageDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        [self hiddenHUDLoadingView];
        [_tableView reloadData];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];
}

@end
