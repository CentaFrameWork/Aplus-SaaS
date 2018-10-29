//
//  ApplyTransferEstInputItemCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textFieldEndEditBlock)(NSString *textFieldTextStr);

@interface ApplyTransferEstInputItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *rightInputTextfield;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

- (void)setupCellWithLeftLabelTitle:(NSString *)title rightTextFieldPlaceholderTitle:(NSString *)placeholderString;

- (void)textFieldEndEditBlock:(textFieldEndEditBlock)block;

@end
