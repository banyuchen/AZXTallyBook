//
//  UIImageView+YYZCustom.h
//  UNiZhao
//
//  Created by WenhuaLuo on 16/8/30.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YYZCustom)

+ (instancetype)imageViewWithDefaultImage:(NSString *)image gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer superView:(UIView *)superView;

@end
