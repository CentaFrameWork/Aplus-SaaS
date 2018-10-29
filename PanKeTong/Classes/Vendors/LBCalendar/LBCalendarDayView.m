//
//  LBCalendarDayView.m
//  Calendar module
//
//  Created by king on 1511-4-308.
//  Copyright © 2015年 luqinbin. All rights reserved.
//

#import "LBCalendarDayView.h"
#import "LBRectangularView.h"
#import "LBPointView.h"

#define ColorForImportant [self.calendarManager.calendarAppearance dayTextColor]

#define ColorForPoint [UIColor clearColor]

@interface LBCalendarDayView (){
    LBRectangularView *rectangularView;
    UILabel *solarLabel;//阳历
    UILabel *lunarLabel;//阴历
    LBPointView *pointView;

    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
    NSDate *lastSelectDate;
}
@end

static NSString *kLBCalendarDaySelected = @"kLBCalendarDaySelected";

@implementation LBCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }

    [self commonInit];


    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kLBCalendarDaySelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeSelectDate:) name:CHANGE_SELECT_DATE object:nil];

    isSelected = NO;
    self.isOtherMonth = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDate *event24Date = [endDate dateByAddingTimeInterval:8 * 60 * 60];
    NSDate *nowDate = [event24Date dateByAddingTimeInterval:-24 * 60 * 60];
    lastSelectDate = nowDate;

    //当前或选中
    {
        rectangularView = [LBRectangularView new];
        [self addSubview:rectangularView];
    }

    //阳历
    {
        solarLabel = [UILabel new];
        [self addSubview:solarLabel];
    }
    //阴历
    {
        lunarLabel = [UILabel new];
        [self addSubview:lunarLabel];
    }

    
    {
        pointView = [LBPointView new];
        [self addSubview:pointView];
        pointView.hidden =YES;
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    
}


- (void)configureConstraintsForSubviews
{
    solarLabel.frame = CGRectMake(0, 8, self.frame.size.width, 18);
    lunarLabel.frame = CGRectMake(0, solarLabel.bottom, self.frame.size.width, 14);
    
    CGFloat sizeRectangular = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeRectangular;
    
    sizeRectangular = sizeRectangular * self.calendarManager.calendarAppearance.dayRectangularRatio;
    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeRectangular = roundf(sizeRectangular);
    sizeDot = roundf(sizeDot);
    
    rectangularView.frame = CGRectMake(0, 0, sizeRectangular, sizeRectangular);
    rectangularView.center = CGPointMake(self.frame.size.width / 2.,solarLabel.bottom);
    rectangularView.layer.cornerRadius = sizeRectangular / 2;
    rectangularView.layer.masksToBounds = YES;

    pointView.frame = CGRectMake((self.width - 6) / 2, lunarLabel.bottom + 1, 6, 6);

}

- (void)setDate:(NSDate *)date
{
    if (_date != date) {
        _date = date;
        static NSDateFormatter *dateFormatter;
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
            [dateFormatter setDateFormat:@"dd"];
        }

        //阳历
        solarLabel.text = [dateFormatter stringFromDate:date];

        //农历或节假日
        if (date != nil) {
            NSString *solartext1 = [CalendarLogic getHolidays:date];//节假日或节气
            if (solartext1.length > 0) {
                lunarLabel.text = solartext1;
            }else{
                NSString *text = [CalendarLogic getChineseCalendarWithDate:date];//农历
                if ([text contains:@"初一"]) {
                    lunarLabel.text = [text substringToIndex:2];
                }else{
                    lunarLabel.text = [text substringFromIndex:2];
                }
            }
        }
        
        
        cacheIsToday = -1;
        cacheCurrentDateText = nil;
    }
}

- (void)setIsHoliday:(BOOL)isHoliday{
    if (_isHoliday != isHoliday) {
        _isHoliday = isHoliday;
        [self setSelected:isSelected animated:NO];
    }
}

- (void)didTouch:(UITapGestureRecognizer *)tap
{
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLBCalendarDaySelected object:self.date];

    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
    
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextMonth];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousMonth];
    }
    
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];

//    [self.calendarManager setCurrentDateSelected:dateSelected];


    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
            lastSelectDate = dateSelected;
        }
        else{
            if ([dateSelected isEqualToDate:lastSelectDate]) {
                //当前选择的时间跟上次时间相同
                [self setSelected:NO animated:YES];
                lastSelectDate = nil;
                [self.calendarManager setCurrentDateSelected:nil];

            }else{
                [self setSelected:YES animated:YES];
                lastSelectDate = dateSelected;

            }
        }
    }

    else if(isSelected){
        [self setSelected:NO animated:YES];
        lastSelectDate = nil;
        [self.calendarManager setCurrentDateSelected:nil];
    }

}

- (void)ChangeSelectDate:(NSNotification *)notifi{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDate *event24Date = [endDate dateByAddingTimeInterval:8 * 60 * 60];
    NSDate *nowDate = [event24Date dateByAddingTimeInterval:-24 * 60 * 60];

    lastSelectDate = nowDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    isSelected = selected;
    
    rectangularView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    if(selected){
        //被选中的某天
        if(!self.isOtherMonth){
            //当前月的
            rectangularView.color = [self.calendarManager.calendarAppearance dayRectangularColorSelected];
            solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            pointView.color = ColorForPoint;
        }
        else{
            //其他月的
            rectangularView.color = [self.calendarManager.calendarAppearance dayRectangularColorSelectedOtherMonth];
            solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
            lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
            pointView.color = ColorForPoint;

        }

        rectangularView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }

    else if([self isToday]){
        //是现在的天
        if(!self.isOtherMonth){
            //是当前月的
            rectangularView.color = [self.calendarManager.calendarAppearance dayRectangularColorToday];

            if (self.isWeekDay == YES) {
                solarLabel.textColor = ColorForImportant;
            }else{
                solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];

            }
            lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
            pointView.color = ColorForPoint;

        }
        else{
            //不是当前月的
            rectangularView.color = [self.calendarManager.calendarAppearance dayRectangularColorTodayOtherMonth];
            solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            pointView.color = ColorForPoint;

        }
    }
    else{
        //没被选中也不是现在的天
        if(!self.isOtherMonth){
            //是当前月的
            if (self.isWeekDay == YES) {
                solarLabel.textColor = ColorForImportant;
            }else{
                solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            }
            if (self.isHoliday) {
//                lunarLabel.textColor = ColorForImportant;
                lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            }else{
                lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            }

             pointView.color = ColorForPoint;

        }
        else{
            //不是当前月的
            solarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            lunarLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            pointView.color = ColorForPoint;

        }

        opacity = 0.;
    }

    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            rectangularView.layer.opacity = opacity;
            rectangularView.transform = tr;
        }];
    }
    else{
        rectangularView.layer.opacity = opacity;
        rectangularView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    pointView.hidden = ![self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:self.date];

    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];

    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    solarLabel.textAlignment = NSTextAlignmentCenter;
    solarLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    lunarLabel.textAlignment = NSTextAlignmentCenter;
    lunarLabel.font = [UIFont systemFontOfSize:8];
    
    [self configureConstraintsForSubviews];

    [self setSelected:isSelected animated:NO];
}

@end
