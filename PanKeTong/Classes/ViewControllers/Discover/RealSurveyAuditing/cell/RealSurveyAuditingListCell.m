//
//  RealSurveyAuditingListCell.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingListCell.h"
#import "RealSurveyAuditingListEntity.h"

@implementation RealSurveyAuditingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRealSurveyAuditingListEntity:(RealSurveyAuditingListEntity *)realSurveyAuditingListEntity
{
    _realSurveyAuditingListEntity = realSurveyAuditingListEntity;
    
    double timeDouble = [CommonMethod tryTimeNumberWith:realSurveyAuditingListEntity.realSurveyDate];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[realSurveyAuditingListEntity.realSurveyDate substringToIndex:4] integerValue]];
    
    self.estateNameAndBuildinName.text = [NSString stringWithFormat:@"%@   %@",realSurveyAuditingListEntity.estateName,realSurveyAuditingListEntity.buildinName?realSurveyAuditingListEntity.buildinName:@""];
    self.photoCount.text = [NSString stringWithFormat:@"%ld",realSurveyAuditingListEntity.photoCount];
    self.realSurveyPersonName.text = realSurveyAuditingListEntity.realSurveyPersonName;
    self.createTime.text = time;
    self.personDeptDepName.text = realSurveyAuditingListEntity.personDeptDepName;
    self.houseDirectionAndHouseType.text = [NSString stringWithFormat:@"%@   %@   数量: ",
                                                                  realSurveyAuditingListEntity.houseDirection?realSurveyAuditingListEntity.houseDirection:@"",
                                                                  realSurveyAuditingListEntity.houseType?realSurveyAuditingListEntity.houseType:@""];
}

@end
