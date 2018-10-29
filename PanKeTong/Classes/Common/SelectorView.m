//
//  SelectorView.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "SelectorView.h"
#import "AppDelegate.h"

@interface SelectorView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;                // 列表
@property (nonatomic, strong)UIView *whiteView;                     // 底部View
@property (nonatomic, strong)UILabel *titleLabel;                   // 标题
@property (nonatomic, strong)UIView *lineView;                      // 顶部分割线

@end

@implementation SelectorView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initView];
//    }
//    return self;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    // self
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    self.frame = mainWindow.bounds;
    self.backgroundColor = UICOLOR_RGB_Alpha(0x333333, 0.3);
    [mainWindow addSubview:self];
    
    // 白色View
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, 1, APP_SCREEN_WIDTH-24*NewRatio, 1)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 5*NewRatio;
    _whiteView.clipsToBounds = YES;
    [self addSubview:_whiteView];
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*NewRatio, 25*NewRatio, 300*NewRatio, 22*NewRatio)];
    _titleLabel.font = [UIFont systemFontOfSize:22*NewRatio];
    _titleLabel.textColor = YCTextColorBlack;
    [_whiteView addSubview:_titleLabel];
    
    // 顶部分割线
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(25*NewRatio, CGRectGetMaxY(_titleLabel.frame)+12*NewRatio, 301*NewRatio, 1)];
    _lineView.backgroundColor = UICOLOR_RGB_Alpha(0xf6f6f6, 1.0);
    [_whiteView addSubview:_lineView];
    
    // 列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(25*NewRatio, CGRectGetMaxY(_lineView.frame), 301*NewRatio, 1) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.bounces = NO;
    [_whiteView addSubview:_tableView];
    
}

// 标题
- (void)setTitStr:(NSString *)titStr {
    _titleLabel.text = [NSString stringWithFormat:@"%@",titStr ? : @"请选择"];
}

// 列表数据
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    // 超过六个的滑动显示
    NSInteger number = _dataArray.count;
    if (number >= 6) {
        number = 6;
    }
    
    // 白色View
    CGFloat whiteViewHeight = (62 + 25 + number * 51) * NewRatio;
    _whiteView.frame = CGRectMake(12*NewRatio, (APP_SCREEN_HEIGHT-whiteViewHeight)/2, APP_SCREEN_WIDTH-24*NewRatio, whiteViewHeight);
    
    // 列表
    CGFloat tableViewHeight = (number * 51 + 10) * NewRatio;
    _tableView.frame = CGRectMake(25*NewRatio, CGRectGetMaxY(_lineView.frame), 301*NewRatio, tableViewHeight);
    
    // 刷新
    [_tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 内容
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame), 51*NewRatio)];
        label.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
        label.textColor = YCTextColorBlack;
        label.tag = 110;
        [cell.contentView addSubview:label];
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*NewRatio, CGRectGetWidth(cell.frame), 1)];
        lineView.backgroundColor = UICOLOR_RGB_Alpha(0xf6f6f6, 1.0);
        [cell.contentView addSubview:lineView];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:110];
    label.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    
    return cell;
}

// cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51*NewRatio;
}

// 返回每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

// cell 回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _theOption(indexPath.row);
    [self removeFromSuperview]; // 删除视图
}

// 删除视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView * view = [touches anyObject].view;
    
    if (view == self) {
        
        [self removeFromSuperview];     // 删除视图
        
    }
    
}

- (void)setSelectIndex:(NSInteger)index{
    
    __block typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [weakSelf.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    });
    
}

@end
