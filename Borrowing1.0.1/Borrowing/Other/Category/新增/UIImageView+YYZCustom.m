//
//  UIImageView+YYZCustom.m
//  UNiZhao
//
//  Created by WenhuaLuo on 16/8/30.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import "UIImageView+YYZCustom.h"

@implementation UIImageView (YYZCustom)

+ (instancetype)imageViewWithDefaultImage:(NSString *)image gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer superView:(UIView *)superView
{
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    
    img.contentMode = UIViewContentModeScaleAspectFill;
    
    img.layer.masksToBounds = YES;
    
    if (gestureRecognizer) {
        [img addGestureRecognizer:gestureRecognizer];
    }
    
    
    img.userInteractionEnabled = YES;
    
    [superView addSubview:img];
    
    return img;
}

@end
