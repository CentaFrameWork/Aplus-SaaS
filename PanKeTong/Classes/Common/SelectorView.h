//
//  SelectorView.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/4/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectorView : UIView

@property (nonatomic, strong)NSString *titStr;                      // 标题数据
@property (nonatomic, strong)NSArray *dataArray;                    // 列表数据

@property (nonatomic, copy) void(^theOption)(NSInteger optionValue);     // 删除视图回调

- (void)setSelectIndex:(NSInteger)index;

@end

