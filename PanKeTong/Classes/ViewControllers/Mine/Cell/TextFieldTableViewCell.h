//
//  TextFieldTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFrom;
@property (weak, nonatomic) IBOutlet UITextField *textTo;

@end
