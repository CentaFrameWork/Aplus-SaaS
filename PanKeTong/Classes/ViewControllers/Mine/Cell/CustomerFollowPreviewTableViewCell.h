//
//  CustomerFollowPreviewTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerFollowPreviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelForName;
@property (weak, nonatomic) IBOutlet UILabel *labelForFollowType;
@property (weak, nonatomic) IBOutlet UILabel *labelForFollowDate;
@property (weak, nonatomic) IBOutlet UILabel *messgeaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end
