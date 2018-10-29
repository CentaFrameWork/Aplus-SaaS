//
//  MultiSelectView.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/12/20.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectCell.h"

@protocol MultiSelectViewDelegate <NSObject>

- (void)cancelAction;
- (void)determineAction:(NSMutableArray *)array;
- (void)switchAction:(UISwitch *)swith;

@end


@interface MultiSelectView : UIView <UITableViewDataSource, UITableViewDelegate,MultiSelectCellDelegate>

@property(assign, nonatomic)id<MultiSelectViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andDataSourceArray:(NSArray *)array;



@end
