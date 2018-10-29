//
//  NewContactInformationCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

// 联系人信息
#import "NewContactInformationCell.h"

@implementation NewContactInformationCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, 300*NewRatio, 32*NewRatio)];
    label.textColor = YCTextColorGray;
    label.font = [UIFont systemFontOfSize:14*NewRatio];
    label.text = @"联系人信息（手机和座机至少填写一个）";
    [self.contentView addSubview:label];
}

@end
