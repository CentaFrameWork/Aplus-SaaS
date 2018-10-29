//
//  ModifyPwdTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ModifyPwdTableViewCell.h"

@implementation ModifyPwdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelForValue.secureTextEntry = YES;
    _labelForValue.delegate = self;
    [_labelForValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > PwdInputLength) {
        return NO;
    }
    
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > PwdInputLength) {
        textField.text = [textField.text substringToIndex:PwdInputLength];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}



@end
