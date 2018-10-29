//
//  TheEditorCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "TheEditorCell.h"

@implementation TheEditorCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editorBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 100, 0, 40, 30);
    _editorBtn.titleLabel.textColor = [UIColor lightGrayColor];
    [_editorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _editorBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_editorBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.contentView addSubview:_editorBtn];
    [[_editorBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.indexPathSectionEditorBtn(_indexPath.section);
    }];
    
    _deleateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleateBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 50, 0, 40, 30);
    [_deleateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_deleateBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_deleateBtn];
    [[_deleateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.indexPathSectionDeleateBtn(_indexPath.section);
    }];
    
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_MODIFY_ALL]) {
        _editorBtn.hidden = NO;
    }else {
        _editorBtn.hidden = YES;
    }
}

// 设置cell子视图位置
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
}

@end
