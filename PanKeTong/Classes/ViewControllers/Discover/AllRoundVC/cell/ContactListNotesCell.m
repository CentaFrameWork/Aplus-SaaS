//
//  ContactListNotesCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ContactListNotesCell.h"

@implementation ContactListNotesCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.clipsToBounds = YES;
    
    // 备注
    _beizhulabel = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 2*NewRatio, 40*NewRatio, 14*NewRatio)];
    _beizhulabel.textColor = YCTextColorGray;
    _beizhulabel.font = [UIFont systemFontOfSize:14*NewRatio];
    _beizhulabel.text = @"备注";
    [self.contentView addSubview:_beizhulabel];
    
    // 备注内容
    _notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*NewRatio, 0, 270*NewRatio, 14*NewRatio)];
    _notesLabel.textColor = YCTextColorBlack;
    _notesLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    _notesLabel.numberOfLines = 0;
    [_beizhulabel addSubview:_notesLabel];
    
}

- (void)setModel:(WJContactListModel *)model {
    _model = model;
    if (model.Remark.length >0) {
        _notesLabel.text = model.Remark;
        CGSize size = CGSizeMake(270*NewRatio, CGFLOAT_MAX);
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
        CGSize titleh = [model.Remark boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat titleH = titleh.height;
        _notesLabel.frame = CGRectMake(40*NewRatio, 0, 270*NewRatio, titleH);
    }else {
        _notesLabel.text = @"";
    }
}
@end
