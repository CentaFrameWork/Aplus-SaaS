//
//  rightTopView.m
//  PanKeTong
//
//  Created by Admin on 2018/3/23.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "rightTopView.h"
#define viewX 200
#define viewW 170
@interface rightTopView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSArray *array;

@end
@implementation rightTopView


- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr {
    
    rightTopView *view = [[rightTopView alloc] initWithFrame:frame];
     view.array = arr;
    [view addSubview:view.myTableView];
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(viewX+viewW-15 ,1 ,10 , 10)];
        arrowImgView.image = [UIImage imageNamed:@"Slice"];
        [self addSubview:arrowImgView];
       
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.array.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"right"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"right"];
        
    }
    
    if (indexPath.row >1) {
        cell.imageView.image = [UIImage imageNamed:@"checkM"];
    }else{
       cell.imageView.image = [UIImage imageNamed:@"top_right_icon"];
    }
    
    
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textColor = YCTextColorBlack;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (self.didSelect) {
        
        
        self.didSelect([NSNumber numberWithInteger:indexPath.row+1]);
    }
    [self removeFromSuperview];
    
}
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(viewX, 10, viewW, self.array.count * 44) style:0];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        
    }
    
    return _myTableView;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
    
}
@end
