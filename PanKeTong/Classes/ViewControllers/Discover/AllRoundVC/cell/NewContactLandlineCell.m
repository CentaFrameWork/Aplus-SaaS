//
//  NewContactLandlineCell.m
//  
//
//  Created by 连京帅 on 2018/3/8.
//

// 座机cell
#import "NewContactLandlineCell.h"

@implementation NewContactLandlineCell

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
     @property (nonatomic, strong)UILabel *landlineLabel;
     @property (nonatomic, strong)UITextField *areaCodeTextField;    // 区号
     @property (nonatomic, strong)UITextField *phoneTextField;       // 电话
     @property (nonatomic, strong)UITextField *extensionTextField;       // 分机
     */
    // 座机
    _landlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, 40*NewRatio, 48*NewRatio)];
    _landlineLabel.textColor = YCTextColorGray;
    _landlineLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    _landlineLabel.text = @"座机";
    [self.contentView addSubview:_landlineLabel];
    
    // 区号
    _areaCodeTextField = [[NewContactAreaCodeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_landlineLabel.frame), 6*NewRatio, 70*NewRatio, 36*NewRatio)];
    _areaCodeTextField.placeholder = @"区号";
    _areaCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _areaCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _areaCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    _areaCodeTextField.layer.cornerRadius = 5*NewRatio;
    _areaCodeTextField.clipsToBounds = YES;
    _areaCodeTextField.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    _areaCodeTextField.font = [UIFont systemFontOfSize:14*NewRatio];
    _areaCodeTextField.textColor = YCTextColorBlack;
    [self.contentView addSubview:_areaCodeTextField];
    // 电话
    _phoneTextField = [[NewContactPhoneTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_areaCodeTextField.frame)+12*NewRatio, 6*NewRatio, 120*NewRatio, 36*NewRatio)];
    _phoneTextField.placeholder = @"座机号";
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    _phoneTextField.layer.cornerRadius = 5*NewRatio;
    _phoneTextField.clipsToBounds = YES;
    _phoneTextField.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    _phoneTextField.font = [UIFont systemFontOfSize:14*NewRatio];
    _phoneTextField.textColor = YCTextColorBlack;
    [self.contentView addSubview:_phoneTextField];
    // 分机
    _extensionTextField = [[NewContactExtensionTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneTextField.frame)+12*NewRatio, 6*NewRatio, 96*NewRatio, 36*NewRatio)];
    _extensionTextField.placeholder = @"分机";
    _extensionTextField.keyboardType = UIKeyboardTypeNumberPad;
    _extensionTextField.leftViewMode = UITextFieldViewModeAlways;
    _extensionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    _extensionTextField.layer.cornerRadius = 5*NewRatio;
    _extensionTextField.clipsToBounds = YES;
    _extensionTextField.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    _extensionTextField.font = [UIFont systemFontOfSize:14*NewRatio];
    _extensionTextField.textColor = YCTextColorBlack;
    [self.contentView addSubview:_extensionTextField];
    
}

- (void)setModel:(NewContactModel *)model {
    _areaCodeTextField.indexPath = _indexPath;
    _phoneTextField.indexPath = _indexPath;
    _extensionTextField.indexPath = _indexPath;
    
    
    _areaCodeTextField.text = model.areaCode;
    _phoneTextField.text = model.phone;
    
    if (_isEditor && model.phone.length>0 && !_editLineNumber) {
        if (model.phone.length == 8 || model.phone.length == 7) {
            NSMutableString *muString = [[NSMutableString alloc] initWithFormat:@"%@",model.phone];
            [muString replaceCharactersInRange:(NSRange){2,4} withString:@"****"];
            _phoneTextField.text = muString;
        }else {
            _phoneTextField.text = model.phone;
        }
    }else {
        _phoneTextField.text = model.phone;
    }
    
    _extensionTextField.text = model.extension;
}

@end
