//
//  UIButton+NDButtonPosition.m
//  NDBaseProject
//
//  Created by WenhuaLuo on  2017/3/17.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import "UIButton+NDButtonPosition.h"
@implementation UIButton (NDButtonPosition)
- (void)layoutButtonWithEdgeInsetsStyle:(WMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     * 知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     * 如果只有title，那它上下左右都是相对于button的，image也是一样；
     * 如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    /**
     MKButtonEdgeInsetsStyleTop, // image在上，label在下
     MKButtonEdgeInsetsStyleLeft, // image在左，label在右
     MKButtonEdgeInsetsStyleBottom, // image在下，label在上
     MKButtonEdgeInsetsStyleRight // image在右，label在左
     */
    switch (style) {
        case WMButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case WMButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case WMButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case WMButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor selectColor:(UIColor *)selectColor normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage backGroundColor:(UIColor *)bgColor buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView edgeInsetsStyle:(id)style imageTitleSpace:(CGFloat)space
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = tag;
    
    btn.titleLabel.numberOfLines = 0;
    
    btn.clipsToBounds = YES;
    
    btn.layer.masksToBounds = YES;
    
    if (![title isEqualToString:@""] && title) {
        
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
        
        [btn setTitle:title forState:UIControlStateNormal];
        
        btn.titleLabel.font = font;
    }
    
    if (![normalImage isEqualToString:@""] && normalImage) {
        [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
    
    if (![selectImage isEqualToString:@""] && selectImage) {
        [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateNormal];
    }
    
    if (bgColor) {
        btn.backgroundColor = bgColor;
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (style) {
        
        [btn layoutButtonWithEdgeInsetsStyle:(WMButtonEdgeInsetsStyle)style imageTitleSpace:space];
    }
    
    [showView addSubview:btn];
    
    
    return btn;
}
@end
