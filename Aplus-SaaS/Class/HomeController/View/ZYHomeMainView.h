//
//  ZYShareCell.m
//  PanKeTong
//
//  Created by Admin on 2018/9/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYHomeControllerPresent.h"

@protocol ZYLoginViewDelegate <NSObject>

- (void)shareBtnClick;

@end
@interface ZYHomeMainView : UIView

@property (nonatomic,weak) id<ZYLoginViewDelegate>delegate;
@property (nonatomic,strong)ZYHomeControllerPresent *vmodel;


@end
