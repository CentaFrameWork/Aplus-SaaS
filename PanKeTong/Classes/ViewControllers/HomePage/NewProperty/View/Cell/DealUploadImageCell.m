//
//  DealUploadImageCell.m
//  PanKeTong
//
//  Created by Admin on 2018/3/26.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealUploadImageCell.h"
@interface DealUploadImageCell ()
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UILabel *textLabel;

//@property (nonatomic,strong)UIImageView* imageView;
@end

@implementation DealUploadImageCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setLayerCornerRadius:5];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
      
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 40, 0, 40, 40)];
        [_deleteBtn setImage:[UIImage imageNamed:@"uploadDelete"] forState:UIControlStateNormal];
        
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        
      
        [self addSubview:self.shadowView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height*0.5 -10, self.width, 20)];
        _textLabel.textAlignment = 1;
        _textLabel.textColor = [UIColor greenColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)deleteBtnClik:(UIButton *)btn {
   
    
    if ([self.delegate respondsToSelector:@selector(didClickBtn:)]) {
        
        [self.delegate didClickBtn:btn];
    }
}
- (void)setProgress:(CGFloat)progress {
    
    _shadowView.hidden = NO;
    _shadowView.y = (1-progress) * self.height;
    
   _textLabel.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
    
}

- (UIView *)shadowView {
    
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, self.height)];
        _shadowView.hidden = YES;
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
    }
    return _shadowView;
}

@end
