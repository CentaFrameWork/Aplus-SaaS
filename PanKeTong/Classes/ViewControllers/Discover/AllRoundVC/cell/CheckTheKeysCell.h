//
//  CheckTheKeysCell.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTheKeysCell : UITableViewCell

@property (nonatomic, strong)UIImageView *imageview;    // 图片
@property (nonatomic, strong)UILabel *labelName;        // 钥匙情况说明
@property (nonatomic, strong)UILabel *label;            // 钥匙状态
@property (nonatomic, strong)UIView *lineView;  // 分割线

@end
