//
//  UIImage+Custom.h
//  SuperInstruction
//
//  Created by WenhuaLuo on 15/11/27.
//  Copyright © 2015年 WenhuaLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)
/**
 *  利用颜色填充的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  背景虚化
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/**
 *  对图片尺寸进行压缩
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  截取视频的预览图
 */
+ (UIImage *)imageWithVideo:(NSURL *)videoURL;

/**
 *  //截取部分图像
 */
+(UIImage*)getSubImage:(UIImage *)bigImage  toSize:(CGRect)frame;

//等比例缩放
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end
