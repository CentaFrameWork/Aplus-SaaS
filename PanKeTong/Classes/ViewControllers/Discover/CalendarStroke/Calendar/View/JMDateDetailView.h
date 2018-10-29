//
//  JMDateDetailView.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/18.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMDateDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UIButton *todayBtn;

@property (nonatomic,strong) NSDate *currentDate;

@end
