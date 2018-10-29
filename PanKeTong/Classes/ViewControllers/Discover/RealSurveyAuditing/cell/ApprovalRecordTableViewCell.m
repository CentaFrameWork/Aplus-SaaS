//
//  ApprovalRecordTableViewCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ApprovalRecordTableViewCell.h"
#import "RealSurveyStatusEnum.h"

@implementation ApprovalRecordTableViewCell{
    UILabel *_statusLabel;//状态
    UILabel *_namelabel;//审核人姓名
    UILabel *_timelabel;//时间
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = APP_SCREEN_WIDTH / 3;
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = [UIFont fontWithName:FontName size:16.0];
    [self.contentView addSubview:_statusLabel];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, 50)];
    _namelabel.textAlignment = NSTextAlignmentCenter;
    _namelabel.font = [UIFont fontWithName:FontName size:16.0];
    [self.contentView addSubview:_namelabel];
    
    _timelabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 2, 0, width - 20, 50)];
    _timelabel.textAlignment = NSTextAlignmentCenter;
    _timelabel.font = [UIFont fontWithName:FontName size:16.0];
    _timelabel.numberOfLines = 2;
    [self.contentView addSubview:_timelabel];

}

#pragma mark-绘制图形
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIImage *img1 = [UIImage imageNamed:@"Linecheck_line_1"];
    [img1 drawInRect:CGRectMake(APP_SCREEN_WIDTH / 3, 15, 2, 20)];
    
    UIImage *img2 = [UIImage imageNamed:@"Linecheck_line_1"];
    [img2 drawInRect:CGRectMake(APP_SCREEN_WIDTH / 3 * 2, 15, 2, 20)];
}


#pragma mark-<setMethod>
- (void)setApprovalRecordEntity:(ApprovalRecordEntity *)approvalRecordEntity{
    if (_approvalRecordEntity != approvalRecordEntity) {
        _approvalRecordEntity = approvalRecordEntity;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    NSInteger status = [_approvalRecordEntity.approvalStatus integerValue];
    if (status == APPROVED) {
        _statusLabel.text = @"审核通过";
        _statusLabel.textColor = [UIColor greenColor];
    }else if (status == UNAPPROVED){
        _statusLabel.text = @"正在审核";
        _statusLabel.textColor = [UIColor orangeColor];
    }else if (status == REJECT){
        _statusLabel.text = @"审核失败";
        _statusLabel.textColor = [UIColor redColor];
    }
    
    _namelabel.text = _approvalRecordEntity.auditorName;
    
    _timelabel.text = _approvalRecordEntity.time;
    
    
    
}



@end
