//
//  PDFitstCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDOneCell.h"


@implementation PDOneCell
{
    NSString *_salePrice;// 售价

    NSString *_rentPrice;// 租价

    NSString *_houseType;// 户型
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _trustType = -1;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YCThemeColorBackground;
 
        
    }

    return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTrustType:(NSInteger)trustType
{
    if (_trustType != trustType)
    {
        _trustType = trustType;
        [self setNeedsDisplay];
    }
}


- (void)setDataArr:(NSArray *)dataArr
{
    if (_dataArr != dataArr)
    {
        _dataArr = dataArr;
        _salePrice = dataArr[0];
        _rentPrice = dataArr[1];
        _houseType = dataArr[2];

        [self setNeedsDisplay];
    
    }
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (_trustType >= 0 && _dataArr.count > 0) {
        NSArray *titleArr;
        NSArray *resultArr;

        NSString *sale = [NSString stringWithFormat:@"%@",_salePrice];
        NSString *rent = [NSString stringWithFormat:@"%@",_rentPrice];
        if (_trustType == SALE)
        {
            titleArr = @[@"售价",@"房型"];
            resultArr = @[sale,_houseType];
        }
        else if (_trustType == RENT)
        {
            titleArr = @[@"租价",@"房型"];
            resultArr = @[rent,_houseType];
        }
        else if (_trustType == BOTH)
        {
            titleArr = @[@"售价",@"租价",@"房型"];
            resultArr = @[sale,rent,_houseType];
        }else if (_trustType == typeDfeauth)
        {
            titleArr = @[@"-",@"房型"];
            resultArr = @[@"",_houseType];
        }
        
        
        
        
        CGRect rect = CGRectMake(YCAppMargin, 0, APP_SCREEN_WIDTH-2*YCAppMargin, 70);
        
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(10, 10)];
        [[UIColor whiteColor] set];
        [maskPath fill];
        
      
        CGFloat width = APP_SCREEN_WIDTH / titleArr.count;
        CGFloat height = 20;
        NSInteger count = titleArr.count;
        
        
        CGFloat titleSize = 18;
        
        
        for (NSString *string in resultArr) {
            
            if (string.length > 10) {
                
                titleSize = 13;
                break;
            }
        }
        
        
        
        
        for (int i = 0; i < count; i++) {

            NSString *text = [titleArr objectAtIndex:i];
            NSString *result = [resultArr objectAtIndex:i];
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            // 绘制文字
            [text drawInRect:CGRectMake(width * i, 5, width, height)
              withAttributes:@{
                               NSFontAttributeName:[UIFont systemFontOfSize:14.0],
                               NSForegroundColorAttributeName:YCTextColorAuxiliary,
                               NSParagraphStyleAttributeName:paragraphStyle
                               }];
            
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint: CGPointMake(width * i, 5)];
            [path addLineToPoint: CGPointMake(width * i, 50)];
            path.lineWidth = 0.5;
            
            [YCTextColorAuxiliary set];
            [path stroke];
            
            
            UIColor *fontColor;
            if ([text contains:@"售"]) {
                fontColor = YCThemeColorRed;
            }else if ([text contains:@"租"]) {
                fontColor = YCThemeColorOrange;
            }else{

                fontColor = YCTextColorRoomRBlue;
            }

            [result drawInRect:CGRectMake(width * i, 30, width, 20)
                withAttributes:@{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:titleSize],
                                 NSForegroundColorAttributeName:fontColor,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 }];


    
        }
    }

}


@end
