//
//  UIButton+NDButtonPosition.h
//  NDBaseProject
//
//  Created by WenhuaLuo on  2017/3/17.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import <UIKit/UIKit.h>
// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, WMButtonEdgeInsetsStyle) {
    WMButtonEdgeInsetsStyleTop, // image在上，label在下
    WMButtonEdgeInsetsStyleLeft, // image在左，label在右
    WMButtonEdgeInsetsStyleBottom, // image在下，label在上
    WMButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (NDButtonPosition)

/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(WMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/**
 *  基础按钮：字体，字体颜色，背景色，事件
 */
+ (instancetype)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor selectColor:(UIColor *)selectColor normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage backGroundColor:(UIColor *)bgColor buttonTag:(NSInteger)tag target:(id)target action:(SEL)action showView:(UIView *)showView edgeInsetsStyle:(id)style
                imageTitleSpace:(CGFloat)space;

@end
