//
//  UIImage+Cap.m
//  LianDong
//
//  Created by ByronYan on 14-6-27.
//  Copyright (c) 2014年 Grant Yuan. All rights reserved.
//

#import "UIImage+Cap.h"

@implementation UIImage (Cap)

+ (UIImage *)imageNamed:(NSString *)name withCapInsets:(UIEdgeInsets)capInsets
{
    UIImage *image = [UIImage imageNamed:name];
    return [image resizableImageWithCapInsets:capInsets];
}

/// 判断图片格式
- (BOOL) imageHasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/// image转base64
- (NSString *) base64ImageStr {
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha])
    {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    }
    else
    {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"%@", [imageData base64EncodedStringWithOptions: 0]];
    
}

-(UIImage *)scaledImage{
    
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    if (height /width >0.75) {
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(0, 0, width, width*0.75));
        CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
        UIGraphicsBeginImageContextWithOptions(smallBounds.size, NO, 0.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, smallBounds, subImageRef);
        UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        
        return smallImage;
        
    }else{
        
        return self;
        
    }
    
}

- (UIImage*)getSmallImage {
    
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    if ((float)data.length/1024 > 1000) {
        data = UIImageJPEGRepresentation(self, 1024*1000.0/(float)data.length);
    }
    
    return   [UIImage imageWithData:data];
    
    
}


+ (UIImage *)resizableImageWithImageName:(NSString *)imageName{
    UIImage * image=[UIImage imageNamed:imageName];
    
    CGFloat w = 30;
    CGFloat h = 30;
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return image;
}

@end
