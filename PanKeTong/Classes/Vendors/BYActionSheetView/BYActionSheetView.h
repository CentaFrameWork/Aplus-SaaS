//
//  BYActionSheetView.h
//  LianDong
//
//  Created by 阎超杰 on 14-2-28.
//  Copyright (c) 2014年 Grant Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BYActionSheetViewDelegate;
@interface BYActionSheetView : UIView{

    
}

- (id)initWithTitle:(NSString *)title delegate:(id<BYActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle  otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithCustomeView:(UIView *)aCustomeView
                 delegate:(id<BYActionSheetViewDelegate>)delegate
        cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (void)initialValue:(NSString *)initialVale;

@property (nonatomic, weak) id <BYActionSheetViewDelegate> delegate;
@property (nonatomic, strong) UIButton *TitleBtn;

- (void)show;

@end

@protocol BYActionSheetViewDelegate <NSObject>

@optional

- (void)actionSheetView:(BYActionSheetView *)alertView
   clickedButtonAtIndex:(NSInteger)buttonIndex
         andButtonTitle:(NSString *)buttonTitle;

@end
