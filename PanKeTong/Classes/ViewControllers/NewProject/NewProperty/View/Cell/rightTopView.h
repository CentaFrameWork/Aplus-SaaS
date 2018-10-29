//
//  rightTopView.h
//  PanKeTong
//
//  Created by Admin on 2018/3/23.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rightTopView : UIView
@property (nonatomic,copy) void(^didSelect)(NSNumber* number);
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray*)arr;
@end
