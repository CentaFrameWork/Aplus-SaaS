//
//  TCPickView.m
//  TCPickView
//
//  Created by TailC on 15/11/7.
//  Copyright © 2015年 TailC. All rights reserved.
//

#import "TCPickView.h"

@interface TCPickView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong,nonatomic) NSMutableArray *resultArr;        //回传数组

@property (strong,nonatomic) NSArray *arr;        //Array 对象

@property (copy,nonatomic) PickViewResultBlock block;

@property (nonatomic,readwrite,assign) CGFloat selectedRow;        //已选择的Row
@property (nonatomic,readwrite,assign) CGFloat selectedComponent;        //已选择的Component


@end

@implementation TCPickView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        /** 初始化view  */
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor=[UIColor clearColor];
        //        self.alpha=0.3;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self remove];
}

- (void)showPickViewWithResultBlock:(PickViewResultBlock)block{
    [self show];
    
    if (self.selectedRow && self.selectedComponent) {
        [self.pickView selectRow:self.selectedRow inComponent:self.selectedComponent animated:NO];
    }
    self.block = block;
}

#pragma mark - TCDatePicker

- (UIView *)initDatePickViewWithDate:(NSDate *)date mode:(UIDatePickerMode)mode{
    
    self = [super init];
    
    if (self) {
        CGFloat datePickHeight = APP_SCREEN_HEIGHT *0.4;
        
        UIDatePicker * datapick = [[UIDatePicker alloc]init];
        datapick.frame = CGRectMake(0, APP_SCREEN_HEIGHT - datePickHeight + 64 + 10, APP_SCREEN_WIDTH, datePickHeight);
        
        _datePick = datapick;
        
        if (MODEL_VERSION > 9.0) {
            
            _datePick.frame = CGRectMake(0, APP_SCREEN_HEIGHT * 0.6, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT * 0.4);
        }
        
        _datePick.datePickerMode=mode;
        _datePick.locale=[NSLocale currentLocale];
        
        [self setupToolBarWithHeight:_datePick.frame.size.height];
        
        _datePick.date = date?date:[NSDate date];
        _datePick.backgroundColor=[UIColor whiteColor];
        [self insertSubview:_datePick atIndex:1];
        
        [self show];
    }
    
    return self;
}


#pragma mark - init

- (UIView *)initPickViewWithArray:(NSArray *)arr{
    
    self=[super init];
    
    if (self) {
        
        //初始化_result数组
        _resultArr = [[NSMutableArray alloc]initWithCapacity:arr.count];
        
        for (int i=0; i < arr.count; i++) {
            [_resultArr addObject:arr[i][0]];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            _pickView=[[UIPickerView alloc]initWithFrame:
                       CGRectMake(0,
                                  [UIScreen mainScreen].bounds.size.height*0.6,
                                  [UIScreen mainScreen].bounds.size.width,
                                  [UIScreen mainScreen].bounds.size.height*0.4
                                  )
                       ];
        }else{
            //statusBar高度获取
            CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
            _pickView=[[UIPickerView alloc]initWithFrame:
                       CGRectMake(0,
                                  [UIScreen mainScreen].bounds.size.height*0.6+statusBarHeight,
                                  [UIScreen mainScreen].bounds.size.width,
                                  [UIScreen mainScreen].bounds.size.height*0.4
                                  )
                       ];
        }
        
        [self setupToolBarWithHeight:_pickView.frame.size.height];
        
        _pickView.delegate=self;
        _pickView.dataSource=self;
        _pickView.backgroundColor=[UIColor whiteColor];
        _arr=arr;
        [self addSubview:_pickView];
        
        //默认选中每一行的第一列
        for (int i=0; i<arr.count; i++) {
            [self pickerView:_pickView didSelectRow:0 inComponent:i];
        }
        
    }
    
    return self;
}

#pragma mark PickView Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _arr.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //取出_arr中的数组
    NSArray *rowArr=_arr[component];
    
    return rowArr.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //取出_arr中的数组
    NSArray *rowArr=_arr[component];
    //取出rowArr中的数据
    return rowArr[row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectedRow = row;
    self.selectedComponent = component;
    //绑定_result数组
    [_resultArr replaceObjectAtIndex:component withObject:_arr[component][row]];
}



#pragma mark -Private Methods
/** 初始化toolBar  */
-(void)setupToolBarWithHeight:(CGFloat)height{
    
    UIView * funcView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePick.top - 40, APP_SCREEN_WIDTH, 40)];
    
    funcView.backgroundColor = YCTextBGColor;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, funcView.frame.size.width, 1)];
    
    lineView.backgroundColor = YCOtherColorDivider;
    
    [funcView addSubview:lineView];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancleBtn.frame = CGRectMake(12, 0, 80, 40);
    
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancleBtn setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    [funcView addSubview:cancleBtn];
    
    UIButton * ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    ensureBtn.frame = CGRectMake(APP_SCREEN_WIDTH - 80 - 12, 0, 80, 40);
    
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [ensureBtn setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
    
    ensureBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    [ensureBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    [funcView addSubview:ensureBtn];
    
    [self addSubview:funcView];
    
}


/** toolBar 确定 button  */
-(void)done{
    
    if (_datePick) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:YearToMinFormat];
        NSString *dateStr = [dateFormatter stringFromDate:_datePick.date];
        if (self.block) {
            self.block(dateStr);
        }
    }else{
        
        if (self.block) {
            self.block(_resultArr.copy);
        }
    }
    
    
    [self remove];
    
}

/** toolBar 取消 button  */
-(void)remove{
    
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
        showLoading(nil);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        hiddenLoading();
    }];
    
    if ([_myDelegate respondsToSelector:@selector(pickViewRemove)]) {
        [_myDelegate performSelector:@selector(pickViewRemove)];
    }
    
    
}

- (void)show{
    self.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
    
    //    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[[UIApplication sharedApplication] delegate].window addSubview:self];
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformIdentity;
        showLoading(nil);
    } completion:^(BOOL finished) {
        hiddenLoading();
    }];
}


@end

