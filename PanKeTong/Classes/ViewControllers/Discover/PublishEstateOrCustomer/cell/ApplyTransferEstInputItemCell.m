//
//  ApplyTransferEstInputItemCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ApplyTransferEstInputItemCell.h"

#define MobileTextfieldTag  5000

@interface ApplyTransferEstInputItemCell ()<UITextFieldDelegate>

@property (copy,nonatomic) textFieldEndEditBlock block;

@end


@implementation ApplyTransferEstInputItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <setup>
- (void)setupCellWithLeftLabelTitle:(NSString *)title rightTextFieldPlaceholderTitle:(NSString *)placeholderString{
	NSMutableAttributedString *leftTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
	[leftTitleStr addAttribute:NSForegroundColorAttributeName
						 value:[UIColor redColor]
						 range:NSMakeRange(0, 1)];
	self.leftTitleLabel.attributedText = leftTitleStr;
	self.rightInputTextfield.placeholder = placeholderString;
	self.rightInputTextfield.delegate = self;
	self.rightInputTextfield.textAlignment = NSTextAlignmentRight;
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@"/u00a0"
                                                   withString:@" "];
    
	if (self.block) {
		self.block(text);
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    return YES;
    
    if (textField.tag == MobileTextfieldTag) {
        if (range.location < 11) {
            return YES;
        }else{
            return NO;
        }
    }
    
    /* 如果不是右对齐，直接返回YES，不做处理 */
    if (textField.textAlignment != NSTextAlignmentRight) {
        return YES;
    }
    
    
    if ([string isEqualToString:@"➋"]||[string isEqualToString:@"➌"]||[string isEqualToString:@"➍"]||[string isEqualToString:@"➎"]
        ||[string isEqualToString:@"➏"]||[string isEqualToString:@"➐"]||[string isEqualToString:@"➑"]||[string isEqualToString:@"➒"])
    {
        return YES;
    }
    
    /* 在右对齐的情况下*/
    // 如果string是@""，说明是删除字符（剪切删除操作），则直接返回YES，不做处理
    // 如果把这段删除，在删除字符时光标位置会出现错误
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    /* 在输入单个字符或者粘贴内容时做如下处理，已确定光标应该停留的正确位置，
     没有下段从字符中间插入或者粘贴光标位置会出错 */
    // 首先使用 non-breaking sspace 代替默认输入的@“ ”空格
    string = [string stringByReplacingOccurrencesOfString:@" "
                                               withString:@"\u00a0"];
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    
    
    //确定输入或者粘贴字符后光标位置
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *cursorLoc = [textField positionFromPosition:beginning
                                                         offset:range.location+string.length];
    // 选中文本起使位置和结束为止设置同一位置
    UITextRange *textRange = [textField textRangeFromPosition:cursorLoc
                                                   toPosition:cursorLoc];
    // 选中字符范围（由于textRange范围的起始结束位置一样所以并没有选中字符）
    [textField setSelectedTextRange:textRange];
    
    return NO;

	
}


#pragma mark - <public method>
- (void)textFieldEndEditBlock:(textFieldEndEditBlock)block{
	self.block = block;
}

@end
