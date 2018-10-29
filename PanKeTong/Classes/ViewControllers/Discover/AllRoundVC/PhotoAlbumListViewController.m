//
//  PhotoAlbumListViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/15.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "PhotoAlbumListViewController.h"
#import "PhotoAlbumListCell.h"
#import "PhotoAlbumDetailViewController.h"

#define GetPhotoAlbumFailedAlertTag         1001

@interface PhotoAlbumListViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *_photoAlbumArray;
    __weak IBOutlet UITableView *_mainTableView;
    
}

@end

@implementation PhotoAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
}

-(void)initView
{
    [self setNavTitle:@"相机胶卷"
       leftButtonItem:nil
      rightButtonItem:[self customBarItemButton:@"取消"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(back)]];
    
}

-(void)initData
{
    
    _photoAlbumArray = [[NSMutableArray alloc]init];
    
    /**
     *  ALAssetsGroupAll    取得全部类型的相簿
     *
     */
    
    __weak typeof (self) weakSelf = self;
    
    [_photoLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     
                                     if (group) {
                                         
                                         /**
                                          *  添加照片、视频过滤条件
                                          */
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
                                         [weakSelf dealAssetsGroupListSuccessWithGroup:group];
                                     }
                                 }
                               failureBlock:^(NSError *error) {
                                   
                                   UIAlertView *userDeniedErrorAlert;
                                   
                                   if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                                       
                                       //用户拒绝访问
                                       NSString *alertMessage = [NSString stringWithFormat:@"请在手机的“设置-隐私-照片”中，允许“%@”访问你的手机相册",SettingProjectName];
                                       
                                       userDeniedErrorAlert = [[UIAlertView alloc]
                                                               initWithTitle:@"获取手机相册失败"
                                                               message:alertMessage
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"确认", nil];
                                       userDeniedErrorAlert.tag = GetPhotoAlbumFailedAlertTag;
                                       
                                       [userDeniedErrorAlert show];
                                       
                                   }else{
                                       
                                       //获取相机胶卷失败
                                       
                                       userDeniedErrorAlert = [[UIAlertView alloc]
                                                               initWithTitle:error.domain
                                                               message:nil
                                                               delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"确认", nil];
                                       userDeniedErrorAlert.tag = GetPhotoAlbumFailedAlertTag;
                                       
                                       [userDeniedErrorAlert show];
                                   }
                                   
                               }];
    
}

-(void)dealAssetsGroupListSuccessWithGroup:(ALAssetsGroup *)assetsGroup
{
    
    if (assetsGroup) {
        
        //相册的名称
        NSString *assetsGroupNameStr = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        //相册的照片数量
        NSInteger assetsGroupImageCount = [assetsGroup numberOfAssets];
        
        //过滤后的照片数量为零
        if (assetsGroupImageCount == 0) {
            
            return;
        }
        
        if ([assetsGroupNameStr isEqualToString:@"相机胶卷"]) {
            
            [_photoAlbumArray insertObject:assetsGroup
                                   atIndex:0];
        }else{
            
            [_photoAlbumArray addObject:assetsGroup];
        }
        
        [_mainTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photoAlbumArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"photoAlbumListCell";
    
    PhotoAlbumListCell *photoAlbumcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!photoAlbumcell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"PhotoAlbumListCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        
        photoAlbumcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    ALAssetsGroup *assetsGroup = [_photoAlbumArray objectAtIndex:indexPath.row];
    
    //相册的名称
    NSString *assetsGroupNameStr = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    //相册的数量
    NSInteger assetsGroupImageCount = [assetsGroup numberOfAssets];
    //相册的封面图
    CGImageRef assetsGroupCGPosterImage = [assetsGroup posterImage];
    UIImage *assetsGroupPosterImage = [UIImage imageWithCGImage:assetsGroupCGPosterImage];
    
    [photoAlbumcell.photoAlbumPosterImageView setImage:assetsGroupPosterImage];
    photoAlbumcell.photoAlbumNameLabel.text = assetsGroupNameStr;
    photoAlbumcell.photoAlbumCountLabel.text = [NSString stringWithFormat:@"%@",@(assetsGroupImageCount)];
    
    return photoAlbumcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 86.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_mainTableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    
    PhotoAlbumDetailViewController *photoAlbumDetailVC = [[PhotoAlbumDetailViewController alloc]initWithNibName:@"PhotoAlbumDetailViewController" bundle:nil];
    photoAlbumDetailVC.photoAlbumListVC = self;
    photoAlbumDetailVC.photoAssetsLibrary = _photoLibrary;
    photoAlbumDetailVC.selectedPhotosArr = _selectedPhotosArr;
    
    ALAssetsGroup *selectAssetsGroup = [_photoAlbumArray objectAtIndex:indexPath.row];
    photoAlbumDetailVC.selectAssetsPersistentId = [selectAssetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    photoAlbumDetailVC.selectAssetsGroupName = [selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    [self.navigationController pushViewController:photoAlbumDetailVC
                                         animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == GetPhotoAlbumFailedAlertTag) {
        
        [self back];
    }
    
}

-(void)dealloc
{
    
    _photoAlbumArray = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
