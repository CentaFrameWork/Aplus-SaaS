//
//  CallRecordTableViewCell.h
//  PanKeTong
//
//  Created by 王雅琦 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol CallRecordCellDelegate <NSObject>
- (void)changeCellHeight:(NSIndexPath *)indexRow andHasFollowUp:(BOOL)hasFollowUp;
- (void)clickPlayButtonIndexPath:(NSIndexPath *)indexPath andStuts:(NSString *)stuts;
@end

@interface CallRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;    // 联系人
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        // 时间
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;    // 操作人
@property (weak, nonatomic) IBOutlet UILabel *operatorDepartmentLabel;  // 操作部门
@property (weak, nonatomic) IBOutlet UILabel *relatedFollowUp;  // 相关跟进
@property (weak, nonatomic) IBOutlet UIImageView *listenImage;

@property (weak, nonatomic) IBOutlet UIButton *openButton; //点击展开

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followUpHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLayoutHeight;

@property (strong, nonatomic) NSIndexPath *indexRow;

@property (assign, nonatomic) id<CallRecordCellDelegate>delegate;

@property (nonatomic, copy) NSString *callRecordStuts; // 播放录音状态


@end
