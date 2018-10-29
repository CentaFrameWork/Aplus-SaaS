//
//  JMScanJumpOtherController.m
//  PanKeTong
//
//  Created by Admin on 2018/6/20.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMScanJumpOtherController.h"

@interface JMScanJumpOtherController ()

@property (nonatomic,copy) NSString *string;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, assign)CGFloat label2Y;

@end

@implementation JMScanJumpOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNav];
    [self.view addSubview:self.baseView];
   
}

- (UIView *)baseView {
    
    if (!_baseView) {
        
        
        UILabel*(^Label)(CGRect,NSString*,CGFloat,int) = ^(CGRect rect , NSString*title,CGFloat titleSize,int number){
            
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.textAlignment = 1;
            label.text = title;
            label.font = [UIFont fontWithName:titleSize>15? @"Helvetica-Bold":@"Helvetica" size:titleSize];;
            label.textColor = UICOLOR_RGB_Alpha(number,1.0);
            return label;
        };
        
       
        _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
        
       
    
        UILabel* label1 = Label(CGRectMake(0, 90, APP_SCREEN_WIDTH, 44),@"已扫描到以下内容",24,0x333333);
        [_baseView addSubview:label1];
        
        
        
        _label2Y = label1.bottom+24;
        [_baseView addSubview:self.textView];
        
        
        
        NSString *titleString = [NSString stringWithFormat:@"%@",@"扫描所得内容并非原萃提供,请谨慎使用\n如需使用,可通过复制操作获取内容"];
        UILabel* labe3 = Label(CGRectMake(0, self.textView.bottom, APP_SCREEN_WIDTH, 88),titleString,14,0x999999);
        labe3.numberOfLines = 2;
        [_baseView addSubview:labe3];
        
        
    }
    return _baseView;
}


- (instancetype)initWithUrlString:(NSString *)string {
    
    if (self = [super init]) {
        
        _string = string;
    }
    return self;
}
- (void)setNav {
    
    [self setNavTitle:@"扫码提示"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    [self.navigationController.navigationBar setShadowImage:nil];
}



- (UITextView *)textView {
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(12, _label2Y, APP_SCREEN_WIDTH-24, 0)];
        
        NSMutableParagraphStyle *ornamentParagraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        ornamentParagraph.alignment = NSTextAlignmentCenter;
        ornamentParagraph.lineSpacing = 2;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName: ornamentParagraph, NSForegroundColorAttributeName: UICOLOR_RGB_Alpha(0x333333,1.0)};
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_string attributes: attributes];
      
        
        _textView.attributedText = content;
        _textView.backgroundColor = rgba(250, 250, 255, 1);
        _textView.layer.borderColor = rgba(242, 243, 249, 1).CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.frame = CGRectMake(12, _label2Y, APP_SCREEN_WIDTH-24, _textView.contentSize.height>50.0?_textView.contentSize.height:50.0);
        
        if (50-_textView.contentSize.height>0)_textView.contentInset = UIEdgeInsetsMake((50-_textView.contentSize.height) * 0.5, 0, 0, 0);
        
        _textView.editable = NO;
        
    
    }
    return _textView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
}

@end
