//
//  SelectPickerView.h
//  PanKeTong
//
//  Created by zhwang on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPickerView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
