//
//  TjRealListTableViewCell.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/6/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RealSurveyEntity;

@interface TjRealListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *realsurveyPerson;
@property (weak, nonatomic) IBOutlet UILabel *realsurveyTime;
@property (weak, nonatomic) IBOutlet UILabel *realsurveyPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *uploadStatus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelRightConstant;


@property (nonatomic, strong) RealSurveyEntity *realSurveyEntity;

@end
