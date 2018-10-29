//
//  NoteTableViewCell.m
//  PanKeTong
//
//  Copyright © 2018年 连京帅. All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(NewContactModel *)model {
    _contentDescriptionLabel.text = @"备注";
    _contentDescriptionLabel.textColor = [UIColor blackColor];
    _rightInputTextView.tag = _indexPath.section;
    
    _rightInputTextView.text = model.note;
}


@end
