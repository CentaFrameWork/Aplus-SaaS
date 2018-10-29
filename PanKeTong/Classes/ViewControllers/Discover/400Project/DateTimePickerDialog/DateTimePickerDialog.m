//
//  DateTimePickerDialog.m
//  DatePicker
//
//  Created by 燕文强 on 16/1/21.
//  Copyright (c) 2016年 mspsys087. All rights reserved.
//

#import "DateTimePickerDialog.h"

@implementation DateTimePickerDialog



+ (DateTimePickerDialog *)initWithParentView:(UIView *)parentView
                                 andDelegate:(id<DateTimeSelected>)delegate
                                      andTag:(NSString *)tag;
{
    DateTimePickerDialog *dateTimeDialog = [[DateTimePickerDialog alloc]init];
    dateTimeDialog.parentView = parentView;
    dateTimeDialog.delegate = delegate;
    dateTimeDialog.tag = tag;
    dateTimeDialog.datePickerMode = -1;
    return dateTimeDialog;
}

- (void)showWithDate:(NSDate *)date andTipTitle:(NSString *)tipTitle
{
    NSDate *minDate = [[NSDate alloc] initWithTimeInterval:-60*60*24*365*2 sinceDate:[NSDate date]];
    
    self.datePickerView = [[UIDatePicker alloc] init];
    if (self.datePickerMode >= 0) {
        self.datePickerView.datePickerMode = self.datePickerMode;
    }else{
        self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    }
    [self.datePickerView addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    self.datePickerView.minimumDate = minDate;
    if(date)
    {
        self.datePickerView.date = date;
    }
    [self.datePickerView sizeToFit];
    [self.datePickerView setBounds:CGRectMake(0, 0, self.parentView.frame.size.width, self.parentView.frame.size.height)];
    
	
    self.viewBack = [[UIView alloc] initWithFrame:self.parentView.frame];
    [self.viewBack setBackgroundColor:[UIColor clearColor]];
    [self.parentView addSubview:self.viewBack];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.delegate = self;
    recognizer.cancelsTouchesInView = NO;
    [self.viewBack addGestureRecognizer:recognizer];
    
    
    UIToolbar *controlToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.parentView.frame.size.width, 44)];
    
    [controlToolbar sizeToFit];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [infoButton setTitleColor:YCButtonColorGreen forState:UIControlStateNormal];
    [infoButton setFrame:CGRectMake(0, 0, 70, 44)];
    [infoButton setTitle:@"确定" forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(donedateSet:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UIBarButtonItem *Choosedate = [[UIBarButtonItem alloc] initWithTitle:tipTitle
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil action:nil];
    
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    
    UIButton* infoButtonCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [infoButtonCancel setFrame:CGRectMake(0, 0, 70, 44)];
    [infoButtonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [infoButtonCancel setTitleColor:YCButtonColorGreen forState:UIControlStateNormal];
    [infoButtonCancel addTarget:self action:@selector(cancelDateSet:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:infoButtonCancel];
    
    [controlToolbar setItems:[NSArray arrayWithObjects:cancelButton, spacer1 , Choosedate ,spacer2 ,setButton, nil] animated:NO];
    
    
    [self.datePickerView setFrame:CGRectMake(0, 40, self.parentView.frame.size.width,300)];
    
    
    if (!self.pickerView) {
        self.pickerView = [[UIView alloc] initWithFrame:self.datePickerView.frame];
    } else {
        [self.pickerView setHidden:NO];
    }
    
    
    [self.pickerView setFrame:CGRectMake(0,
                                         self.parentView.frame.size.height,
                                         self.parentView.frame.size.width,
                                         320)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView addSubview:controlToolbar];
    [self.pickerView addSubview:self.datePickerView];
    [self.datePickerView setHidden:NO];
    
    [self.viewBack addSubview:self.pickerView];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.pickerView setFrame:CGRectMake(0,
                                                              self.parentView.frame.size.height - self.pickerView.frame.size.height,
                                                              self.parentView.frame.size.width,
                                                              320)];
                     }
                     completion:nil];

}


- (void)dateChanged
{
    if([self.delegate respondsToSelector:@selector(selectedResultWithSender:andDate:)])
    {
        [self.delegate selectedResultWithSender:self andDate:self.datePickerView.date];
    }
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    [self.viewBack removeGestureRecognizer:sender];
    [self dismissDateSet];
    
    if([self.delegate respondsToSelector:@selector(clickCancle)])
    {
        [self.delegate clickCancle];
    }
}

- (void)dismissDateSet
{
    [UIView animateWithDuration:0.3 animations:^{
        [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x,
                                         self.parentView.frame.size.height,
                                         _pickerView.frame.size.width,
                                         _pickerView.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.viewBack removeFromSuperview];
    }];
    
}

#pragma mark - <确定>
- (void)donedateSet:(UIButton *)btn{
    [self dismissDateSet];

    if([self.delegate respondsToSelector:@selector(clickDone)])
    {
        [self.delegate clickDone];
    }

}

#pragma mark - <取消>
- (void)cancelDateSet:(UIButton *)btn
{
    [self dismissDateSet];

    if([self.delegate respondsToSelector:@selector(clickCancle)])
    {
        [self.delegate clickCancle];
    }
}


+ (NSDate *)ConversionTimeZone:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger selectInterval = [zone secondsFromGMTForDate:date];
    
    date = [date  dateByAddingTimeInterval: selectInterval];//选择时间
    
    return date;
}

@end
