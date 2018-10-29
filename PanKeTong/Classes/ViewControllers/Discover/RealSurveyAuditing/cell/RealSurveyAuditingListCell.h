//
//  RealSurveyAuditingListCell.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RealSurveyAuditingListEntity;

@interface RealSurveyAuditingListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *estateNameAndBuildinName;
@property (weak, nonatomic) IBOutlet UILabel *photoCount;
@property (weak, nonatomic) IBOutlet UILabel *realSurveyPersonName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *personDeptDepName;
@property (weak, nonatomic) IBOutlet UILabel *houseDirectionAndHouseType;

@property (nonatomic, strong) RealSurveyAuditingListEntity *realSurveyAuditingListEntity;

@end
