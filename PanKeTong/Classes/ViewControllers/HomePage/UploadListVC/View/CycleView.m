//
//  CycleView.m
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//


#import "CycleView.h"

@interface CycleView()

@end

@implementation CycleView{
    CGFloat _width;
    CGPoint _center;  //设置圆心位置
    CGFloat _radius;  //设置半径
    CGFloat _startA;  //圆起点位置
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = self.frame.size.width;
        _center = CGPointMake(_width/2.0, _width/2.0);  //设置圆心位置
        _radius = _width/2.0 - 1;  //设置半径
        _startA =  - M_PI_2;  //圆起点位置
        [self.layer addSublayer:self.grayCyclelayer];

        [self addSubview:self.statusImageView];
    }
    return self;
}

    /// 更新上传状态
-(void)setUploadStatus:(UploadStatus)uploadStatus{
    _uploadStatus = uploadStatus;
    switch (_uploadStatus) {
            case UploadStatusWaiting:
        {
            _statusImageView.image = [UIImage imageNamed:@"pause"];
            [self.cyclelayer removeFromSuperlayer];

        }
            break;

        case UploadStatusPause:
        {
            _statusImageView.image = [UIImage imageNamed:@"upload"];
            [self.cyclelayer removeFromSuperlayer];
        }
            break;
        case UploadStatusUploading:
        {
            _statusImageView.image = [UIImage imageNamed:@"pause"];
            [self.layer addSublayer:self.cyclelayer];
        }
            break;
       
        default:
            break;
    }
}
    /// 更新上传进度
-(void)setProgress:(CGFloat)progress{

        //圆终点位置
    CGFloat endA = - M_PI_2 + M_PI * 2 * progress;
        // 创建曲线,绘制圆形path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center
                                                              radius:_radius
                                                          startAngle:_startA
                                                            endAngle:endA
                                                           clockwise:YES];
        // 设置shapeLayer的cgPath
    _cyclelayer.path = circlePath.CGPath;
}


#pragma mark 绘制图层
-(CAShapeLayer *)grayCyclelayer{
    if (_grayCyclelayer == nil) {

        CGFloat endA = -M_PI_2 + M_PI * 4;  //圆终点位置

            // 创建曲线,绘制圆形path
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center
                                                                  radius:_radius
                                                              startAngle:_startA
                                                                endAngle:-endA
                                                               clockwise:NO];
            // 创建shapeLayer
        _grayCyclelayer = [CAShapeLayer layer];
        _grayCyclelayer.frame = self.bounds;
        _grayCyclelayer.path = circlePath.CGPath;
        _grayCyclelayer.opacity = 1.0f;
        _grayCyclelayer.lineCap = kCALineCapRound;
        _grayCyclelayer.lineWidth = 2.2f; // 线宽
        _grayCyclelayer.strokeColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;// 设置线条颜色
        [_grayCyclelayer setFillColor:[UIColor clearColor].CGColor]; // 清除填充颜色
    }
    return _grayCyclelayer;
}

-(CAShapeLayer *)cyclelayer{
    if (_cyclelayer == nil) {

        CGFloat endA = - M_PI_2 + M_PI * 2 * _progress;  //圆终点位置

            // 创建曲线,绘制圆形path
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center
                                                                  radius:_radius
                                                              startAngle:_startA
                                                                endAngle:endA
                                                               clockwise:YES];

            // 创建shapeLayer
        _cyclelayer = [CAShapeLayer layer];
        _cyclelayer.frame = self.bounds;
        _cyclelayer.path = circlePath.CGPath;
        _cyclelayer.opacity = 1.0f;
        _cyclelayer.lineCap = kCALineCapRound;
        _cyclelayer.lineWidth = 2.2f; // 设置线宽
        _cyclelayer.strokeColor = [UIColor colorWithRed:0 green:131/255.0 blue:224/255.0 alpha:1.0].CGColor;// 设置线条颜色
        [_cyclelayer setFillColor:[UIColor clearColor].CGColor]; // 清楚填充颜色
    }
    return _cyclelayer;
}

-(UIImageView *)statusImageView{
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 12, 12)];
        _statusImageView.image = [UIImage imageNamed:@"upload"];
    }
    return _statusImageView;
}

@end
