//
//  JMDetailPresentView.m
//  PanKeTong
//
//  Created by Admin on 2018/4/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMDetailPresentView.h"
#import "JMDealCell.h"
@interface JMDetailPresentView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) UIView *bigView;
@property (nonatomic,copy) NSString *numberString;

@property (nonatomic,assign) SeeType type;
@end
@implementation JMDetailPresentView

//查看房号
- (instancetype)initPresentViewWithNumber:(NSString*)number withTpe:(SeeType)type{
    
    if (self = [super init]) {
        
        self.type = type;
        self.numberString = number;
        [self initView];
    }
    
    return self;
}

- (instancetype)initPresentViewWithArray:(NSArray*)array {
    
    
    if (self = [super init]) {
        
        self.array = array;
        [self initTable];
    }
    
    return self;
    
}
- (instancetype)initPresentViewContactWithArray:(NSArray *)array{
    
    
    if (self = [super init]) {
        
        _array = array;
        [self initTable];
        
        _bigView.y -= APP_NAV_HEIGHT;
        
    }
    
    return self;
}

- (void)initTable {
    
     [self addSubview:self.bigView];
    
    CGFloat height = self.array.count > 6? 264 : 44 *self.array.count;
    _bigView.frame = CGRectMake(12, (APP_SCREEN_HEIGHT-height-85)/2, APP_SCREEN_WIDTH-24, height+ 85);
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, _bigView.width,35)];
    label1.text = @" 联系人类型";
    label1.font = [UIFont systemFontOfSize:24];
    label1.textColor = YCTextColorBlack;
    [self.bigView addSubview:label1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(24, label1.bottom+8, _bigView.width-48, 0.5)];
    lineView.backgroundColor = RGBColor(238, 238, 238);
    [self.bigView addSubview:lineView];
    
    
    self.myTableView.frame = CGRectMake(24, lineView.bottom, _bigView.width-48, self.bigView.height-CGRectGetMaxY(label1.frame));
    
    [self.bigView addSubview:self.myTableView];
    
    
}


- (void)initView {
    
  
    [self addSubview:self.bigView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, _bigView.width,75)];
    label1.numberOfLines = 0;
    label1.textAlignment = 1;
    NSString *string =self.type == SeeHouse? @"查看":@"拨打";
    NSString *titleString = [NSString stringWithFormat:@"您今天剩余%@次数\n%@次",string,self.numberString];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSForegroundColorAttributeName: YCTextColorBlack,NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    
    [title addAttributes:@{NSForegroundColorAttributeName: YCThemeColorRed} range:[titleString rangeOfString:self.numberString]];
    
    label1.attributedText = title.copy;
    [_bigView addSubview:label1];
    
    
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom, _bigView.width, 26)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = 1;
    label2.text = [NSString stringWithFormat:@"是否继续%@?",string];
    label2.textColor = YCTextColorAuxiliary;
    [_bigView addSubview:label2];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(24, label2.bottom+25, (_bigView.width - 72)/2, 50)];
    [btn1 setLayerCornerRadius:5];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    btn1.backgroundColor = YCThemeColorOrange;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bigView addSubview:btn1];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.right+24, btn1.top, btn1.width, 50)];
    btn2.tag = 1;
    [btn2 setLayerCornerRadius:5];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    btn2.backgroundColor = YCThemeColorGreen;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bigView addSubview:btn2];
    
    
    
    
    
}

- (void)btnClick:(UIButton*)btn {
    
    if (btn.tag) {
        
        if ([self.delegate respondsToSelector:@selector(didClickSureBtn:withType:)]) {
            
            [self.delegate didClickSureBtn:btn withType:self.type];
        }
        
    }else{
        
     
        
    }
    [self removeFromSuperview];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.array.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMDealCell *cell = [[JMDealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PresentV"];
    
    cell.customerLabel.text = self.array[indexPath.row][0];
    cell.typeLabel.text = self.array[indexPath.row][1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.delegate respondsToSelector:@selector(didSelectCell:)]) {
        
        [self.delegate didSelectCell:indexPath.row];
    }
    
    [self removeFromSuperview];
    

}
- (UIView *)bigView {
    
    if (!_bigView) {
        
        self.frame = MainScreenBounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        _bigView = [[UIView alloc] initWithFrame:CGRectMake(12, 175*WIDTH_SCALE2, APP_SCREEN_WIDTH-24, 145+ 85)];
        _bigView.backgroundColor = [UIColor whiteColor];
        [_bigView setLayerCornerRadius:5];
    }
    return _bigView;
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:0];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [UIView new];
    }
    
    return _myTableView;
    
}


- (void)setArray:(NSArray *)array {
    
    NSMutableArray *mutA = [NSMutableArray array];
    for (NSString *string in array) {
        
        NSUInteger firstLocation = [string rangeOfString:@"("].location;
         NSUInteger lastLocation = [string rangeOfString:@")"].location;
        
        NSString *fir = [string substringToIndex:firstLocation];
        
        NSString *last = [string substringWithRange:NSMakeRange(firstLocation+1, lastLocation-firstLocation-1)];
        
        [mutA addObject:@[last,fir]];
        
    }
    
    _array = mutA.copy;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

@end
