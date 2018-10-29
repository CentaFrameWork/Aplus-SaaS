//
//  SaveSearchCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/18.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "SaveSearchCell.h"

@implementation SaveSearchCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.15*NewRatio, 62*NewRatio, 16.7*NewRatio)];
    _label1.font = [UIFont systemFontOfSize:14*NewRatio];
    _label1.textColor = YCTextColorGray;
    _label1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame)+12*NewRatio, 0.15*NewRatio, 235*NewRatio, 16.7*NewRatio)];
    _label2.font = [UIFont systemFontOfSize:14*NewRatio];
    _label2.textColor = YCTextColorBlack;
    _label2.numberOfLines = 0;
    [self.contentView addSubview:_label2];
    
}

- (void)setString:(NSString *)string {
    _string = string;
    NSMutableString *muStr = [NSMutableString stringWithFormat:@"%@",string];
    NSArray *array = [muStr componentsSeparatedByString:@"："];
    
    _label1.text = array[0];
    
    if (array.count == 2) {
        _label2.text = [NSString stringWithFormat:@"%@",array[1]];
        CGSize size = CGSizeMake(235*NewRatio, CGFLOAT_MAX);
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
        CGSize titleh = [array[1] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat titleH = titleh.height;
        _label2.frame = CGRectMake(CGRectGetMaxX(_label1.frame)+12*NewRatio, 0.15*NewRatio, 235*NewRatio, titleH);
        _Max = titleH+6*NewRatio;
    }else {
        _Max = 20*NewRatio;
    }
    
}

@end
