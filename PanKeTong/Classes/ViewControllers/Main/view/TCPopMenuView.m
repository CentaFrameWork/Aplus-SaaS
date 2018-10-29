//
//  TCPopMenuView.m
//  TCRaisedCenterTabBar_Demo
//
//  Created by TailC on 16/3/23.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import "TCPopMenuView.h"
#import "JCRBlurView.h"


@interface TCPopMenuView ()

@property (strong,nonatomic) JCRBlurView *blurView;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIView *realSurveyView;
@property (weak, nonatomic) IBOutlet UIView *soundRecordView;


@property (copy,nonatomic) ButtonActionsBlock block;

@end

@implementation TCPopMenuView

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		self= [[[NSBundle mainBundle] loadNibNamed:@"TCPopMenuView" owner:self options:nil] objectAtIndex:0];
		self.frame = frame;
		
		if (MODEL_VERSION < 8.0) {
			self.backgroundColor = [UIColor whiteColor];
		}
		
		self.addImageView.transform = CGAffineTransformMakeRotation(M_PI_4);
		
		[self setupBlurView];
		[self AddTapToView];
		
	}
	return self;
}


#pragma mark 动画
- (void)showViewAnimation
{
	
	self.realSurveyView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
	self.soundRecordView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
    self.transmitListView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
	
	[UIView animateWithDuration:0.5
						  delay:0
		 usingSpringWithDamping:0.7
		  initialSpringVelocity:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{

                             self.addImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                             self.realSurveyView.transform = CGAffineTransformIdentity;
                             self.soundRecordView.transform = CGAffineTransformIdentity;
                             self.transmitListView.transform = CGAffineTransformIdentity;
					 }
					 completion:^(BOOL finished) {
						 
					 }];
}

- (void)hiddenViewAnimation
{
	
	[UIView animateWithDuration:0.5
						  delay:0
		 usingSpringWithDamping:0.7
		  initialSpringVelocity:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.realSurveyView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
						 self.soundRecordView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
                         self.transmitListView.transform = CGAffineTransformMakeTranslation(0, APP_SCREEN_HEIGHT);
						 self.addImageView.transform = CGAffineTransformMakeRotation(M_PI_4);
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished) {
						 [self removeFromSuperview];
					 }];
	
}



#pragma mark Public Method
- (void)onCLickButtonsWithBlock:(ButtonActionsBlock)block
{
	self.block = block;
}


#pragma mark Private Method
// 中间功能button点击事件
- (void)onClickButton:(UIGestureRecognizer *)tap
{
	
	if (self.block) {
		self.block(tap.view.tag);
	}

}

- (void)setupBlurView
{
	
	self.blurView = [JCRBlurView new];
	[self.blurView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[self addSubview:self.blurView];
	[self sendSubviewToBack:self.blurView];
	
}

- (void)AddTapToView
{
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(touchBackgroundView:)];
	[self addGestureRecognizer:tap];
	
	UITapGestureRecognizer *realSurveyViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																						action:@selector(onClickButton:)];
	UITapGestureRecognizer *soundRecordViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																						 action:@selector(onClickButton:)];
    UITapGestureRecognizer *transmitListViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(onClickButton:)];
	[self.realSurveyView addGestureRecognizer:realSurveyViewTap];
	[self.soundRecordView addGestureRecognizer:soundRecordViewTap];
    [self.transmitListView addGestureRecognizer:transmitListViewTap];
}

- (void)touchBackgroundView:(UIGestureRecognizer *)tap
{
	
	[self hiddenViewAnimation];
	
}






@end
