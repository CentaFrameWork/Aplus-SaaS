//
//  DealDeatailCell.m
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealDeatailCell.h"
@interface DealDeatailCell ()

@property (nonatomic,strong) UIView *normalView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *imageBtn;

@property (nonatomic,strong) UIView *tableV;
@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic,strong) CALayer *firstLayer;
@property (nonatomic,strong) CALayer *secondLayer;
@property (nonatomic,strong) CALayer *lineLayer;

@property (nonatomic,strong) UIView *nor_backView;
@property (nonatomic,strong) UIView *nor_backTwoView;
@end
@implementation DealDeatailCell

+ (instancetype)loadDealDetailWithTableView:(UITableView *)tableView {
    
    DealDeatailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Deal"];
    
    if (!cell) {
        cell = [[DealDeatailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Deal"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
    }
    
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.normalView];
        [self.contentView addSubview:self.tableV];
     
    }
    
    return self;
}

- (void)setDict:(NSDictionary *)dict {

    
    NSString *keyString = dict.allKeys[0];
    
    if ([keyString isEqualToString:@"Performances"]||[keyString isEqualToString:@"Details"]) {//基本信息 // 纳税
        
        
        self.normalView.hidden = YES;
        self.tableV.hidden = NO;
        
        [self test:dict.allValues[0] withKey:keyString];
        
        
    } else if ([keyString contains:@"billRecordInfo"]) {//收付款信息
        
        
        self.normalView.hidden = YES;
        self.tableV.hidden = NO;
        
        [self billRecordInfo:dict.allValues[0]];
        
        
    }else{
        
        self.normalView.hidden = NO;
        self.tableV.hidden = YES;
        _titleLabel.text = keyString;
        
        if ([keyString contains:@"网签合同"]||[keyString contains:@"审核材料"] ||[keyString contains:@"收据"]) {
           
            _detailLabel.hidden = YES;
            _imageBtn.hidden = NO;
            self.imageArray = dict.allValues[0];
        
            [_imageBtn setTitle: [NSString stringWithFormat:@"图片(%ld)张",self.imageArray.count] forState:UIControlStateNormal];
           
            
        }else{
            _detailLabel.hidden = NO;
            _imageBtn.hidden = YES;
            
            if ([dict.allValues[0] isKindOfClass:[NSString class]]) {
              
                
                if ([keyString contains:@"付款类型"]){
                    
                    SysParamItemEntity * sysParamItem = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PayType_KEYID];
                    
                    for (SelectItemDtoEntity * tmp in sysParamItem.itemList) {
                        
                        if ([tmp.itemValue isEqualToString:dict.allValues[0]]) {
                            
                            _detailLabel.text = tmp.itemText;
                            
                            break;
                            
                        }
                        
                    }
                
                }else{
                    
                _detailLabel.text = [self setDetailText:dict.allValues[0] withKeyString:keyString];
                }
                
                
                _detailLabel.frame =  CGRectMake(_titleLabel.right, 0, CellW, [self.class sizeWithString:dict.allValues[0]]);
           
            }else{
                
                _detailLabel.text = @"";
                
                _detailLabel.frame =  CGRectMake(_titleLabel.right, 0, CellW, Row_Height);
            }
            
        }
        self.normalView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, _detailLabel.height);
        self.lineView.height = _detailLabel.height;
        self.nor_backView.height = _detailLabel.height;
        self.nor_backTwoView.height = _detailLabel.height;
    }
    
    
}


#pragma mark -  基本信息
- (void)test:(NSArray*)arr withKey:(NSString*)string{
    
    
   // 先这样 不是很好 因为就两个处理
        if (self.tableV.subviews.count) {
    
             [self.tableV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    
    
    for (int i = 0; i<arr.count; i++) {
        
        NSArray *arr2 = nil;
        if ([string isEqualToString:@"Performances"]) {
            
            arr2 = [arr[i] objectsForKeys:@[@"UserName",@"Rate",@"Description"] notFoundMarker:@"不存在"];
            
        }else if ([string isEqualToString:@"Details"]){
            
            arr2 = [arr[i] objectsForKeys:@[@"ScottareType",@"ScottarePrice"] notFoundMarker:@"不存在"];
            
        }else {
            
            
            
        }
        
        for (int j = 0; j<arr2.count; j++) {
            
            CGFloat marget = 0;
            CGFloat weight = (APP_SCREEN_WIDTH -96- (arr.count +1)*marget)/arr2.count;
            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = YCTextColorGray;
            label.textAlignment = 1;
            label.layer.borderColor = RGBColor(236, 236, 236).CGColor;
            label.layer.borderWidth = 1;
           
            CGFloat H = 4;// 为了留
            if ([string isEqualToString:@"Details"]) {
                
                NSString* DetailString = j==0?@"缴税税种:":@"缴税税额:";
                label.text = [DetailString stringByAppendingString:arr2[j]];
                label.frame = CGRectMake((marget+weight-1) * j + 54, 4+i*(Row_Height-H-1), weight, Row_Height-H);
            }else{
                
                
                label.text = arr2[j];
                label.frame = CGRectMake((marget+weight-1) * j + 54, i*(Row_Height-H-1), weight, Row_Height-H);
                
                
                NSLog(@"%@",NSStringFromCGRect(label.frame));
                
            }
                
            
            
       
            [self.tableV addSubview:label];
            
        }
    }
    
    
    
    self.tableV.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, arr.count * Row_Height+7);
    [self setLayerHight];
    

}

#pragma mark -  收付款信息列表
- (void)billRecordInfo:(NSArray<NSDictionary*>*)valueArray {
    
    
    //先这样 不是很好....
    if (self.tableV.subviews.count) {
        
        [self.tableV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    for (int j = 0; j<valueArray.count; j++) {
        
        
        UILabel *label01 = [[UILabel alloc] initWithFrame:CGRectMake(54, j*Row_Height,  Title_width, Row_Height)];
        label01.text = valueArray[j].allKeys.firstObject;
        label01.font = [UIFont systemFontOfSize:14];
        label01.textColor = YCTextColorGray;
        [self.tableV addSubview:label01];
        
        
        UILabel *label02 = [[UILabel alloc] init];
        label02.numberOfLines = 0;
        label02.font = [UIFont systemFontOfSize:14];
        label02.textColor = YCTextColorBlack;
        
        if ([valueArray[j].allValues[0] isKindOfClass:[NSString class]]) {
            
            label02.text = [self setDetailText:valueArray[j].allValues.firstObject withKeyString:label01.text];

            label02.frame =  CGRectMake(label01.right, j*Row_Height, CellW, [self.class sizeWithString:label02.text]);
        }else{
            
            label02.text = @"";
            
            label02.frame =  CGRectMake(label01.right, j*Row_Height, CellW, Row_Height);
            
        }
        
        [self.tableV addSubview:label02];
        
    }
    
    UILabel *label = self.tableV.subviews.lastObject;
    
    self.tableV.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, label.y+label.height);
    
    [self setLayerHight];
   
}

- (UIView *)normalView {
    
    if (!_normalView) {
        
        _normalView = [[UIView alloc] initWithFrame:self.bounds];
        
        
        _nor_backView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, APP_SCREEN_WIDTH-24, Row_Height)];
        _nor_backView.backgroundColor = [UIColor whiteColor];
        
        [_normalView addSubview:_nor_backView];
        
        
        // 第二个背景
        _nor_backTwoView = [[UIView alloc] initWithFrame:CGRectMake(24, 0, _nor_backView.width-48, Row_Height)];
//        _nor_backTwoView.backgroundColor = RGBColor(247, 247, 247);
        
        [_nor_backView addSubview:_nor_backTwoView];
        
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, Row_Height)];
        _lineView.backgroundColor = YCThemeColorGreen;
        [_nor_backTwoView addSubview:_lineView];
        
        
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, Title_width, Row_Height)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = YCTextColorGray;
        [_nor_backTwoView addSubview:_titleLabel];
        
        
        // 详情
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right, 0, CellW, Row_Height)];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = YCTextColorBlack;
        _detailLabel.numberOfLines = 0;
        [_nor_backTwoView addSubview:_detailLabel];
        
        
        
        _imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(_titleLabel.right, 2, 120, 24)];
        [_imageBtn setTitle:@"图片(0张)" forState:UIControlStateNormal];
        [_imageBtn addTarget:self action:@selector(seeImage:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _imageBtn.backgroundColor = YCThemeColorGreen;
        [_imageBtn setLayerCornerRadius:5];
        [_nor_backTwoView addSubview:_imageBtn];
        
        
        
        
    }
    return _normalView;
    
}
- (UIView *)tableV {
    
    if (!_tableV) {
        _tableV = [[UIView alloc] initWithFrame:self.bounds];
        
        
        _firstLayer = [[CALayer alloc] init];
                          
        _firstLayer.frame  = CGRectMake(12, 0, APP_SCREEN_WIDTH-24, Row_Height);
        _firstLayer.backgroundColor = [UIColor whiteColor].CGColor;
        
        [_tableV.layer addSublayer:_firstLayer];
        
        
        
         // 第二个背景
        _secondLayer = [[CALayer alloc] init];
        
        _secondLayer.frame  = CGRectMake(24, 0, APP_SCREEN_WIDTH-72, Row_Height);
//        _secondLayer.backgroundColor = RGBColor(247, 247, 247).CGColor;
        
        [_firstLayer addSublayer:_secondLayer];
        
       
        // 第二个背景
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.frame  = CGRectMake(24, -10, 1, Row_Height);
        _lineLayer.backgroundColor = YCThemeColorGreen.CGColor;
        
        [_firstLayer addSublayer:_lineLayer];
       
        
    }
    
    return _tableV;
}

- (void)seeImage:(UIButton*)btn {
    
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnSeeImage:withArr:)]) {
        
        [self.delegate didClickBtnSeeImage:btn withArr:self.imageArray];
    }
    
}
- (NSString*)setDetailText:(NSString*)valueString withKeyString:(NSString*)keyString {
    
   
    NSString * text = nil;
    if([keyString contains:@"额"] ||[keyString contains:@"价"]){
        
        // 不分租售
        if ([keyString contains:@"退款"] || [keyString contains:@"意向金"] ||[keyString contains:@"收退"] || [keyString contains:@"收佣"]) {
            
            text = [valueString stringByAppendingString:@"元"];
            
        }else{
            
           
            if ([self.DealType contains:@"售"]) {
                
                text = [valueString stringByAppendingString:@"万"];
                
            }else{
                
                if([keyString contains:@"定金"]){
                    
                    text = [valueString stringByAppendingString:@"万"];
                    
                }else{
                    
                    
                    text = [valueString stringByAppendingString:@"元"];
                }
              
            }
            
            
        }
        
    
        return text.length > 1 ? text:@"";
      
        
    }else if([keyString contains:@"利率"]){
        
     text = [valueString stringByAppendingString:@"%"];
        
    }else{
        
      text = valueString;
    }
    return text.length > 1 ? text:@"";
    
}

+ (CGFloat)sizeWithString:(NSString*)string {
   
 
       CGSize size =  [string boundingRectWithSize:CGSizeMake(CellW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    

        return size.height>Row_Height ? size.height:Row_Height;
  
  

    
}

- (void)setLayerHight {
    
    self.firstLayer.frame = CGRectMake(12, 0, APP_SCREEN_WIDTH-24, self.tableV.height);
    self.secondLayer.frame  = CGRectMake(24, 0, APP_SCREEN_WIDTH-72, self.tableV.height);
    self.lineLayer.frame  = CGRectMake(24, -10, 1, self.tableV.height+10);
}

/**
 
 
 [valueArray addObject:arr2];
 
 NSInteger subNum = self.tableV.subviews.count;
 NSInteger allNum = valueArray.count * valueArray[0].count;
 
 if (subNum > allNum) {
 
 for (int j = 0; j<subNum; j++) {
 
 UILabel *label = self.tableV.subviews[j];
 if (j < allNum) {
 
 CGFloat marget = 45;
 CGFloat weight = (APP_SCREEN_WIDTH - (arr2.count +1)*marget)/arr2.count;
 label.frame = CGRectMake((marget+weight) * j + marget, i*44, weight, 44);
 label.text = valueArray[i][j];
 label.hidden = YES;
 
 }else {
 
 label.hidden = YES;
 
 }
 
 }
 
 
 }else if (subNum == allNum){
 
 
 for (int j = 0; j<subNum; j++) {
 
 UILabel *label = self.tableV.subviews[j];
 CGFloat marget = 45;
 CGFloat weight = (APP_SCREEN_WIDTH - (arr2.count +1)*marget)/arr2.count;
 label.frame = CGRectMake((marget+weight) * j + marget, i*44, weight, 44);
 label.text = valueArray[i][j];
 label.hidden = YES;
 
 }
 
 
 }else if (subNum < allNum) {
 
 for (int j = 0; j<allNum; j++) {
 
 
 if (j < subNum) {
 
 CGFloat marget = 45;
 CGFloat weight = (APP_SCREEN_WIDTH - (arr2.count +1)*marget)/arr2.count;
 UILabel *label = self.tableV.subviews[j];
 label.frame = CGRectMake((marget+weight) * j + marget, i*44, weight, 44);
 label.text = valueArray[i][j];
 label.hidden = NO;
 
 }else {
 CGFloat marget = 45;
 CGFloat weight = (APP_SCREEN_WIDTH - (arr2.count +1)*marget)/arr2.count;
 
 UILabel *label = [[UILabel alloc] init];
 label.frame = CGRectMake((marget+weight) * j + marget, i*44, weight, 44);
 label.text =  valueArray[i][j];
 label.hidden = NO;
 [self.tableV addSubview:label];
 }
 
 
 }
 
 
 }
 */

@end

