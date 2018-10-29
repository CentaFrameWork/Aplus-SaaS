//
//  ApplyTransferEstSelectItemCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyTransferEstSelectItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightValueLabel;

- (void)setupLeftTitleWithString:(NSString *)title
			   rightLabelString:(NSString *)rightString;


- (void)rightLabelWithString:(NSString *)str;

@end
