//
//  ModifyPwdTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPwdTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelForKey;
@property (weak, nonatomic) IBOutlet UITextField *labelForValue;

@end
