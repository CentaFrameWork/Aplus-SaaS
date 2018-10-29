//
//  NoteTableViewCell.h
//  PanKeTong
//
//  Copyright © 2018年 连京帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContactModel.h"

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *rightInputTextView;
@property (weak, nonatomic) IBOutlet UIButton *voiceInputBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLimit;
@property (weak, nonatomic) IBOutlet UIImageView *imageYY;
@property (weak, nonatomic) IBOutlet UILabel *labelStr;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NewContactModel *model;

@end
