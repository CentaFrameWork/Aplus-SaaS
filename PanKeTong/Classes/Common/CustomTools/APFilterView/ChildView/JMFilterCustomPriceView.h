//
//  JMFilterCustomPriceView.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Extension.h"

@interface JMFilterCustomPriceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *minPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *maxPriceTextField;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end
