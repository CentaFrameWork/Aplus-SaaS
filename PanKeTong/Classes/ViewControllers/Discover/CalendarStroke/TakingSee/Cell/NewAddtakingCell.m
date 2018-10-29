//
//  NewAddtakingCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/1.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "NewAddtakingCell.h"
#import "AddTakingSeeVC.h"

@implementation NewAddtakingCell{

}


- (void)layoutSubviews{
    [super layoutSubviews];
    _contentLabel.text = _content;
    if (_content.length > 0 && _deleteBtn.hidden == NO) {
        _deleteBtn.hidden = NO;
        _addBtn.hidden = YES;
    }else{
        _deleteBtn.hidden = YES;
        _addBtn.hidden = NO;
    }

}






@end
