//
//  CustomActionSheet.h
//  LZWCustomActionSheet
//
//  Created by hbh  on 14-9-26.
//  Copyright (c) 2014年 lizhiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol doneSelect <NSObject>

-(void)doneSelectItemMethod;

@optional
- (void)haveHidden;///视图消失后在具体页面的处理
-(void)doneSelectItemMethod:(NSIndexPath *)indexPath;
@end

@interface CustomActionSheet : UIView
{
    UIToolbar *toolBar;
}
-(id)initWithView:(UIView *)view AndHeight:(float)height;

-(void)showInView:(UIView *)view;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property(nonatomic,assign) id<doneSelect> doneDelegate;

@end
