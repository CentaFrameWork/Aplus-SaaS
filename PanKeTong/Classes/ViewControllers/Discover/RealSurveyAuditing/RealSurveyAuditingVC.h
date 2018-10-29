//
//  RealSurveyAuditingVC.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

@interface RealSurveyAuditingVC : BaseViewController

@property (nonatomic, copy) NSString *titleName;
@property (weak, nonatomic) IBOutlet UILabel *auditStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *meunImageView;

@end
