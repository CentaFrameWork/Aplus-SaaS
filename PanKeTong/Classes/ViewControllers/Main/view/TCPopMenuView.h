//
//  TCPopMenuView.h
//  TCRaisedCenterTabBar_Demo
//
//  Created by TailC on 16/3/23.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonActionsBlock)(NSInteger tag);

@interface TCPopMenuView : UIView

@property (weak, nonatomic) IBOutlet UIView *transmitListView;


- (void)showViewAnimation;
- (void)hiddenViewAnimation;


- (void)onCLickButtonsWithBlock:(ButtonActionsBlock) block;



@end
