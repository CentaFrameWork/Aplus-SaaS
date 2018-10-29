//
//  ChannelCallFilterViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/18.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelCallFilterViewController.h"


#define CellViewTag         201
#define ButtonTagBasic      202
#define MarkTag             200 //为了区别背景和现实button

#define C_Padding           5  //padding
#define C_Space             10 //行间距
#define C_Height            30 //行高
#define C_ColSum            3   //列数


@interface ChannelCallFilterViewController ()
{
    NSMutableArray *dataArray;
    DateTimePickerDialog *dateTimePickerDialog;
    SearchRemindType selectRemindType;
    NSDate *_startOldDate;
    NSDate *_endOldDate;

    NSDate *_startSelectDate;
    NSDate *_endSelectDate;
    ChannelFilterEntity *_channelFilterEntity;
}

//@property (nonatomic,strong)ChannelFilterEntity *channelFilterEntity;//筛选结果

@end

@implementation ChannelCallFilterViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self turnDataToModel];

    _startOldDate = _channelFilterEntity.startTime;
    _endOldDate = _channelFilterEntity.endTime;

    [self initview];
    [self initData];
    
    _mainTableView.tableHeaderView = nil;
}

#pragma mark - 转换实体

- (void)turnDataToModel
{
    _channelFilterEntity = [ChannelFilterEntity new];
    //转换所有的key首字母大写
    NSArray *allKeysArr = [_dataDic allKeys];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    for (NSString *key in allKeysArr) {
        [newDic setValue:_dataDic[key] forKey:key];

        //部门/部门
        if ([key isEqualToString:@"department"] || [key isEqualToString:@"person"]) {
            id departmentDic = [_dataDic objectForKey:key];
            if (![departmentDic isKindOfClass:[NSNull class]]) {
                NSMutableDictionary *newDepartmentDic = [NSMutableDictionary dictionary];
                NSArray *allKeysArr1 = [departmentDic allKeys];
                for (NSString *key1 in allKeysArr1) {
                    NSString *charStr = [key1 substringToIndex:1];
                    NSRange range = NSMakeRange(0, 1);
                    NSString *newKey1 = [key1 stringByReplacingCharactersInRange:range withString:[charStr capitalizedString]];
                    [newDepartmentDic setValue:departmentDic[key1] forKey:newKey1];
                }

                [newDic setValue:newDepartmentDic forKey:key];
                newDepartmentDic = nil;
            }
        }

        //筛选类型
        if ([key isEqualToString:@"channelSource"]) {
            id array = [_dataDic objectForKey:@"channelSource"];
            if (![array isKindOfClass:[NSNull class]]) {
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    NSMutableDictionary *dic2D = [NSMutableDictionary dictionary];
                    NSArray *allkeys2D = [dic allKeys];
                    for (NSString *key2D in allkeys2D) {
                        NSString *charStr = [key2D substringToIndex:1];
                        NSRange range = NSMakeRange(0, 1);
                        NSString *newKey2D = [key2D stringByReplacingCharactersInRange:range withString:[charStr capitalizedString]];
                        [dic2D setValue:dic[key2D] forKey:newKey2D];
                    }
                    [mArr addObject:dic2D];
                    dic2D = nil;
                }

                [newDic setValue:mArr forKey:key];
                mArr = nil;
            }
        }
    }

    _dataDic = newDic;
    newDic = nil;

    id start = [_dataDic objectForKey:@"startTime"];
    if (![start isKindOfClass:[NSNull class]]) {
        _channelFilterEntity.startTime = [_dataDic objectForKey:@"startTime"];
    }

    id end = [_dataDic objectForKey:@"endTime"];
    if (![end isKindOfClass:[NSNull class]]) {
        _channelFilterEntity.endTime = [_dataDic objectForKey:@"endTime"];
    }


    NSArray *array = [_dataDic objectForKey:@"channelSource"];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        SelectItemDtoEntity *entity = [DataConvert convertDic:dic toEntity:[SelectItemDtoEntity class]];
        [mArr addObject:entity];
    }
    NSLog(@"%@",mArr);
    _channelFilterEntity.channelSource = mArr;
    mArr = nil;

    NSDictionary *dic1 = [_dataDic objectForKey:@"department"];
    NSDictionary *dic2 = [_dataDic objectForKey:@"person"];
    RemindPersonDetailEntity *entity1 = [DataConvert convertDic:dic1 toEntity:[RemindPersonDetailEntity class]];
    RemindPersonDetailEntity *entity2 = [DataConvert convertDic:dic2 toEntity:[RemindPersonDetailEntity class]];
    _channelFilterEntity.department = entity1;
    _channelFilterEntity.person = entity2;

    NSLog(@"%@",_channelFilterEntity);
}

- (void)initview
{
    [self setNavTitle:@"筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"重置"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(reSet)]];
    
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(confirmClick)];
    [_confirmView addGestureRecognizer:tapGes];
}

- (void)initData
{
    if(!_channelFilterEntity){
        _channelFilterEntity = [[ChannelFilterEntity alloc]init];
    }
    
    //======================
    
    SysParamItemEntity *customerSourceSysParam = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_SOURCE];
    
    dataArray = [[NSMutableArray alloc]init];
    [dataArray addObjectsFromArray:customerSourceSysParam.itemList];
    
    if(!_channelFilterEntity.channelSource)
    {
        _channelFilterEntity.channelSource = [[NSMutableArray alloc]init];
    }
    
    
    //======================
    
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
}

- (void)reSet
{   
    [_channelFilterEntity.channelSource removeAllObjects];
    _channelFilterEntity.startTime = nil;
    _channelFilterEntity.endTime = nil;
    _channelFilterEntity.department = nil;
    _channelFilterEntity.person = nil;
    
    [_mainTableView reloadData];
}

- (void)confirmClick
{
    if(_channelFilterEntity.startTime && _channelFilterEntity.endTime){
        
        // 当前日历
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        // 对比时间差
        NSDateComponents *dateCom = [calendar components:unit fromDate:_channelFilterEntity.startTime toDate:_channelFilterEntity.endTime options:0];
        
      
        NSTimeInterval secondsInterval = [_channelFilterEntity.endTime timeIntervalSinceDate:_channelFilterEntity.startTime];
        
        if(secondsInterval <= 0)
        {
            showMsg(@"请输入正确的时间段");
            return;
        }
        
   
        if (dateCom.day > 30 || dateCom.month >= 1 || dateCom.year >= 1)
        {
            showMsg(@"为了保证查询速度，请查询少于30天的数据！");
            return;
        }
    }
    
    if(_delegate)
    {
        [_delegate channelFilterResult:_channelFilterEntity];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2)
    {
        if(_isShowStaff)
        {
            return 2;
        }
        return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //sumHeight = 2*padding + n*height + (n+1)*space
    if(indexPath.section == 0)
    {
        NSInteger count = dataArray.count / C_ColSum;
        NSInteger row = dataArray.count % C_ColSum;
        if (row != 0)
        {
            count ++;
        }
        NSInteger padding = C_Padding;
        NSInteger height = C_Height;
        NSInteger space = C_Space;
        NSInteger sumHeight = 2 * padding + count * height + (count + 1) * space;
        return sumHeight;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return 25;
    }
    else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        return nil;
    }
    
    UILabel *label=[[UILabel alloc]init];
    label.textColor = LITTLE_BLACK_COLOR;
    label.font = [UIFont fontWithName:FontName size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    switch (section) {
        case 0:
            label.text = @"渠道类型";
            break;
        case 1:
            label.text = @"来电时间";
            break;
            
        default:
            break;
    }
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *channelFilter = @"ChannelFilterTableViewCell";
    static NSString *channelCallTime = @"channelCallTimeTableViewCell";
    static NSString *channelStaffFilter = @"channelStaffFilterTableViewCell";
    
    NSInteger sctionIndex = indexPath.section;
    if(sctionIndex == 0)
    {
        ChannelFilterTableViewCell *channelFilterTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelFilter];
        if (!channelFilterTableViewCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ChannelFilterTableViewCell"
                                                  bundle:nil]
                                forCellReuseIdentifier:channelFilter];
            channelFilterTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelFilter];
        }
        
        //==================================
        
        // 找到容器View
        UIView *currentView = (UIView *)[channelFilterTableViewCell.contentView viewWithTag:CellViewTag];
        [currentView removeFromSuperview];
        // 创建根View
        UIView *view = [[UIView alloc]init];
        view.tag = CellViewTag;
        NSInteger itemHeight = C_Height;
        NSInteger itemSpace = C_Space;
        NSInteger padding = C_Padding;
        NSInteger paddingLeftAndRight = 50;
        NSInteger itemBgWidth = (APP_SCREEN_WIDTH - paddingLeftAndRight )/C_ColSum;
        
        NSInteger yPoint = 0;
        for (int i = 0; i < dataArray.count; i++)
        {
            // 这里row和col名称命名反了
            int row = i % C_ColSum;
            int col = i / C_ColSum;
            
            SelectItemDtoEntity *selectEntity = dataArray[i];
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
            // 测量显示文字的宽高
            CGSize size = [selectEntity.itemText boundingRectWithSize:CGSizeMake(MAXFLOAT, 26)
                                                              options: NSStringDrawingTruncatesLastVisibleLine
                                                           attributes:attribute
                                                              context:nil].size;
            
            yPoint = (col + 1) * itemSpace + col * itemHeight + padding;
            // 背景button
            UIButton * bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bgBtn.frame = CGRectMake(7 + row * (itemBgWidth + 10), yPoint, itemBgWidth,itemHeight);
            bgBtn.tag = i + ButtonTagBasic + MarkTag;
            [bgBtn addTarget:self action:@selector(itemBgClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bgBtn];
            
            // 点击button
            UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            labelBtn.userInteractionEnabled = NO;
            labelBtn.titleLabel.font = [UIFont fontWithName:FontName size:14.0];
            if (size.width + 10 > itemBgWidth)
            {
                size.width = itemBgWidth - 10;
            }
            
            labelBtn.frame = CGRectMake(bgBtn.frame.size.width / 2 - 5 - size.width / 2, 2, size.width + 10, 26);
            [labelBtn setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
            [labelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [labelBtn setTitle:selectEntity.itemText forState:UIControlStateNormal];
            labelBtn.tag = ButtonTagBasic + i;
            [labelBtn setBackgroundImage:[UIImage imageNamed:@"button_select_Img.png"] forState:UIControlStateSelected];
            [bgBtn addSubview:labelBtn];
            
            // button是否被选中
            for (int j = 0; j < _channelFilterEntity.channelSource.count; j++)
            {
                SelectItemDtoEntity * entity = _channelFilterEntity.channelSource[j];
                if ([selectEntity.itemText isEqualToString:entity.itemText])
                {
                    UIButton *bgButton = (UIButton *)[view viewWithTag:ButtonTagBasic + i + MarkTag];
                    bgButton.selected = YES;
                    UIButton *button = (UIButton *)[view viewWithTag:ButtonTagBasic + i];
                    button.selected = YES;
                }
            }
        }
        
        NSInteger count = dataArray.count / 4;
        NSInteger row = dataArray.count % 4;
        if (row != 0)
        {
            count ++;
        }
        
//        [view setBackgroundColor:[UIColor blueColor]];
        NSInteger viewHeight = yPoint + itemHeight + padding + itemSpace;
        view.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, viewHeight);
        channelFilterTableViewCell.contentView.tag = indexPath.section;
        [channelFilterTableViewCell.contentView addSubview:view];
        
        return channelFilterTableViewCell;
        
        //==================================
        
    }else if(sctionIndex == 1)
    {
        ChannelCallTimeTableViewCell *channelCallTimeTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelCallTime];
        if (!channelCallTimeTableViewCell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"ChannelCallTimeTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:channelCallTime];
            channelCallTimeTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelCallTime];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:OnlyDateFormat];
        
        NSString *startTime = [dateFormatter stringFromDate:_channelFilterEntity.startTime];
        NSString *endTime = [dateFormatter stringFromDate:_channelFilterEntity.endTime];
        
        [channelCallTimeTableViewCell.dateTimeStartBtn setTitle:startTime forState:UIControlStateNormal];
        [channelCallTimeTableViewCell.dateTimeEndBtn setTitle:endTime forState:UIControlStateNormal];
        channelCallTimeTableViewCell.delegate = self;
        
        return channelCallTimeTableViewCell;
        
    }else
    {
        ChannelStaffFilterTableViewCell *channelStaffFilterTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelStaffFilter];
        if (!channelStaffFilterTableViewCell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"ChannelStaffFilterTableViewCell"
                                                  bundle:nil]
            forCellReuseIdentifier:channelStaffFilter];
            channelStaffFilterTableViewCell = [tableView dequeueReusableCellWithIdentifier:channelStaffFilter];
        }
        
        channelStaffFilterTableViewCell.delegate = self;
        channelStaffFilterTableViewCell.tag = indexPath.row;
        
        if(indexPath.row == 0)
        {
            if(!_isShowStaff){
                [channelStaffFilterTableViewCell.labelForKey setText:@"原归属部门:"];
            }else{
                [channelStaffFilterTableViewCell.labelForKey setText:@"部门:"];
            }
            [channelStaffFilterTableViewCell.textFeildForValue setTitle:_channelFilterEntity.department.resultName forState:UIControlStateNormal];
        }
        else
        {
            [channelStaffFilterTableViewCell.labelForKey setText:@"人员:"];
            [channelStaffFilterTableViewCell.textFeildForValue setTitle:_channelFilterEntity.person.resultName forState:UIControlStateNormal];
        }
        
        return channelStaffFilterTableViewCell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 日期输入框点击回调

- (void)dateStartPick
{
    dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                        andDelegate:self
                                                             andTag:@"start"];
    dateTimePickerDialog.datePickerMode = UIDatePickerModeDate;
    [dateTimePickerDialog showWithDate:_channelFilterEntity.startTime andTipTitle:@"选择来电时间"];
}

- (void)dateEndPick
{
    dateTimePickerDialog = [DateTimePickerDialog initWithParentView:self.view
                                                        andDelegate:self
                                                             andTag:@"end"];
    dateTimePickerDialog.datePickerMode = UIDatePickerModeDate;
    [dateTimePickerDialog showWithDate:_channelFilterEntity.endTime andTipTitle:@"选择来电时间"];
}

#pragma mark - 选择时间结果回调
- (void)selectedResultWithSender:(NSObject *)sender andDate:(NSDate *)dateTime
{
    NSString *tag = ((DateTimePickerDialog *)sender).tag;
    if([tag isEqualToString:@"start"])
    {
        _channelFilterEntity.startTime = dateTime;
        _startSelectDate = dateTime;
        return;
    }
    
    if([tag isEqualToString:@"end"])
    {
        _channelFilterEntity.endTime = dateTime;
        _endSelectDate = dateTime;
        return;
    }
}

//确定
- (void)clickDone
{
    NSString *tag = dateTimePickerDialog.tag;
    if ([tag isEqualToString:@"start"]) {
        if (_channelFilterEntity.startTime == nil) {
            //没有滑动时显示当前时间
            _startSelectDate = [NSDate dateWithTimeIntervalSinceNow:0];
            _channelFilterEntity.startTime = _startSelectDate;
        }

        _startOldDate = _startSelectDate;

    }else{
        if (_channelFilterEntity.endTime == nil) {
            _endSelectDate = [NSDate dateWithTimeIntervalSinceNow:0];
            _channelFilterEntity.endTime = _endSelectDate;
        }

        _endOldDate = _endSelectDate;

    }

    [_mainTableView reloadData];
}

//取消
- (void)clickCancle{
    NSString *tag = dateTimePickerDialog.tag;
    if ([tag isEqualToString:@"start"]) {
        if (!_startOldDate) {
            _channelFilterEntity.startTime = nil;
            _startSelectDate = nil;
        }else{
            _startSelectDate = _startOldDate;
            _channelFilterEntity.startTime = _startOldDate;
        }

    }else{
        if (!_endOldDate) {
            _channelFilterEntity.endTime = nil;
            _endSelectDate = nil;

        }else{
            _endSelectDate = _endOldDate;
            _channelFilterEntity.endTime = _endOldDate;
        }

    }

    [_mainTableView reloadData];



}

#pragma mark - 部门人员点击回调
- (void)textFeildPressedWithSender:(NSObject *)sender
{
    NSString *selectRemindTypeStr;
    NSString *departmentKeyId = @"";
    
    ChannelStaffFilterTableViewCell *cell = (ChannelStaffFilterTableViewCell *)sender;
    switch (cell.tag) {
        case 0:
            //部门
            selectRemindType = DeparmentType;
            selectRemindTypeStr = DeparmentRemindType;
            departmentKeyId = @"";
            
            break;
        case 1:
            //人员
            
            selectRemindType = PersonType;
            selectRemindTypeStr = PersonRemindType;
            departmentKeyId = _channelFilterEntity.department.resultKeyId;
            if(!departmentKeyId){
                departmentKeyId = @"";
            }
            
            break;
            
        default:
            break;
    }
    
    SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                              initWithNibName:@"SearchRemindPersonViewController"
                                                              bundle:nil];
    searchRemindPersonVC.selectRemindType = selectRemindType;
    searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
    searchRemindPersonVC.departmentKeyId = departmentKeyId;
//    searchRemindPersonVC.selectedRemindPerson = _remindPersonsArr;
    searchRemindPersonVC.delegate = self;
    [self.navigationController pushViewController:searchRemindPersonVC
                                         animated:YES];
}

#pragma mark - SearchRemindPersonDelegate(搜索 部门，人员 返回结果)
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    switch (selectRemindType) {
        case PersonType:
            _channelFilterEntity.person = selectRemindItem;
            _channelFilterEntity.department = [[RemindPersonDetailEntity alloc]init];
            _channelFilterEntity.department.resultKeyId = selectRemindItem.departmentKeyId;
            _channelFilterEntity.department.resultName = selectRemindItem.departmentName;
            _channelFilterEntity.department.departmentKeyId = selectRemindItem.departmentKeyId;
            _channelFilterEntity.department.departmentName = selectRemindItem.departmentName;
            break;
            
        case DeparmentType:
        {
//            _channelFilterEntity.department = selectRemindItem;
            RemindPersonDetailEntity *remindDepartMent = _channelFilterEntity.department;
            if(remindDepartMent.departmentKeyId){
                if(![remindDepartMent.departmentKeyId isEqualToString:selectRemindItem.departmentKeyId]){
                    _channelFilterEntity.person = nil;
                }
            }
            
            _channelFilterEntity.department = selectRemindItem;
        }
            break;
            
        default:
            break;
    }
    
    [_mainTableView reloadData];
}


- (void)itemBgClick:(UIButton *)bgButton
{
    NSInteger selectIndex = bgButton.tag - MarkTag - ButtonTagBasic;
    SelectItemDtoEntity *selectEntity = dataArray[selectIndex];
    
    if (!bgButton.selected)
    {
        [_channelFilterEntity.channelSource addObject:selectEntity];
    }
    else
    {
        [_channelFilterEntity.channelSource removeObject:selectEntity];
    }
    
    [_mainTableView reloadData];
}



@end
