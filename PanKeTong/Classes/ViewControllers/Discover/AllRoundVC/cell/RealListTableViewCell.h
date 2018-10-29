//
//  RealListTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RealSurveyEntity;

@interface RealListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *realsurveyPerson;
@property (weak, nonatomic) IBOutlet UILabel *realsurveyTime;
@property (weak, nonatomic) IBOutlet UILabel *realsurveyPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *auditStatusLabel;

@property (nonatomic, strong) RealSurveyEntity *realSurveyEntity;

@end
