//
//  DealDeatailHeadCell.m
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealDeatailHeadCell.h"
@interface DealDeatailHeadCell ()


@property (nonatomic,strong) UIView *lineUp;
@property (nonatomic,strong) UIView *lineDown;

@property (nonatomic,strong) UIImageView *indicateView;

@end

@implementation DealDeatailHeadCell

+ (instancetype)loadDealDetailHeadWithTableView:(UITableView*)tableView {
    
    
    DealDeatailHeadCell * headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    
    if (!headView) {
        
        headView = [[DealDeatailHeadCell alloc] initWithReuseIdentifier:@"head"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:headView action:@selector(tapHeadCell)];
        [headView addGestureRecognizer:tap];
        
       
    }

    
    return headView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(12, 0, APP_SCREEN_WIDTH-24, 44)];
//        backV.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:backV];
        
        
        
        _lineUp = [[UIView alloc] initWithFrame:CGRectMake(24, 0, 1, 10)];
        _lineUp.backgroundColor = YCThemeColorGreen;
        [backV addSubview:_lineUp];
        
        
        _lineDown = [[UIView alloc] initWithFrame:CGRectMake(24, 34, 1, 10)];
        _lineDown.backgroundColor = YCThemeColorGreen;
        [backV addSubview:_lineDown];
        
        
        
        
        
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 24, 24)];
//        _lineView.image = [UIImage imageNamed:@"small_icon"];
        [backV addSubview:_lineView];
        
        _headName = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right+5, 0, 150, 44)];
        _headName.textColor = YCTextColorBlack;
        _headName.font = [UIFont systemFontOfSize:14];
        [backV addSubview:_headName];
        
        
        _indicateView = [[UIImageView alloc] initWithFrame:CGRectMake(backV.width-26, 14, 14, 8)];
        _indicateView.image = [UIImage imageNamed:@"indicate_Back"];
        [backV addSubview:_indicateView];
        
    }
    
    return self;
}
- (void)tapHeadCell {
    
    
      if (self.headHaveData && [self.delegate respondsToSelector:@selector(didSelectHeadCell:)]) {
            
            [self.delegate didSelectHeadCell:self];
        }
        
    
}


- (void)setTypeString:(NSString *)typeString {
    
    _typeString = typeString;
    
       if (self.tag == 0) {
            
            _lineUp.hidden = YES;
            _lineDown.hidden = NO;
        } else if (self.tag == [self getIndex]) {
           
            _lineUp.hidden = NO;
            _lineDown.hidden = YES;

    
        }else{
             _lineUp.hidden = NO;
             _lineDown.hidden = NO;
           
        }
        
   
    
}

- (NSInteger)getIndex {
    
    NSInteger index;
    
    if ([_typeString contains:@"售"]) {
        
        index = 13;
        
    }else{
        
        index = 6;
    }
    
    return index;
}

- (void)setHeadIsOpen:(BOOL)headIsOpen {
    
    
    self.indicateView.transform = CGAffineTransformIdentity;
    
    if (headIsOpen) {
        
        self.lineView.image = [UIImage imageNamed:@"head_data"];
       
        self.indicateView.hidden = NO;
        
        
        self.indicateView.transform = CGAffineTransformRotate(_indicateView.transform, M_PI);
        
    }else{
        
        self.lineView.image = _headHaveData?[UIImage imageNamed:@"small_icon"]:[UIImage imageNamed:@"circle_gray"];
        
        self.indicateView.hidden = !_headHaveData;
    

    }
    
    
}

@end
