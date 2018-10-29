//
//  FollowUpContentCell.m
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "FollowUpContentCell.h"

@implementation FollowUpContentCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(NewContactModel *)model {
    _rightInputTextView.tag = _indexPath.section;
    _rightInputTextView.text = model.note;
    
}


@end
