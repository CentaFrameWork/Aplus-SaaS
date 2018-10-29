//
//  ContactListContactInformationCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ContactListContactInformationCell.h"

@implementation ContactListContactInformationCell

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
     @property (nonatomic, strong)UIImageView *lineImage;        // 分割线图片
     @property (nonatomic, strong)UILabel *iphoneLabel;          // 手机号
     @property (nonatomic, strong)UILabel *landlineLabel;        // 座机号
     */
    
    // 分割线图片
    _lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH-24*NewRatio, 12*NewRatio)];
    _lineImage.image = [UIImage imageNamed:@"背景分割_虚线"];
    [self.contentView addSubview:_lineImage];
    
    // 手机
    UILabel *labelshouji = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 21*NewRatio, 40*NewRatio, 14*NewRatio)];
    labelshouji.textColor = YCTextColorGray;
    labelshouji.font = [UIFont systemFontOfSize:14*NewRatio];
    labelshouji.text = @"手机";
    [self.contentView addSubview:labelshouji];
    
    // 手机号
    _iphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*NewRatio, 0, 250*NewRatio, 14*NewRatio)];
    _iphoneLabel.textColor = YCTextColorBlack;
    _iphoneLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [labelshouji addSubview:_iphoneLabel];
    
    // 座机
    UILabel *labelzuoji = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(labelshouji.frame)+14*NewRatio, 40*NewRatio, 14*NewRatio)];
    labelzuoji.textColor = YCTextColorGray;
    labelzuoji.font = [UIFont systemFontOfSize:14*NewRatio];
    labelzuoji.text = @"座机";
    [self.contentView addSubview:labelzuoji];
    // 座机号
    _landlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*NewRatio, 0, 250*NewRatio, 14*NewRatio)];
    _landlineLabel.textColor = YCTextColorBlack;
    _landlineLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [labelzuoji addSubview:_landlineLabel];
}

- (void)setModel:(WJContactListModel *)model {
    
    // 手机
    if (model.Mobile != nil) {
        if (model.Mobile.length >= 10) {
            NSMutableString *telphone1Mu = [NSMutableString stringWithFormat:@"%@",model.Mobile];
            [telphone1Mu replaceCharactersInRange:(NSRange){3,4} withString:@"****"];
            _iphoneLabel.text = telphone1Mu;
        }else {
            _iphoneLabel.text = model.Mobile;
        }
    }
    
    
    // 座机
    if (model.telphone2.length == 8 || model.telphone2.length == 7) {
        NSMutableString *telphone1Mu = [NSMutableString stringWithFormat:@"%@",model.telphone2];
        [telphone1Mu replaceCharactersInRange:(NSRange){2,4} withString:@"****"];
        if (model.telphone3.length != 0) {
            _landlineLabel.text = [NSString stringWithFormat:@"%@-%@-%@",model.telphone1,telphone1Mu,model.telphone3];
        }else {
            _landlineLabel.text = [NSString stringWithFormat:@"%@-%@",model.telphone1,telphone1Mu];
        }
        
    }else {
        if (model.telphone2.length != 0) {
            if (model.telphone3.length != 0) {
                _landlineLabel.text = [NSString stringWithFormat:@"%@-%@-%@",model.telphone1,model.telphone2,model.telphone3];
            }else {
                _landlineLabel.text = [NSString stringWithFormat:@"%@-%@",model.telphone1,model.telphone2];
            }
        }else {
            _landlineLabel.text = @"";
        }
    }
    
}

@end
