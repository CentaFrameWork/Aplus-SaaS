//
//  NewContactNamePhoneCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

// 名字 手机
#import "NewContactNamePhoneCell.h"

@implementation NewContactNamePhoneCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    /*
     @property (nonatomic, strong)UILabel *nameLabel;            // 姓名label
     @property (nonatomic, strong)UITextField *nameTextField;    // 姓名TextField
     
     */
    // 姓名label
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, 40*NewRatio, 48*NewRatio)];
    _nameLabel.textColor = YCTextColorGray;
    _nameLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [self.contentView addSubview:_nameLabel];
    
    // 姓名TextField
    _nameTextField = [[NewContactNameTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 6*NewRatio, 310*NewRatio, 36*NewRatio)];
    _nameTextField.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    _nameTextField.layer.cornerRadius = 5*NewRatio;
    _nameTextField.clipsToBounds = YES;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    _nameTextField.placeholder = @"请输入";
    _nameTextField.font = [UIFont systemFontOfSize:14*NewRatio];
    _nameTextField.textColor = YCTextColorBlack;
    [self.contentView addSubview:_nameTextField];
    
}

- (void)setModel:(NewContactModel *)model {
    _nameTextField.indexPath = _indexPath;
    if (_indexPath.row == 1) {
        _nameLabel.text = @"姓名";
        _nameTextField.text = model.name;
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else if (_indexPath.row == 5) {
        _nameLabel.text = @"手机";
        _nameTextField.keyboardType = UIKeyboardTypeNumberPad;
        if (_isEditor && model.mobilePhone.length>0 && !_editPhoneNumber) {
            NSMutableString *muString = [[NSMutableString alloc] initWithFormat:@"%@",model.mobilePhone];
            [muString replaceCharactersInRange:(NSRange){3,4} withString:@"****"];
            _nameTextField.text = muString;
        }else {
            _nameTextField.text = model.mobilePhone;
        }
        
    }
}
@end
