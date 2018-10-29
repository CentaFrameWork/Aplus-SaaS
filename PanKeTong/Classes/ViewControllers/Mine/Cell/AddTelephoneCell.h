//
//  LandlineTelephoneCellTableViewCell.h
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/3.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTelephoneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *areaCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *extensionTextField;

@end
