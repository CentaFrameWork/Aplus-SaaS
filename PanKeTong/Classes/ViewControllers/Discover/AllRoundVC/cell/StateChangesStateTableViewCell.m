//
//  StateChangesStateTableViewCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/5.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "StateChangesStateTableViewCell.h"

@implementation StateChangesStateTableViewCell


// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    _stateStrLab = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, APP_SCREEN_WIDTH/3, 52*NewRatio)];
    _stateStrLab.font = [UIFont systemFontOfSize:14*NewRatio];
    _stateStrLab.text = @"房源状态";
    _stateStrLab.textColor = YCTextColorBlack;
    [self.contentView addSubview:_stateStrLab];
    
    _stateResultsLab = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH/2, 0, APP_SCREEN_WIDTH/2-12*NewRatio, 52*NewRatio)];
    _stateResultsLab.font = [UIFont systemFontOfSize:14*NewRatio];
    _stateResultsLab.textColor = YCTextColorBlack;
    _stateResultsLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateResultsLab];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 78*ratio2, APP_SCREEN_WIDTH, 0.5)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 51*NewRatio, APP_SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = UICOLOR_RGB_Alpha(0xf4f4f4, 1.0);
    [self.contentView addSubview:lineView2];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (_propertyStatus == 0) {
        _stateResultsLab.text = @"无效";
    }else {
        _stateResultsLab.text = @"有效";
    }
}

@end
