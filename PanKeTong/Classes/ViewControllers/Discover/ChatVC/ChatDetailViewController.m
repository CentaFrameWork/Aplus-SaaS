//
//  ChatDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ChatDetailViewController.h"



@interface ChatDetailViewController ()<RCPluginBoardViewDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
{
    UILabel *_userNameLabel;
    
    UIImagePickerController *_imagePicker;
    
    NSString *_staffPhoneNum;
    
    DataBaseOperation *_dataBaseOperation;
}

@end

@implementation ChatDetailViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        
        [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType
                                               style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];
    self.chatSessionInputBarControl.emojiButton.hidden = YES;
    [self.chatSessionInputBarControl.inputTextView setFrame:CGRectMake(10,
                                                                       7,
                                                                       APP_SCREEN_WIDTH-20,
                                                                       36)];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    
    self.userName = [NSString stringWithFormat:@"%@(在线)",
                     self.userName];
    
    [self.pluginBoardView removeItemAtIndex:1];
    [self.pluginBoardView removeItemAtIndex:1];
    [self.pluginBoardView removeItemAtIndex:1];
    
    [self initNavView];
    
}

- (void)initNavView
{
    
    self.title = self.userName;
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    
    UIButton *leftItemBtn = [self customBarItemButton:nil
                                      backgroundImage:nil
                                           foreground:@"back.png"
                                                  sel:@selector(back)];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBtn];
    
    if (MODEL_VERSION >=7.0) {
        
        leftNegativeSpacer.width = -15;
    }
    
    self.navigationItem.leftBarButtonItems = @[leftNegativeSpacer,leftBarItem];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CreateBarItem
- (UIButton *)customBarItemButton:(NSString *)title
                  backgroundImage:(NSString *)bgImg
                       foreground:(NSString *)fgImg
                              sel:(SEL)sel {
    
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [customBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [customBtn setBackgroundColor:[UIColor clearColor]];
    customBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (bgImg) {
        UIImage *image = [UIImage imageNamed:bgImg];
        [customBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (fgImg && MODEL_VERSION >=7.0) {
        [customBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [customBtn setImage:[UIImage imageNamed:fgImg] forState:UIControlStateNormal];
    }
    
    if (title) {
        
        [customBtn setTitle:title forState:UIControlStateNormal];
    }
    
    [customBtn.titleLabel setFont:font];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (sel) {
        [customBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customBtn;
    
}


#pragma mark -  <ImagePickerDelegate>
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemAtIndex:(NSInteger)index
{
    //点击图片
    
    if (index == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = NO;
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController:_imagePicker
                                                    animated:YES
                                                  completion:^{
                                                      
                                                      
                                                  }];
            
        }
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}


@end
