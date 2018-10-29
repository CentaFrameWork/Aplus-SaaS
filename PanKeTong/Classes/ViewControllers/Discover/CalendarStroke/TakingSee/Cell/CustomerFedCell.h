//
//  CustomerFedCell.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/2.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/iflyMSC.h>


@protocol CustomerFedCellDelegate <NSObject>

@optional

- (void)IFlyRecognizerViewDidEndEditing:(UITextView *)textView;

@end
/// 客户反馈
@interface CustomerFedCell : UITableViewCell<IFlyRecognizerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CustomTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *starView;
@property (nonatomic,assign) id <CustomerFedCellDelegate>delegate;

@end
