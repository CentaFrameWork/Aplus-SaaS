//
//  FilterView.m
//  Demo
//
//  Created by wanghx17 on 15/4/28.
//  Copyright (c) 2015年 wanghx17. All rights reserved.
//

#import "FilterView.h"
//#import "AppConfiguration.h"
#import "CommonMethod.h"
#import "SelectItemDtoEntity.h"

#import "UIScrollView+MJRefresh.h"
#import "FilterViewTableViewCell.h"
#import "FilterEntity.h"
#pragma mark - FilterTitleMessage

#define EstDealType                     @"EstDealType"      //房源交易类型
#define PriceType                       @"PriceType"        //价格类型(租/售)
#define TagLabel                        @"TagLabel"         //标签
#define ClientStatus                    @"ClientStatus"     //客户状态
#define ClientPriceType                 @"ClientPriceType"  //客户的价格
#define ClientDealType                  @"ClientDealType"   //客户交易类型

#define APP_WIDTH [UIScreen mainScreen].bounds.size.width
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FirstTableViewTag           10001
#define SecondTableViewTag          10002
#define ThirdTableViewTag           10003

@implementation FilterView{
    UITableView * _firstTableView;
    UITableView * _secondTableView;
    UITableView * _thirdTableView;
    NSArray                     * _firstArray;               //第一个数组
    NSArray                     * _secondArray;              //第二个数组
    NSMutableArray              * _thirdArray;               //第三个数组
    
    TableViewType _tableViewType;               //tableView类型
    
    NSString * _titleMessageType;               //具体筛选类型
    NSString * _titleType;                      //标题类型
    NSInteger _btnTag;                          //点击的是哪个button
    NSInteger _firstCount;                      //记录点击第1个tableview的行数
    NSInteger _secondCount;                     //记录点击第2个tableview的行数
    NSInteger _thirdCount;                      //记录点击第3个tableview的行数
    NSInteger _clickCount;                      //点击次数 第二次传出
    NSIndexPath *_selectedIndexPath;            //选中的索引
    
    FilterEntity * _filterEntity;
    FilterEntity * _historyData;
    
    BOOL _isRandom;     //点击的是不限
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        [self initData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeTableView)name:@"SelectTextField"object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeTableView)name:@"SelectFilterButton"object:nil];
        
    }
    return self;
}

#pragma mark- init method
- (void)initData{
    _firstArray = [[NSArray alloc]init];
    _secondArray = [[NSArray alloc]init];
    _thirdArray = [[NSMutableArray alloc]init];
    _tableViewType = 0;
    _btnTag = 0;
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedIndexPath = firstIndex;
    
}
- (void)removeTableView{
    [_firstTableView removeFromSuperview];
    [_secondTableView removeFromSuperview];
    [_thirdTableView removeFromSuperview];
    UIView * view = (UIView*)[self viewWithTag:111111];
    [view removeFromSuperview];
    _tableViewType = 0;
    _btnTag = 0;
    _clickCount = 0;
    
}

- (void)filterEntity:(FilterEntity *)entity;{
    _filterEntity = entity;
    _historyData = [_filterEntity copy];
}

- (void)creatTableViewWithFirstArray:(NSArray*)array1
                      AndSecondArray:(NSArray*)array2
                       AndThirdArray:(NSArray*)array3
                    AndTableViewType:(TableViewType)orderType
                           AndBtnTag:(NSInteger)tag
                        AndTitleType:(NSString*)titleType{
    _firstCount = 0;
    _secondCount = 0;
    _thirdCount = 0;
    if (_tableViewType == orderType && _btnTag ==  tag)
    {
        [self removeTableView];
    }
    else
    {
        [self removeTableView];
        _firstArray = array1;
        _secondArray = array2;
        _tableViewType = orderType;
        _titleMessageType = titleType;
        [self tableViewCreat];
        _btnTag = tag;
        
        _isRandom = NO;
        if (_tableViewType ==  2)
        {
            if ([titleType isEqualToString:ClientPriceType])
            {
                NSInteger count;
                if ([_filterEntity.priceType isEqualToString:@"不限"] || _filterEntity.priceType ==  nil)
                {
                    _isRandom = YES;
                    count = 0;
                }
                else if([_filterEntity.priceType isEqualToString:@"求租价格"])
                {
                    count = 1;
                }
                else
                {
                    count = array2.count - 1;
                }
                
                [self tableView:_firstTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:count
                                                                                           inSection:0]];
            }
            else
            {
                NSInteger count;
                if ([_filterEntity.estDealTypeText isEqualToString:@"全部"]||[_filterEntity.estDealTypeText isEqualToString:@"租售"])
                {
                    _isRandom = YES;
                    count = 2;
                }
                else if([_filterEntity.estDealTypeText isEqualToString:@"出租"]||[_filterEntity.estDealTypeText isEqualToString:@"出售"])
                {
                    count = 0;
                }
                //                else
                //                {
                //                    count = 1;
                //                }
                [self tableView:_firstTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:count
                                                                                           inSection:0]];
                
            }
        }
        
    }
}
- (void)tableViewCreat{
    CGRect firstFrame;
    CGRect secondFrame;
    CGRect thirdFrame;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.opaque = NO;
    view.tag = 111111;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClicktapGesture)];
    //设置点击次数和点击手指数
    
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [view addGestureRecognizer:tapGesture];
    [self addSubview:view];
    switch (_tableViewType)
    {
        case OneTableView:
            firstFrame = CGRectMake(0, 0, APP_WIDTH, 0);
            secondFrame = CGRectMake(0, 0, 0, 0);
            thirdFrame = CGRectMake(0,0,0,0);
            break;
        case TwoTableView:
            firstFrame = CGRectMake(0, 0, (APP_WIDTH/3)+20, 0);
            secondFrame = CGRectMake((APP_WIDTH/3)+20, 0, (APP_WIDTH/3*2)-20, 0);
            thirdFrame = CGRectMake(0,0,0,0);
            break;
        case ThreeTableView:
            firstFrame  = CGRectMake(0, 0, APP_WIDTH/4+1, 0);
            secondFrame = CGRectMake(APP_WIDTH/4, 0,(APP_WIDTH-APP_WIDTH/4)/2,0);
            thirdFrame = CGRectMake((APP_WIDTH/4)+((APP_WIDTH-APP_WIDTH/4)/2), 0,(APP_WIDTH-APP_WIDTH/4)/2,0);
            break;
            
        default:
            break;
    }
    
    _firstTableView = [[UITableView alloc]initWithFrame:firstFrame style:UITableViewStylePlain];
    _firstTableView.delegate = self;
    _firstTableView.dataSource = self;
    _firstTableView.tag = FirstTableViewTag;
    _firstTableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:_firstTableView];
    
    _secondTableView = [[UITableView alloc]initWithFrame:secondFrame style:UITableViewStylePlain];
    _secondTableView.tag = SecondTableViewTag;
    _secondTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:_secondTableView];
    _thirdTableView = [[UITableView alloc]initWithFrame:thirdFrame style:UITableViewStylePlain];
    _thirdTableView.tag = ThirdTableViewTag;
    _thirdTableView.delegate = self;
    _thirdTableView.dataSource = self;
    _thirdTableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:_thirdTableView];
    if (_tableViewType == 1)
    {
        _firstTableView.backgroundColor = [UIColor whiteColor];
    }
    else if(_tableViewType == 2)
    {
        _firstTableView.backgroundColor = [UIColor whiteColor];
        _secondTableView.backgroundColor = [UIColor whiteColor];
        _firstTableView.showsVerticalScrollIndicator = NO;
//        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //添加一个绿线
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, APP_HEIGHT- (APP_HEIGHT/3+50))];
        
        view.backgroundColor = YCThemeColorGreen;
        
        [_secondTableView addSubview:view];
        
        [self bringSubviewToFront:view];
        
    }
    else
    {
        _firstTableView.backgroundColor  = [UIColor colorWithRed:232.0/255 green:233.0/255 blue:232.0/255 alpha:1];
        _secondTableView.backgroundColor = [UIColor whiteColor];
        _thirdTableView.backgroundColor = [UIColor whiteColor];
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _firstTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.showsVerticalScrollIndicator = NO;
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    NSInteger hight =  _firstArray.count*49;
    if (hight>(APP_HEIGHT- (APP_HEIGHT/3+50)))
    {
        hight = APP_HEIGHT- (APP_HEIGHT/3+50);
    }
    switch (_tableViewType)
    {
        case OneTableView:
            _firstTableView.frame = CGRectMake(0, 0, APP_WIDTH, hight);
            _secondTableView.frame = CGRectMake(0, 0, 0, 0);
            _thirdTableView.frame = CGRectMake(0, 0, 0, 0);
            break;
        case TwoTableView:
            _firstTableView.frame = CGRectMake(0, 0, APP_WIDTH/3+20, APP_HEIGHT- (APP_HEIGHT/3+50));
            _secondTableView.frame = CGRectMake(APP_WIDTH/3+20, 0, (APP_WIDTH/3*2)-20, APP_HEIGHT- (APP_HEIGHT/3+50));
            _thirdTableView.frame = CGRectMake(0, 0, 0, 0);
            break;
        case ThreeTableView:
            _firstTableView.frame = CGRectMake(0, 0, APP_WIDTH/4+1, APP_HEIGHT- (APP_HEIGHT/3+50));
            _secondTableView.frame = CGRectMake(APP_WIDTH/4, 0,(APP_WIDTH-APP_WIDTH/4)/2,APP_HEIGHT- (APP_HEIGHT/3+50));
            _thirdTableView.frame = CGRectMake((APP_WIDTH/4)+((APP_WIDTH-APP_WIDTH/4)/2), 0,(APP_WIDTH-APP_WIDTH/4)/2, APP_HEIGHT- (APP_HEIGHT/3+50));
            break;
            
        default:
            break;
            
    }
    [UIView commitAnimations];
    
    [_firstTableView reloadData];
    [_secondTableView reloadData];
    [_thirdTableView reloadData];
}
#define mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == FirstTableViewTag)
    {
        return _firstArray.count;
    }
    else if (tableView.tag == SecondTableViewTag)
    {
        return [_secondArray[_firstCount] count];
    }
    else
    {
        return _thirdArray.count;
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifi = @"filterViewCell";
    FilterViewTableViewCell * filterCustomCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifi];
    if (!filterCustomCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"FilterViewTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifi];
        
        filterCustomCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifi];
    }
    if (_tableViewType == 1)
    {
        SelectItemDtoEntity * entity = _firstArray[indexPath.row];
        if ([_titleMessageType isEqualToString:EstDealType])
        {
            filterCustomCell.messageLabel.text = entity.itemText;
            [self sameString:entity.itemText AndString:_filterEntity.estDealTypeText andLabel:filterCustomCell.messageLabel];
        }
        if ([_titleMessageType isEqualToString:ClientDealType])
        {
            filterCustomCell.messageLabel.text = entity.itemText;
            [self sameString:entity.itemText AndString:_filterEntity.clientDealTypeText andLabel:filterCustomCell.messageLabel];
        }
        else if ([_titleMessageType isEqualToString:ClientStatus])
        {
            filterCustomCell.messageLabel.text = entity.itemText;
            [self sameString:entity.itemText AndString:_filterEntity.clientStatuText andLabel:filterCustomCell.messageLabel];
        }
        else if ([_titleMessageType isEqualToString:TagLabel])
        {
            filterCustomCell.messageLabel.text = _firstArray[indexPath.row];
            [self sameString:_firstArray[indexPath.row] AndString:_filterEntity.tagText andLabel:filterCustomCell.messageLabel];
        }
    }
    else if(_tableViewType == 2)
    {
        if (tableView.tag == FirstTableViewTag)
        {
            if (indexPath.row == _firstCount)
            {
                filterCustomCell.accessoryType = UITableViewCellAccessoryNone;
                UIView *normalView = [[UIView alloc]init];
                normalView.backgroundColor = YCThemeColorGreen;
                filterCustomCell.backgroundView = normalView;
                filterCustomCell.messageLabel.textColor = [UIColor whiteColor];
            }
            else
            {
                
                UIView *normalView = [[UIView alloc]init];
                normalView.backgroundColor = [UIColor whiteColor];
                filterCustomCell.backgroundView = normalView;
                filterCustomCell.messageLabel.textColor = YCTextColorBlack;
            }
        }
        else
        {
            
            filterCustomCell.accessoryType = UITableViewCellAccessoryNone;
            UIView *normalView = [[UIView alloc]init];
            normalView.backgroundColor = [UIColor whiteColor];
            filterCustomCell.backgroundView = normalView;
        }
        
        
        if (tableView.tag == FirstTableViewTag)
        {
            filterCustomCell.messageLabel.text = _firstArray[indexPath.row];
        }
        else
        {
            NSString * string = [_secondArray[_firstCount] objectAtIndex:indexPath.row];
            filterCustomCell.messageLabel.text = string;
            if ([_filterEntity.priceType isEqualToString:@"出售价格(万元)"]||[_filterEntity.priceType isEqualToString:@"求购价格"])
            {
                [self sameString:[_secondArray[_firstCount] objectAtIndex:indexPath.row] AndString:_filterEntity.salePriceText andLabel:filterCustomCell.messageLabel];
            }
            else if ([_filterEntity.priceType isEqualToString:@"出租价格(元)"]||[_filterEntity.priceType isEqualToString:@"求租价格"])
            {
                [self sameString:[_secondArray[_firstCount] objectAtIndex:indexPath.row] AndString:_filterEntity.rentPriceText andLabel:filterCustomCell.messageLabel];
            }
        }
        
    }
    else
    {
        
    }
    return filterCustomCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index = %@",indexPath);
    
    if (_tableViewType == 1)
    {
        _firstCount = indexPath.row;
        SelectItemDtoEntity * entity = _firstArray[_firstCount];
        
        if ([_titleMessageType isEqualToString:EstDealType])
        {
            _filterEntity.estDealTypeText = entity.itemText;
            _filterEntity.estDealTypeValue = entity.itemValue;
            _filterEntity.maxRentPrice = @"";
            _filterEntity.minRentPrice = @"";
            _filterEntity.maxSalePrice = @"";
            _filterEntity.minSalePrice = @"";
            _filterEntity.rentPriceText = @"";
            _filterEntity.salePriceText = @"";
            _filterEntity.moreFilterMaxRentPrice = @"";
            _filterEntity.moreFilterMaxSalePrice = @"";
            _filterEntity.moreFilterMinRentPrice = @"";
            _filterEntity.moreFilterMinSalePrice = @"";
            
        }
        if ([_titleMessageType isEqualToString:ClientStatus])
        {
            _filterEntity.clientStatuText = entity.itemText;
            _filterEntity.clientStatuValue = entity.itemValue;
            
        }
        if ([_titleMessageType isEqualToString:ClientDealType])
        {
            _filterEntity.clientDealTypeText = entity.itemText;
            _filterEntity.clientDealTypeValue = entity.itemValue;
            _filterEntity.priceType = nil;
            _filterEntity.maxRentPrice = @"";
            _filterEntity.minRentPrice = @"";
            _filterEntity.maxSalePrice = @"";
            _filterEntity.minSalePrice = @"";
            _filterEntity.rentPriceText = @"";
            _filterEntity.salePriceText = @"";
        }
        
        if ([_titleMessageType isEqualToString:EstDealType]||[_titleMessageType isEqualToString:ClientStatus])
        {
            NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:entity.itemText,@"key", nil];
            NSNotification *notification  = [NSNotification notificationWithName:@"FirstTitle" object:nil userInfo:diction];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else if ([_titleMessageType isEqualToString:ClientDealType])
        {
            NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:entity.itemText,@"key", nil];
            NSNotification *notification  = [NSNotification notificationWithName:@"SecondTitle" object:nil userInfo:diction];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else if ([_titleMessageType isEqualToString:TagLabel])
        {
            NSString * value = _firstArray[_firstCount];
            NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:value,@"key", nil];
            NSNotification *notification  = [NSNotification notificationWithName:@"ThirdTitle" object:nil userInfo:diction];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        if ([_titleMessageType isEqualToString:TagLabel])
        {
            _filterEntity.tagText = _firstArray[_firstCount];
            if ([_filterEntity.tagText isEqualToString:@"推荐房源"])
            {
                _filterEntity.isNewProInThreeDay = @"false";
                _filterEntity.isRecommend = @"true";
                _filterEntity.isOnlyTrust = @"false";
                _filterEntity.hasPropertyKey = @"false";
                _filterEntity.isRealSurvey = @"false";
            }
            else if ([_filterEntity.tagText isEqualToString:@"新上房源"])
            {
                _filterEntity.isNewProInThreeDay = @"true";
                _filterEntity.isRecommend = @"false";
                _filterEntity.isOnlyTrust = @"false";
                _filterEntity.hasPropertyKey = @"false";
                _filterEntity.isRealSurvey = @"false";
            }
            else if([_filterEntity.tagText isEqualToString:@"签约"]||[_filterEntity.tagText isEqualToString:@"独家"])
            {
                _filterEntity.isNewProInThreeDay = @"false";
                _filterEntity.isRecommend = @"false";
                _filterEntity.isOnlyTrust = @"true";
                _filterEntity.hasPropertyKey = @"false";
                _filterEntity.isRealSurvey = @"false";
            }
            else if([_filterEntity.tagText isEqualToString:@"钥匙"])
            {
                _filterEntity.isNewProInThreeDay = @"false";
                _filterEntity.isRecommend = @"false";
                _filterEntity.isOnlyTrust = @"false";
                _filterEntity.hasPropertyKey = @"true";
                _filterEntity.isRealSurvey = @"false";
            }
            else if([_filterEntity.tagText isEqualToString:@"实勘"])
            {
                _filterEntity.isNewProInThreeDay = @"false";
                _filterEntity.isRecommend = @"false";
                _filterEntity.isOnlyTrust = @"false";
                _filterEntity.hasPropertyKey = @"false";
                _filterEntity.isRealSurvey = @"true";
            }
            else
            {
                _filterEntity.isNewProInThreeDay = @"false";
                _filterEntity.isRecommend = @"false";
                _filterEntity.isOnlyTrust = @"false";
                _filterEntity.hasPropertyKey = @"false";
                _filterEntity.isRealSurvey = @"false";
            }
        }
        [self removeTableView];
        [self.delegate requestNeedEntity:_filterEntity andType:YES];
    }
    else if (_tableViewType == 2)
    {
        if (tableView.tag == FirstTableViewTag)
        {
            _firstCount = indexPath.row;
            if ([_titleMessageType isEqualToString:PriceType]||[_titleMessageType isEqualToString:ClientPriceType])
            {
                _filterEntity.priceType = _firstArray[_firstCount];
                if ([_filterEntity.priceType isEqualToString:@"不限"])
                {
                    
                    
                    if (_isRandom)
                    {
                        _clickCount++;
                        if (_clickCount == 2)
                        {
                            _filterEntity.maxRentPrice = @"";
                            _filterEntity.minRentPrice = @"";
                            _filterEntity.maxSalePrice = @"";
                            _filterEntity.minSalePrice = @"";
                            _filterEntity.rentPriceText = @"";
                            _filterEntity.salePriceText = @"";
                            if ([_titleMessageType isEqualToString:PriceType])
                            {
                                NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:@"不限",@"key", nil];
                                NSNotification *notification  = [NSNotification notificationWithName:@"SecondTitle" object:nil userInfo:diction];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];                            }
                            else
                            {
                                NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:@"不限",@"key", nil];
                                NSNotification *notification  = [NSNotification notificationWithName:@"ThirdTitle" object:nil userInfo:diction];
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }
                            
                            [self removeTableView];
                            [self.delegate requestNeedEntity:_filterEntity andType:YES];
                            
                        }
                    }
                    else
                    {
                        _filterEntity.maxRentPrice = @"";
                        _filterEntity.minRentPrice = @"";
                        _filterEntity.maxSalePrice = @"";
                        _filterEntity.minSalePrice = @"";
                        _filterEntity.rentPriceText = @"";
                        _filterEntity.salePriceText = @"";
                        
                        if ([_titleMessageType isEqualToString:PriceType])
                        {
                            NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:@"不限",@"key", nil];
                            NSNotification *notification  = [NSNotification notificationWithName:@"SecondTitle" object:nil userInfo:diction];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];                            }
                        else
                        {
                            NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:@"不限",@"key", nil];
                            NSNotification *notification  = [NSNotification notificationWithName:@"ThirdTitle" object:nil userInfo:diction];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                        [self removeTableView];
                        [self.delegate requestNeedEntity:_filterEntity andType:YES];
                    }
                    
                }
                
            }
        }
        else if (tableView.tag == SecondTableViewTag)
        {
            _secondCount = indexPath.row;
            if ([_titleMessageType isEqualToString:PriceType]||[_titleMessageType isEqualToString:ClientPriceType])
            {
                NSString * price = [_secondArray[_firstCount] objectAtIndex:_secondCount];
                NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:price,@"key", nil];
                if ([_titleMessageType isEqualToString:PriceType])
                {
                    NSNotification *notification  = [NSNotification notificationWithName:@"SecondTitle" object:nil userInfo:diction];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                else
                {
                    NSNotification *notification  = [NSNotification notificationWithName:@"ThirdTitle" object:nil userInfo:diction];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                if ([_filterEntity.priceType isEqualToString:@"出售价格(万元)"]||[_filterEntity.priceType isEqualToString:@"求购价格"])
                {
                    _filterEntity.salePriceText = [_secondArray[_firstCount] objectAtIndex:_secondCount];
                    if (_secondCount == 0)
                    {
                        _filterEntity.maxSalePrice = @"150";
                        _filterEntity.minSalePrice = @"0";
                    }
                    else if (_secondCount == [_secondArray[_firstCount] count]-1)
                    {
                        _filterEntity.maxSalePrice = @"";
//                        _filterEntity.maxSalePrice = @"9999999";
                        _filterEntity.minSalePrice = @"1000";
                    }
                    else
                    {
                        _filterEntity.maxSalePrice = [[[price componentsSeparatedByString:@"-"] lastObject]stringByReplacingOccurrencesOfString:@"万" withString:@""];
                        _filterEntity.minSalePrice = [[[price componentsSeparatedByString:@"-"] firstObject]stringByReplacingOccurrencesOfString:@"万" withString:@""];
                        
                    }
                    
                }
                else if ([_filterEntity.priceType isEqualToString:@"出租价格(元)"]||[_filterEntity.priceType isEqualToString:@"求租价格"])
                {
                    _filterEntity.rentPriceText = [_secondArray[_firstCount] objectAtIndex:_secondCount];
                    if (_secondCount == 0)
                    {
                        _filterEntity.maxRentPrice = @"2000";
                        _filterEntity.minRentPrice = @"0";
                    }
                    else if (_secondCount == [_secondArray[_firstCount] count]-1)
                    {
//                        _filterEntity.maxRentPrice = @"9999999";
                        _filterEntity.maxRentPrice = @"";
                        _filterEntity.minRentPrice = @"12000";
                    }
                    else
                    {
                        _filterEntity.maxRentPrice = [[[price componentsSeparatedByString:@"-"] lastObject]stringByReplacingOccurrencesOfString:@"元" withString:@""];
                        _filterEntity.minRentPrice = [[[price componentsSeparatedByString:@"-"] firstObject]stringByReplacingOccurrencesOfString:@"元" withString:@""];
                        
                    }
                }
                
            }
            
            [self removeTableView];
            [self.delegate requestNeedEntity:_filterEntity andType:YES];
        }
    }
    [_secondTableView reloadData];
    [_thirdTableView reloadData];
    [_firstTableView reloadData];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (MODEL_VERSION >=  7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (MODEL_VERSION >=  8.0) {
            
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

#pragma mark - compareString
- (UILabel *)sameString:(NSString *)firstString AndString:(NSString *)secondString andLabel:(UILabel *)label{
    if ([firstString isEqualToString:secondString ])
    {
        label.textColor = YCThemeColorGreen;
    }
    else
    {
        label.textColor = YCTextColorBlack;
    }
    return label;
    
}

- (NSInteger)getDayWithDate:(NSInteger)day andMonth:(NSInteger)month{
    //获取几月之前或者几月之后
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:month];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
    //获取此月有多少天
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:newdate];
    
    if (day>days.length)
    {
        day = days.length;
    }
    return day;
}

#pragma mark - ShowAlert
- (void)showAlertWithTitle:(NSString *)alertTitle andMessage:(NSString *)message{
    
    UIAlertView *titleAlert = [[UIAlertView alloc]initWithTitle:alertTitle
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确认", nil];
    [titleAlert show];
    
}

- (void)ClicktapGesture{
    //    NSString * string;
    //    if ([_titleMessageType isEqualToString:EstDealType])
    //    {
    //        string = _historyData.estDealTypeText;
    //    }
    //    NSDictionary * diction = [[NSDictionary alloc]initWithObjectsAndKeys:string,@"key", nil];
    //    NSNotification *notification  = [NSNotification notificationWithName:@"revert"
    //                                                                object:nil
    //                                                              userInfo:diction];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //
    [self removeTableView];
    [self.delegate requestNeedEntity:_historyData andType:NO];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
