//
//  RealListTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "RealListTableViewCell.h"
#import "RealSurveyEntity.h"
#import "RealSurveyStatusEnum.h"

@implementation RealListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRealSurveyEntity:(RealSurveyEntity *)realSurveyEntity
{
    _realSurveyEntity = realSurveyEntity;
    
    self.realsurveyPerson.text = realSurveyEntity.realSurveyPerson;
    self.realsurveyTime.text = realSurveyEntity.realSurveyTime;
    self.realsurveyPhotoCount.text = realSurveyEntity.photoCount;
    
    NSInteger auditStatus = [realSurveyEntity.auditStatus integerValue];
    
    if (auditStatus == UNAPPROVED)
    {
        self.auditStatusLabel.text = @"未审核";
    }
    else if (auditStatus == APPROVED)
    {
        self.auditStatusLabel.text = @"审核通过";
    }
    else if (auditStatus == REJECT)
    {
        self.auditStatusLabel.text = @"审核拒绝";
    }
    else if (auditStatus == TWOAPPROVED)
    {
        self.auditStatusLabel.text = @"复审通过";
    }
    else if (auditStatus == TWOREJECT)
    {
        self.auditStatusLabel.text = @"复审拒绝";
    }
}


@end
