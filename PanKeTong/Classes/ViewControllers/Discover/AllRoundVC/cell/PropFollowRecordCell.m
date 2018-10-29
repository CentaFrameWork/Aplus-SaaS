//
//  PropFollowRecordCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PropFollowRecordCell.h"

@implementation PropFollowRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgConfirm.hidden = YES;
    _propFollowDetailLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                          andSize:13.0];
    _propFollowOtherMsgLabel.font = [UIFont setFontSizeWithFontName:FontName
                                                            andSize:13.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
