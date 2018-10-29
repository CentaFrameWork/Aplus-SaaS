//
//  ProgressPie.m
//  CustomProgress
//
//  Created by 燕文强 on 17/3/14.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "UIProgressPie.h"

#define PI 3.14159265358979323846

@implementation UIProgressPie
{
    float _centerX;
    float _centerY;
    float _radius;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YCOtherColorBorder;
        [self setLayerCornerRadius:frame.size.width*0.5];
        self.startAngle = 0;
        self.bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.borderColor = [UIColor clearColor];
        self.circleColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.circleColor = [UIColor redColor];
        self.progressColor =YCThemeColorGreen;
        self.progressTextColor = YCTextColorAuxiliary;
        
        self.style = UIProgressPieStyleStroke;
        self.strokeWidth = 8;
        self.padding = 5;
        [self setValue:@"100" forKeyPath:@"fullProgress"];
    }
    return self;
}

+ (id)initWithStartAngle:(float)startAngle
              andBgColor:(UIColor *)bgColor
          andBorderColor:(UIColor *)borderColor
          andCircleColor:(UIColor *)circleColor
        andProgressColor:(UIColor *)progressColor
{
    UIProgressPie *progressPie = [[UIProgressPie alloc]init];
    
    progressPie.startAngle = startAngle;
    progressPie.bgColor = bgColor;
    progressPie.borderColor = borderColor;
    progressPie.circleColor = circleColor;
    progressPie.progressColor = progressColor;
    
    return progressPie;
}


- (void)changeProgress:(int)progress
{
    self.progress = progress;
    [self setNeedsDisplay];
}

- (void)measure
{
    _centerX = self.frame.size.width / 2;
    _centerY = self.frame.size.height / 2;
    
    _radius = _centerY;
    if(_centerY > _centerX){
        _radius = _centerX;
    }
    
    _radius = _radius - self.padding;
}

- (void)drawRect:(CGRect)rect
{
    [self measure];
    
    // 获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线条样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
    
    // 计算结束角度
    float curAngle = 0;
    if(self.fullProgress == self.progress){
        curAngle = 360;
        if(self.delegate){
            [self.delegate finished];
        }
    }else{
        float persent = self.progress / self.fullProgress;
        curAngle = 360 * persent;
    }
    float endAngle = self.startAngle + curAngle;
    
//    // 矩形背景色
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
//    CGContextSetStrokeColorWithColor(context, self.bgColor.CGColor);
//    CGContextFillRect(context,CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    
    if(self.style == UIProgressPieStyleFill){
        
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextSetFillColorWithColor(context, self.borderColor.CGColor);
        CGContextSetLineWidth(context, 3.0);//线的宽度
        CGContextAddArc(context, _centerX, _centerY, _radius, 0, 2*PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    // 背景圆
//    CGContextSetFillColorWithColor(context, self.circleColor.CGColor);
//    CGContextSetLineWidth(context, self.strokeWidth);
//    CGContextAddArc(context, _centerX, _centerY, _radius, 0, 2*PI, 0);
//    CGContextDrawPath(context, kCGPathStroke);
//
//
    
    // 画扇形进度
//    CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
//
    // 以10为半径围绕圆心画指定角度扇形
//    CGContextMoveToPoint(context, _centerX, _centerY);
  
    
    
    if(self.style == UIProgressPieStyleStroke){
        
//        CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
//        CGContextSetLineWidth(context, 0);
//        CGContextAddArc(context, _centerX, _centerY, _radius, 0, 2*PI, 0);
//        CGContextDrawPath(context, kCGPathFillStroke);
//
        
        //进度圆
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextAddArc(context, _centerX, _centerY, _radius-self.strokeWidth+10,  self.startAngle * PI / 180, endAngle * PI / 180, 0);
        
        CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
        CGContextDrawPath(context, kCGPathStroke);
        
        
        
        
        
        
        
        
        
        
        
        NSString *percentStr = [NSString stringWithFormat:@"%d％",self.progress];
        
        float newRadius = _radius - self.strokeWidth;
        CGRect rect1 = CGRectMake(_centerX - newRadius, _centerY - newRadius, newRadius*2, newRadius*2);
        
        //段落格式
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        
        //字体
        UIFont  *font = [UIFont boldSystemFontOfSize:20.0];
        //构建属性集合
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:_progressTextColor};
        
        //获得size
        CGSize strSize = [percentStr sizeWithAttributes:attributes];
        CGFloat marginTop = (rect1.size.height - strSize.height)/2;
        //垂直居中要自己计算
        CGRect r = CGRectMake(rect1.origin.x, rect1.origin.y + marginTop,rect1.size.width, strSize.height);
        [percentStr drawInRect:r withAttributes:attributes];
    }
    
    
    
    CGContextStrokePath(context);
}

@end
