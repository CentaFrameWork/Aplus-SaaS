//
//  FilterMoreDetailCell.h
//  APlus
//
//  Created by 张旺 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectItemDtoEntity.h"
#import "FilterEntity.h"

#define InteritemSpacing     12.f
#define LineSpacing          12.f
#define ItemHeight           27.f

typedef void(^SelectItemBlock)(NSString *key, NSMutableArray *itemArray);

@interface FilterMoreDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *estateFilterTitle;

@property (weak, nonatomic) IBOutlet UITextField *minBuildingAreaText;
@property (weak, nonatomic) IBOutlet UITextField *maxBuildingAreaText;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *areaView;

@property (strong, nonatomic) NSMutableArray *selectItemArray;
@property (copy, nonatomic) SelectItemBlock selectItemBlock;

@property (nonatomic, strong) FilterEntity * filterEntity;


- (void)setCellDataWithTitle:(NSString *)title
                andDataArray:(NSArray *)dataArray
             andFilterEntity:(FilterEntity *)filterEntity
                andIndexPath:(NSIndexPath *)indexPath
       andSelectRowItemArray:(NSMutableArray *)selectRowItemArray
                  andLineNum:(NSInteger)lineNum;

+ (FilterMoreDetailCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end


//@interface CollectionCell : UICollectionViewCell
//@property (strong, nonatomic) UIButton *filterButton;
//- (void)setCellDataWithData:(NSString *)data andIsSelected:(BOOL)isSelected;
//@end

