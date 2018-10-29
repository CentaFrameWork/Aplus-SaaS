//
//  AddEventView.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "AddEventView.h"

#import "JMAddEventViewCell.h"

#import "UITableView+Category.h"

#define TitleBtnBaseTag 2000

@interface AddEventView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView * tableView;

@end

@implementation AddEventView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ArrowHeight, self.width, RowHeight)];
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        tableView.scrollEnabled = NO;
        
        tableView.separatorColor = YCOtherColorDivider;
        
        [self addSubview:tableView];
        
        self.tableView = tableView;
        
    }
    
    return self;
    
}

- (void)setTitleArr:(NSArray *)titleArr {
    
    _titleArr = titleArr;
    
    self.tableView.height = RowHeight * titleArr.count;
    
    [self.tableView reloadData];
    
}

- (void)setIsHaveImage:(BOOL)isHaveImage {
    
    _isHaveImage = isHaveImage;
    
    [self.tableView reloadData];
    
}

- (void)setImageArr:(NSArray *)imageArr{
    
    _imageArr = imageArr;
    
    [self.tableView reloadData];
    
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"JMAddEventViewCell";
    
    JMAddEventViewCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    
    NSString *str = self.titleArr[indexPath.row];
    
    cell.titleLabel.text = str;
    
    if (_isHaveImage == YES){
        
        UIImage * image = [UIImage imageNamed:str];
        
        if (image == nil && _imageArr.count > indexPath.row) {
        
            image = [UIImage imageNamed:_imageArr[indexPath.row]];
        
        }
        
        cell.titleImageView.image = image;
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",str];
        
    }else{
        
        cell.titleImageView.image = nil;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *titleStr = self.titleArr[indexPath.row];
    
    [self.addEventDelegate addEventClickWithBtnTitle:titleStr];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return RowHeight;
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // 绘制背景图
    UIImage *img = [UIImage imageNamed:@"icon_jm_calendar_more_bg"];
    [img drawInRect:CGRectMake(0, 0, self.width, self.height)];

//    // 绘制分割线
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    for (int i = -1;  i < _titleArr.count - 1; i++)
//    {
//        // 获取画笔并设置起点位置
//        CGContextMoveToPoint(ref, 8, RowHeight * (i + 1) + ArrowHeight);
//        // 设置画笔的移动路线1（终点1）
//        CGContextAddLineToPoint(ref, self.width - 8,RowHeight * (i + 1) + ArrowHeight);
//
//        // 设置画笔的颜色
//        CGContextSetStrokeColorWithColor(ref, [UIColor blackColor].CGColor);
//
//        //设置画笔的宽度
//        CGContextSetLineWidth(ref, 1);
//
//        CGContextDrawPath(ref, kCGPathFillStroke);
//    }
}

@end
