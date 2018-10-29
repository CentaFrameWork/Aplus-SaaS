//
//  ApplyTransferPubEstRemindPersonCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ApplyTransferPubEstRemindPersonCell.h"
#import "ApplyRemindPersonCollectionCell.h"
#import "SearchRemindPersonViewController.h"

#pragma mark Static
static NSString * const applyRemindPersonCollectionCellID = @"applyRemindPersonCollectionCell";

static NSInteger DeleteRemindPersonBtnTag = 10000;   //删除按钮baseTag
static NSInteger AddRemindPersonActionTag = 20001;   //点击提醒人后Actionsheet

@interface ApplyTransferPubEstRemindPersonCell ()
<UICollectionViewDelegate,UICollectionViewDataSource,SearchRemindPersonDelegate>

@property (strong,nonatomic)UIViewController *passViewController;	//父VC
@property (strong,nonatomic)UITableView *passTableView;		//父tableView

@property (strong,nonatomic)NSMutableArray *remindPersonsArr;	//选择联系人

@property (copy,nonatomic)NSMutableArray *informDepartsNameArr;
@property (copy,nonatomic)NSMutableArray *informDepartsKeyIdArr;
@property (copy,nonatomic)NSMutableArray *contactsNameArr;
@property (copy,nonatomic)NSMutableArray *contactsKeyIdArr;

@property (copy,nonatomic)selectedContactsArraryBlock block;

@end


@implementation ApplyTransferPubEstRemindPersonCell

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
	_informDepartsNameArr = [[NSMutableArray alloc] init];
	_informDepartsKeyIdArr = [[NSMutableArray alloc] init];
	_contactsNameArr = [[NSMutableArray alloc] init];
	_contactsKeyIdArr = [[NSMutableArray alloc] init];
	
    _remindPersonVerSepLineWidth.constant = 0.5;
	
	UINib *collectionCellNib = [UINib nibWithNibName:@"ApplyRemindPersonCollectionCell"
											  bundle:nil];
	[_showRemindListCollectionView registerNib:collectionCellNib
				  forCellWithReuseIdentifier:applyRemindPersonCollectionCellID];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - <Setup>

- (void)setupCellWithViewController:(UIViewController *)vc tableView:(UITableView *)tableView{
	
	[self.addRemindPersonBtn addTarget:self
                                action:@selector(clickAddRemindPersonMethod)
                      forControlEvents:UIControlEventTouchUpInside];
	
	self.passViewController = vc;
	self.passTableView = tableView;
	
	self.showRemindListCollectionView.delegate = self;
	self.showRemindListCollectionView.dataSource = self;
}

#pragma mark - <UICollectionViewDelegate／UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.remindPersonsArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	
	RemindPersonDetailEntity *remindPersonEntity = [self.remindPersonsArr objectAtIndex:indexPath.row];
	
	CGFloat collectionViewWidth = (202.0/320.0) * APP_SCREEN_WIDTH;
	
	CGFloat resultStrWidth = [remindPersonEntity.resultName getStringWidth:[UIFont fontWithName:FontName
																						   size:14.0]
																	Height:25.0
																	  size:14.0];
	resultStrWidth += 20;
	
	if (resultStrWidth > collectionViewWidth)
    {
		resultStrWidth = collectionViewWidth;
	}
	
	return CGSizeMake(resultStrWidth, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *collectionCellId = @"applyRemindPersonCollectionCell";
	
	ApplyRemindPersonCollectionCell *remindPersonCollectionCell = (ApplyRemindPersonCollectionCell *)[_showRemindListCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellId
																																							forIndexPath:indexPath];
	
	remindPersonCollectionCell.rightDeleteBtn.tag = DeleteRemindPersonBtnTag+indexPath.row;
	[remindPersonCollectionCell.rightDeleteBtn addTarget:self
												  action:@selector(deleteRemindPersonMethod:)
										forControlEvents:UIControlEventTouchUpInside];
	
	RemindPersonDetailEntity *curRemindPersonEntity = [self.remindPersonsArr objectAtIndex:indexPath.row];
	remindPersonCollectionCell.leftValueLabel.text = curRemindPersonEntity.resultName;
	
	return remindPersonCollectionCell;
}

//#pragma mark - <BYActionSheetViewDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView
//  clickedButtonAtIndex:(NSInteger)buttonIndex andButtonTitle:(NSString *)buttonTitle
//{
//
//    if (alertView.tag == AddRemindPersonActionTag)
//    {
//        // 添加提醒人
//        SearchRemindType selectRemindType;
//        NSString *selectRemindTypeStr;
//
//        switch (buttonIndex) {
//            case 0:
//            {
//                //部门
//                selectRemindType = DeparmentType;
//                selectRemindTypeStr = DeparmentRemindType;
//            }
//                break;
//            case 1:
//            {
//                //人员
//                selectRemindType = PersonType;
//                selectRemindTypeStr = PersonRemindType;
//            }
//                break;
//
//            default:
//            {
//                return;
//            }
//                break;
//        }
//
//        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
//                                                                  initWithNibName:@"SearchRemindPersonViewController"
//                                                                  bundle:nil];
//        searchRemindPersonVC.selectRemindType = selectRemindType;
//        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
//        searchRemindPersonVC.selectedRemindPerson = self.remindPersonsArr;
//        searchRemindPersonVC.delegate = self;
//        [self.passViewController.navigationController pushViewController:searchRemindPersonVC
//                                                                animated:YES];
//    }
//}

#pragma mark - <SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
	[self performSelector:@selector(reloadRemindCellHeight)
			   withObject:nil
			   afterDelay:0.1];
	
	if ([selectRemindItem.departmentKeyId isEqualToString:
		 selectRemindItem.resultKeyId])
    {
		// 部门
		[_informDepartsNameArr addObject:selectRemindItem.resultName];
		[_informDepartsKeyIdArr addObject:selectRemindItem.resultKeyId];
        selectRemindItem.type = @"部门";
	}
    else
    {
		// 人员
		[_contactsNameArr addObject:selectRemindItem.resultName];
		[_contactsKeyIdArr addObject:selectRemindItem.resultKeyId];
        
        selectRemindItem.type = @"人员";
	}
	
    
    [_remindPersonsArr addObject:selectRemindItem];
    [self.showRemindListCollectionView reloadData];

	if (_block) {
		_block(@[_contactsNameArr,_informDepartsNameArr,_contactsKeyIdArr,_informDepartsKeyIdArr]);
	}

}

#pragma mark - <Public Method>
- (void)passingSelectedContactsArrBlock:(selectedContactsArraryBlock)block{
	_block = block;
}



#pragma mark - <Private Method>
/**
 *  添加提醒人
 */
- (void)clickAddRemindPersonMethod
{
	
	[self.passViewController.view endEditing:YES];
    
    NSArray * listArr = @[@"部门",@"人员"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        // 添加提醒人
        SearchRemindType selectRemindType;
        NSString *selectRemindTypeStr;
        
        switch (optionValue) {
            case 0:
            {
                //部门
                selectRemindType = DeparmentType;
                selectRemindTypeStr = DeparmentRemindType;
            }
                break;
            case 1:
            {
                //人员
                selectRemindType = PersonType;
                selectRemindTypeStr = PersonRemindType;
            }
                break;
                
            default:
            {
                return;
            }
                break;
        }
        
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                                  initWithNibName:@"SearchRemindPersonViewController"
                                                                  bundle:nil];
        searchRemindPersonVC.selectRemindType = selectRemindType;
        searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
        searchRemindPersonVC.selectedRemindPerson = self.remindPersonsArr;
        searchRemindPersonVC.delegate = self;
        [self.passViewController.navigationController pushViewController:searchRemindPersonVC
                                                                animated:YES];
        
    }];
	
//    BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:@"部门",@"人员", nil];
//    byActionSheetView.tag = AddRemindPersonActionTag;
//    [byActionSheetView show];
}

/**
 *  删除提醒人
 */
- (void)deleteRemindPersonMethod:(UIButton *)button
{
	
	NSInteger deleteItemIndex = button.tag-DeleteRemindPersonBtnTag;
	
    RemindPersonDetailEntity *entity = self.remindPersonsArr[deleteItemIndex];
    
    if ([entity.type isEqualToString:@"部门"])
    {
        [_informDepartsNameArr removeObject:entity.resultName];
        [_informDepartsKeyIdArr removeObject:entity.resultKeyId];
    }
    
    if ([entity.type isEqualToString:@"人员"]) {
        [_contactsNameArr removeObject:entity.resultName];
        [_contactsKeyIdArr removeObject:entity.resultKeyId];
    }
    
	[self.remindPersonsArr removeObjectAtIndex:deleteItemIndex];
	
	[self.showRemindListCollectionView reloadData];
    
    
    
    if (_block) {
        _block(@[_contactsNameArr,_informDepartsNameArr,_contactsKeyIdArr,_informDepartsKeyIdArr]);
    }
	
	[self performSelector:@selector(reloadRemindCellHeight)
			   withObject:nil
			   afterDelay:0.1];
}

- (void)reloadRemindCellHeight
{
	
	[self.passTableView reloadData];
}


#pragma mark - <Get & Set>
- (NSMutableArray *)remindPersonsArr{
	if (!_remindPersonsArr) {
		_remindPersonsArr = [[NSMutableArray alloc] init];
	}
	return _remindPersonsArr;
}


@end
