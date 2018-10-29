//
//  ShowPhotoAssetsViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ShowPhotoAssetsViewController.h"
#import "BRImageScrollView.h"
#import "PhotoAssetsItemEntity.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AgencySysParamUtil.h"
#import "NSDictionary+JSONTransfer.h"




/**
 选择照片类型：室内照、小区照、平面照
 */
typedef enum
{
    PhotoAssetTypeNone = 1000,
    RoomPhotoAssetType,
    XiaoquPhotoAssetType,
    PlanePhotoAssetType,
    
}PhotoAssetsType;


@interface ShowPhotoAssetsViewController ()<BRImageScrollViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet BRImageScrollView *_showBigImageView;
    __weak IBOutlet NSLayoutConstraint *_photoAssetButtomViewHeight;
    __weak IBOutlet UIButton *_deletePhotoAssetBtn;
    __weak IBOutlet UIButton *_selectPhotoAssetTypeBtn;
    __weak IBOutlet UILabel *_photoAssetTypeLabel;
    __weak IBOutlet UIButton *_roomTypePhotoBtn;
    __weak IBOutlet UIButton *_xiaoquTypePhotoBtn;
    __weak IBOutlet UIButton *_planeTypePhotoBtn;
    __weak IBOutlet UISwitch *_panoramaPhotoSwitch;
    __weak IBOutlet UILabel *_panoramaPhotoLabel;
    
    
    
    NSInteger _currentPhotoAssetIndex;      //当前显示的图片在数据源中的index
    
    NSMutableArray *_roomPictureArray;      //室内照类型值
    NSMutableArray *_xiaoquPictureArray;    //小区照类型值
    NSMutableArray *_planePictureArray;     //平面照类型值
    
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (nonatomic,strong)NSMutableArray *sourceArray;
@property (nonatomic,strong)NSMutableArray *sourceArrayValue;
@property (nonatomic,copy)NSString *typeString;
@property (nonatomic,assign)NSInteger clickPhotoAssetsType;
@property (nonatomic,copy)NSString *selectType;

@end

@implementation ShowPhotoAssetsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    [self initData];
  
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    // 设置电池条为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
   
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line_clear"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}
-(void)initView {
    NSString *currentTitleStr = [NSString stringWithFormat:@"%@/%@",
                                 @(_selectImageIndex+1),
                                 @(_photoAssetsUrlArr.count)];
    _currentPhotoAssetIndex = _selectImageIndex;
    
    
    UIButton *btn = [self customBarItemButton:@"下一步"
                              backgroundImage:nil
                                   foreground:nil
                                          sel:@selector(finishedSelectAssetsTypeMethod)];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setNavTitle:currentTitleStr
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"返回箭头-白色"
                                            sel:@selector(willBack)]
      rightButtonItem:btn];
    
    
  
    
    
    //删除实堪图
    [_deletePhotoAssetBtn addTarget:self
                             action:@selector(deletePhotoAssetMethod)
                   forControlEvents:UIControlEventTouchUpInside];
    //选择实堪图类型
    [_selectPhotoAssetTypeBtn addTarget:self
                                 action:@selector(selectPhotoAssetValueMethod)
                       forControlEvents:UIControlEventTouchUpInside];
    
    _panoramaPhotoLabel.hidden = YES;
    _panoramaPhotoSwitch.hidden = YES;
    [_panoramaPhotoSwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}


-(void)initData
{
    SysParamItemEntity *roomSysParamEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_INDOOR_PIC];
    SysParamItemEntity *xiaoquSysParamEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_COMMUNITY_PIC];
    SysParamItemEntity *planeSysParamEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_HOUSE_TYPE_PIC];
    
    _roomPictureArray = [[NSMutableArray alloc]initWithArray:roomSysParamEntity.itemList];
    _xiaoquPictureArray = [[NSMutableArray alloc]initWithArray:xiaoquSysParamEntity.itemList];
    _planePictureArray = [[NSMutableArray alloc]initWithArray:planeSysParamEntity.itemList];
    
    [_showBigImageView reloadData];
    _showBigImageView.delegate = self;
    [_showBigImageView scrollToIndex:_selectImageIndex];
    
    _planeTypePhotoBtn.hidden = NO;

    
    
}

- (void)willBack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否放弃类型选择"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    
}


- (void)switchValueChanged:(id)sender
{
    UISwitch* control = (UISwitch*)sender;
    
    PhotoAssetsItemEntity *currentPhotoAsset = [_photoAssetsSource objectAtIndex:_currentPhotoAssetIndex];
    currentPhotoAsset.isPanorama = control.on;
}



#pragma mark - *****点击下一步*****
-(void)finishedSelectAssetsTypeMethod
{
    for (PhotoAssetsItemEntity *currentPhotoAsset in _photoAssetsSource)
    {
        if ([NSString isNilOrEmpty:currentPhotoAsset.photoAssetTypeTextStr]) {
            currentPhotoAsset.photoAssetTypeTitleStr = nil;
            currentPhotoAsset.isPanorama = nil;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(photoAssetsSource:andUrl:)]) {
        [self.delegate photoAssetsSource:_photoAssetsSource andUrl:_photoAssetsUrlArr];
    }
    
    if ([self.navigationController isKindOfClass:[UIImagePickerController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
       [self back];
    }
    
    
   
}

#pragma mark - SelectPhotoAssetTypeMethod
- (IBAction)selectPhotoAssetTypeMethod:(id)sender {
    UIButton * button = (UIButton *)sender;
    
    PhotoAssetsItemEntity *currentPhotoAsset = [_photoAssetsSource objectAtIndex:_currentPhotoAssetIndex];
    currentPhotoAsset.photoAssetTypeTextStr = @"";
    currentPhotoAsset.isPanorama = NO;
    
    [self setAssetTypeWithTag:button.tag];
    
}

#pragma mark -    设置当前实堪类型
-(void)setAssetTypeWithTag:(NSInteger)currentBtnTag {
    
    
    PhotoAssetsItemEntity *currentPhotoAsset = [_photoAssetsSource objectAtIndex:_currentPhotoAssetIndex];
    
    _selectLabel.text = currentPhotoAsset.photoAssetTypeTextStr;

    _roomTypePhotoBtn.selected = NO;
    _xiaoquTypePhotoBtn.selected = NO;
    _planeTypePhotoBtn.selected = NO;
    _panoramaPhotoSwitch.hidden = YES;
    _panoramaPhotoLabel.hidden = YES;
    _clickPhotoAssetsType = currentBtnTag;
    _photoAssetButtomViewHeight.constant = 130;
    NSMutableArray *mutArr = [NSMutableArray array];
    
    if(currentBtnTag ==1001){
        
        _typeString = @"室内图";
        _selectType = @"室内类型";
        _roomTypePhotoBtn.selected = YES;
        mutArr = _roomPictureArray;
        
    }else  if(currentBtnTag ==1002){
         _typeString = @"小区图";
        _selectType = @"小区类型";
         _xiaoquTypePhotoBtn.selected = YES;
         mutArr = _xiaoquPictureArray;
        
    }else if(currentBtnTag ==1003){
        
         _typeString = @"平面图";
        _selectType = @"平面类型";
         _planeTypePhotoBtn.selected = YES;
         mutArr = _planePictureArray;
    }else{
        
        
        if (IS_iPhone_X) {
           _photoAssetButtomViewHeight.constant = 68;
        }else{
            
            _photoAssetButtomViewHeight.constant = 95;
        }
       
        
    }
    
    _sourceArray = [NSMutableArray array];
    _sourceArrayValue = [NSMutableArray array];
    
    for (SelectItemDtoEntity *model in mutArr) {
        
        [_sourceArray addObject:model.itemText?:@""];
        [_sourceArrayValue addObject:model.itemValue?:@""];
        
    }
    
}

#pragma mark - 选择图片类型


-(void)selectPhotoAssetValueMethod {
    
  
    [NewUtils popoverSelectorTitle:_selectType listArray:_sourceArray.copy theOption:^(NSInteger optionValue) {

       
        PhotoAssetsItemEntity *currentPhotoAsset = [_photoAssetsSource objectAtIndex:_currentPhotoAssetIndex];
        
        currentPhotoAsset.photoAssetTypeTitleStr = _typeString;
        currentPhotoAsset.photoAssetTypeTitleTypeEnum = _clickPhotoAssetsType;
        currentPhotoAsset.photoassetTypeTextIndex = optionValue;
        currentPhotoAsset.photoAssetTypeTextStr = _sourceArray[optionValue];
        currentPhotoAsset.photoAssetTypeValueStr = _sourceArrayValue[optionValue];

        [_photoAssetsSource replaceObjectAtIndex:_currentPhotoAssetIndex
                                      withObject:currentPhotoAsset];
        

        
        _selectLabel.text = currentPhotoAsset.photoAssetTypeTextStr;
        
        
       
    }];
    
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        
        if ([self.navigationController isKindOfClass:[UIImagePickerController class]]) {
            
            [_photoAssetsSource removeLastObject];
            [_photoAssetsUrlArr removeLastObject];
            if ([self.delegate respondsToSelector:@selector(photoAssetsSource:andUrl:)]) {
                [self.delegate photoAssetsSource:_photoAssetsSource andUrl:_photoAssetsUrlArr];
            }
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
       
        }else{
            
            
            
            [self back];
            
            
            
        }
        
    }
}


#pragma mark - BRImageViewDelegate
- (NSInteger)numberOfPhotos{
    
    return _photoAssetsSource.count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView{
    
    PhotoAssetsItemEntity *photoAssetItem = [_photoAssetsSource objectAtIndex:index];
    
    [photoView setImage:photoAssetItem.photoAspectRatioThumbnailImage];
    
    _panoramaPhotoSwitch.on = photoAssetItem.isPanorama;
    
 
}



- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView{
    
    NSString *curIndexStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(_photoAssetsSource.count)];
    
    self.title = curIndexStr;
    _currentPhotoAssetIndex = index;
    
    /**
     *  设置当前照片的类型
     */
    PhotoAssetsItemEntity *currentPhotoAsset = [_photoAssetsSource objectAtIndex:index];
    
    if (currentPhotoAsset.photoAssetTypeTitleStr &&
        ![currentPhotoAsset.photoAssetTypeTitleStr isEqualToString:@""]) {
        
        [self setAssetTypeWithTag:currentPhotoAsset.photoAssetTypeTitleTypeEnum];
        
    }else{
        
        [self setAssetTypeWithTag:PhotoAssetTypeNone];
    }
    
    // 是否为全景图
    if (currentPhotoAsset.isPanorama) {
        _panoramaPhotoSwitch.on = YES;
    }else{
        _panoramaPhotoSwitch.on = NO;

    }
    
}

#pragma mark - 删除按钮

- (IBAction)deletePhoto:(UIButton *)btn {
    
    if (_photoAssetsSource.count == 0) {
        
        return;
    }
    
    /**
     *  删除document保存的图片
     */
    NSString *deletePhotoUrl = [_photoAssetsUrlArr objectAtIndex:_currentPhotoAssetIndex];
    [CommonMethod deleteImageFromDocWithName:deletePhotoUrl];
    
    
    [_photoAssetsSource removeObjectAtIndex:_currentPhotoAssetIndex];
    [_photoAssetsUrlArr removeObjectAtIndex:_currentPhotoAssetIndex];
    
    
    /**
     *  保存删除之前的index，因为reloadData之后“_currentPhotoAssetIndex”被置为0
     */
    NSInteger lastScrollAssetIndex = _currentPhotoAssetIndex;
    
    [_showBigImageView reloadData];
    _showBigImageView.delegate = self;
    
    
    if (_photoAssetsSource.count == 0)
    {
        if ([self.delegate respondsToSelector:@selector(photoAssetsSource:andUrl:)]) {
            [self.delegate photoAssetsSource:_photoAssetsSource andUrl:_photoAssetsUrlArr];
        }
        [self back];
        
        return;
    }
    
    /**
     *  只有照片不为零的时候才做处理
     */
    if (lastScrollAssetIndex == 0) {
        
        _currentPhotoAssetIndex = 0;
    }else{
        
        _currentPhotoAssetIndex = lastScrollAssetIndex - 1;
    }
    
    [_showBigImageView scrollToIndex:_currentPhotoAssetIndex];
}





-(void)deletePhotoAssetMethod
{
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
