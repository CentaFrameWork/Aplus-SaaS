//
//  ShowEntrustFilingPhotoVC.m
//  PanKeTong
//
//  Created by 张旺 on 2017/7/21.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "ShowEntrustFilingPhotoVC.h"
#import "BRImageScrollView.h"
#import "EntrustFilingEditDetailEntity.h"

@interface ShowEntrustFilingPhotoVC ()<BRImageScrollViewDelegate>
{
    __weak IBOutlet BRImageScrollView *_showImageView;
    __weak IBOutlet UIButton *_deletePhotoBtn;
    
    NSInteger _currentPhotoAssetIndex;      // 当前显示的图片在数据源中的index
    NSInteger _deletePhotoIndex;            // 记录删除照片的下标
}

@end



@implementation ShowEntrustFilingPhotoVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

#pragma mark - init

-(void)initView
{
    [self setNavTitle:_photoType
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    if (_isOnlyViewPermission)
    {
        _deletePhotoBtn.hidden = YES;
    }
}

-(void)initData
{
    _showImageView.delegate = self;
}

#pragma mark - button Click methods

- (IBAction)deletePhotoClick:(id)sender
{
    _deletePhotoIndex = _currentPhotoAssetIndex;
    
    // 删除照片
    if (_serverPhotoArray.count > _currentPhotoAssetIndex)
    {
        // 删除从接口拿到的照片
        [_serverPhotoArray removeObjectAtIndex:_currentPhotoAssetIndex];
        
        // 删除从接口拿到的照片信息
        NSMutableArray * photoTypeArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in _uploadPhotoDetailArray)
        {
            AttachmentArray *attachment = [DataConvert convertDic:dic toEntity:[AttachmentArray class]];
            
            if([attachment.attachmenSysTypeName isEqualToString:_photoType])
            {
                [photoTypeArray addObject:dic];
            }
        }
        
        [_uploadPhotoDetailArray removeObject:photoTypeArray[_currentPhotoAssetIndex]];
    }
    else
    {
        // 删除手动添加的照片
        [_photoImageArray removeObjectAtIndex:_currentPhotoAssetIndex - _serverPhotoArray.count];
    }
    
    if (_deletePhotoBlock)
    {
        _deletePhotoBlock();
    }
    
    NSInteger photoTotalNumber = _serverPhotoArray.count + _photoImageArray.count;
    if (photoTotalNumber == 0)
    {
        // 没照片直接返回
        [self back];
    }
    else
    {
        [_showImageView reloadData];
        _showImageView.delegate = self;
    }
    
    // 删除完后显示下一张图片，如果是最后一张则显示第一张
    if (photoTotalNumber > _deletePhotoIndex + 1)
    {
        [_showImageView scrollToIndex:_deletePhotoIndex];
    }
    else
    {
        // 第一张
        [_showImageView scrollToIndex:0];
    }
}

#pragma mark - BRImageScrollViewDelegate

- (NSInteger)numberOfPhotos
{    
    // 从接口拿到跟手动添加照片的总和
    return _serverPhotoArray.count + _photoImageArray.count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(BRIamgeViewItem *)photoView
{
    NSInteger photoImageIndex = index;
    // 有编辑照片
    if (_serverPhotoArray.count > photoImageIndex)
    {
        NSRange range = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] rangeOfString:@"/image"];
        NSString *pathUrl = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] substringToIndex:range.location];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@",pathUrl,_serverPhotoArray[photoImageIndex],PhotoDownWidth];
        
        [CommonMethod setImageWithImageView:photoView.mImageView andImageUrl:imageUrl andPlaceholderImageName:@"defaultPropBig_bg"];
    }else
    {
        [photoView setImage:_photoImageArray[photoImageIndex - _serverPhotoArray.count]];
    }
}
- (void)imageAtCurrentIndex:(NSInteger)index photoView:(BRIamgeViewItem *)thumbView
{
    NSString *curIndexStr = [NSString stringWithFormat:@"%@/%@",@(index+1),@(_serverPhotoArray.count + _photoImageArray.count)];
    
    self.title = [NSString stringWithFormat:@"%@(%@)",_photoType, curIndexStr];
    
    _currentPhotoAssetIndex = index;
}

@end
