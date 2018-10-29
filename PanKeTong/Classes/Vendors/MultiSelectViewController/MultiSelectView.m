//
//  MultiSelectView.m
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "MultiSelectView.h"
#import "OwnerEntity.h"

#define      IdentifyOwnerBtnTag       15001   //删除确认业主baseTag


@implementation MultiSelectView
{
    UITableView *_mainTableView;
    NSMutableArray *_dataSourceArray;
    NSMutableArray *_stateArray;
    UIButton *_cancelButton;
    UIButton *_determineButton;
    
}


- (id)initWithFrame:(CGRect)frame andDataSourceArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _dataSourceArray = [NSMutableArray arrayWithArray:array];
        _stateArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            [_stateArray addObject:@0];
        }
        
        [self creatSubview];
    }
    return self;
}

- (void)creatSubview
{
    
    self.backgroundColor = [UIColor clearColor];
  
    UIView *backGround = [[UIView alloc] initWithFrame:self.bounds];
    backGround.backgroundColor = [UIColor blackColor];
    backGround.alpha  = 0.3;
    [self addSubview:backGround];
    

    NSInteger dataSourceCount = _dataSourceArray.count;
    
    
    float tableViewHeight = dataSourceCount * 44;
    
    
    if (dataSourceCount >= 6) {
        tableViewHeight = 6 * 44;
    }
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, tableViewHeight + 40 + 70)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 8;
    whiteView.layer.masksToBounds = YES;
    whiteView.center = self.center;
    [self addSubview:whiteView];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.width , 40)];
    title.text = @"确认业主";
    [title setTextColor:[UIColor blackColor]];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:title];
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(title.x,title.bottom , 250, tableViewHeight)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [whiteView addSubview:_mainTableView];
    

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(15, _mainTableView.bottom + 20, 80, 30);
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor redColor]];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _cancelButton.layer.cornerRadius = 8;
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton addTarget:self action:@selector(clickCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_cancelButton];
    
    
    _determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _determineButton.frame = CGRectMake(whiteView.width - _cancelButton.width - 15, _cancelButton.y, _cancelButton.width, _cancelButton.height);
    [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_determineButton setBackgroundColor:[UIColor redColor]];
    _determineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
    _determineButton.layer.cornerRadius = 8;
    _determineButton.layer.masksToBounds = YES;
    [_determineButton addTarget:self action:@selector(clickDetermineAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_determineButton];
    
    
}

// 取消
- (void)clickCancelAction
{
    if ([self.delegate respondsToSelector:@selector(cancelAction)]) {
        [self.delegate cancelAction];
    }
}

// 确定
- (void)clickDetermineAction
{
    NSInteger dataSourceCount = _dataSourceArray.count;
    NSMutableArray *ownerArray = [NSMutableArray array];
    
    for (int i = 0; i < dataSourceCount ; i++) {
        
        NSNumber *stats = _stateArray[i];

        if ([stats boolValue]) {
            OwnerEntity *entity = _dataSourceArray[i];
            [ownerArray addObject:entity];
        }
    }

    if ([self.delegate respondsToSelector:@selector(determineAction:)]) {
        [self.delegate determineAction:ownerArray];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MultiSelectCell";
    
    MultiSelectCell *multiSelectCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!multiSelectCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"MultiSelectCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        multiSelectCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    // 去除点击效果
    multiSelectCell.delegate = self;
    [multiSelectCell setSelectionStyle:UITableViewCellSelectionStyleNone];

    OwnerEntity *trustor = _dataSourceArray[indexPath.row];
    
    NSNumber *number  = _stateArray[indexPath.row];

    multiSelectCell.nameText.text = trustor.trustorName;
    multiSelectCell.switchButton.on = [number boolValue];
    multiSelectCell.switchButton.tag = IdentifyOwnerBtnTag + indexPath.row;
    
    return multiSelectCell;
}

#pragma mark -<MultiSelectCellDelegate"

- (void)clickSwithAction:(UISwitch *)Switch
{
    NSInteger presentSelect = Switch.tag - IdentifyOwnerBtnTag;
    [_stateArray replaceObjectAtIndex:presentSelect withObject:[NSNumber numberWithBool:Switch.on]];
    
    
    if ([self.delegate respondsToSelector:@selector(switchAction:)]) {
        [self.delegate switchAction:Switch];
    }
}

@end
