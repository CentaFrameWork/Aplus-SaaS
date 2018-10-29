//
//  CreatFilterButtonView.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CreatFilterButtonView.h"

@implementation CreatFilterButtonView

#define FourBtnTag 10000000
#define ThreeBtnTag 1000000
#define TwoBtnTag 100000
#define OnlyOneTag 1111


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
    }
    return self;
}
- (void)creatButtonFirstLabel:(NSString*)first
                 SecondLabel:(NSString*)second
                  ThirdLabel:(NSString*)third
                 FourthLabel:(NSString*)fourth
{
    NSArray * array = [[NSArray alloc]initWithObjects:first ,second ,third ,fourth , nil];
    int width = (APP_SCREEN_WIDTH - 50) / 4;
    for (int i = 0; i < 4; i++)
    {
        CGSize size = [array[i] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 26)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1;
        if (i == 0)
        {
            if (APP_SCREEN_WIDTH > 320)
            {
                button.frame = CGRectMake(4, 5, width, 30);
            }
            else
            {
                button.frame = CGRectMake(1, 5, width, 30);
            }
        }
        else
        {
            button.frame = CGRectMake(10 + i * ( width + 10 ), 5, width, 30);
        }
        [button addTarget:self action:@selector(fourButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc]init];
        if (i == 0)
        {
            label.frame = CGRectMake(button.frame.size.width /2 - 5 - size.width / 2 - 8, button.frame.size.height / 2 - 13, size.width + 22, 26);
        }
        else
        {
            label.frame = CGRectMake(button.frame.size.width / 2 - 5 - size.width / 2, button.frame.size.height / 2 - 13, size.width, 26);
        }
        label.text = array[i];
        label.textColor = LITTLE_GRAY_COLOR;
        label.font = [UIFont systemFontOfSize:14.0];
        label.tag = FourBtnTag + i;
        label.textAlignment = NSTextAlignmentRight;
        [button addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        if (i == 0)
        {
            imageView.frame = CGRectMake(label.frame.origin.x + size.width + 25, label.center.y - 2, 8, 6);
        }
        else
        {
            imageView.frame = CGRectMake(label.frame.origin.x + size.width + 3, label.center.y - 2, 8, 6);
        }
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        imageView.tag = 11 + i;
        [button addSubview:imageView];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 0.5)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.alpha = 0.5;
    [self addSubview:label];
}

- (void)creatButtonFirstLabel:(NSString*)first
                 SecondLabel:(NSString*)second
                  ThirdLabel:(NSString*)third

{
    NSArray * array = [[NSArray alloc]initWithObjects:first,second,third, nil];
    int width = APP_SCREEN_WIDTH/3;
    for (int i = 0; i < 3; i++)
    {
        CGSize size = [array[i] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 26)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 10;
        button.frame = CGRectMake(i * width, (self.frame.size.height - 30) / 2, width, 30);
        [button addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.size.height / 2 - 13, width, 26)];
        label.text = array[i];
        label.textColor = YCTextColorBlack;
        label.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight];
        label.tag = ThreeBtnTag+i;
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width-(width/2-(size.width/2))+5, label.center.y-2, 8, 6)];
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        imageView.tag = 11 + i;
        [button addSubview:imageView];
    }
}

- (void)creatButtonFirstLabel:(NSString*)first
                 SecondLabel:(NSString*)second
{
    NSArray * array = [[NSArray alloc]initWithObjects:first,second, nil];
    
    int width = (APP_SCREEN_WIDTH-30) / 2;
    
    for (int i = 0; i < 2; i++)
    {
        CGSize size = [array[i] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 26)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 100;
        button.frame = CGRectMake( 3 + i * ( width + 10 ), 5, width, 30);
        [button addTarget:self action:@selector(twoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake( button.frame.size.width / 2 - 5 - size.width / 2,
                                                                  button.frame.size.height / 2 - 13, size.width, 26)];
        label.text = array[i];
        label.textColor = LITTLE_GRAY_COLOR;
        label.font = [UIFont systemFontOfSize:14.0];
        label.tag = TwoBtnTag + i;
        label.textAlignment = NSTextAlignmentRight;
        [button addSubview:label];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x+size.width+6, label.center.y - 2, 8, 6)];
        imageView.image=[UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
        imageView.tag = 11 + i;
        [button addSubview:imageView];
    }
    //底线
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, APP_SCREEN_WIDTH, 0.5)];
    bottomLabel.backgroundColor = [UIColor lightGrayColor];
    bottomLabel.alpha = 0.5;
    [self addSubview:bottomLabel];
    //中间的线
    UIImageView *centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH/2-0.25, 0, 0.5, self.frame.size.height)];
    centerImg.image = [UIImage imageNamed:@"seperatorVerLine_darkGray.png"];
    [self addSubview:centerImg];
    
}

- (void)creatRegionButtonWithTitle:(NSString *)title
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = OnlyOneTag;
    button.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH / 4, 40);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button addTarget:self action:@selector(oneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.center.x+(size.width/2)+6,button.center.y-2, 8, 6)];
    imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
    imageView.tag = 11;
    [button addSubview:imageView];
    
}


#pragma mark -ButtonClick
- (void)fourButtonClick:(UIButton*)button
{
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:11+i];
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
    }
    
    UIImageView *currentImg = (UIImageView *)[self viewWithTag:button.tag+10 ];
    currentImg.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
    
    [self.delegate getButtonTag:button.tag];
}

- (void)threeButtonClick:(UIButton*)button
{
    for (int i = 0; i < 3; i++)
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:11+i];
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
    }
    
    UIImageView *currentImg = (UIImageView *)[self viewWithTag:button.tag+1];
    currentImg.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
    
    [self.delegate getButtonTag:button.tag];
}

- (void)twoButtonClick:(UIButton*)button
{
    for (int i = 0; i < 2; i++)
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:11+i];
        imageView.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_gray"];
    }
    
    UIImageView *currentImg = (UIImageView *)[self viewWithTag:button.tag+1-90];
    currentImg.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
    
    [self.delegate getButtonTag:button.tag];
}

- (void)oneButtonClick:(UIButton*)button
{
    UIImageView *currentImg = (UIImageView *)[self viewWithTag:11];
    currentImg.image = [UIImage imageNamed:@"icon_jm_arrow_under_solid_green"];
    
    [self.delegate getButtonTag:button.tag];
}
@end

