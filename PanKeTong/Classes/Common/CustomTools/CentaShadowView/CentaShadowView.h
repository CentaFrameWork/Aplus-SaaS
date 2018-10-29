//
//  CentaShadowView.h
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/2.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDelegate <NSObject>
@optional
- (void)tapAction;
@end

@interface CentaShadowView : UIView

@property (nonatomic, weak) id <TapDelegate> delegate;

@end
