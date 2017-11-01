//
//  UIBarButtonItem+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}



+ (NSArray *)itemWithTarget:(id)target action:(SEL)action leftImage:(NSString *)leftImage selectImage:(NSString *)selectImage title:(NSString *)title titleColor:(UIColor *)titleColor isRightItem:(BOOL)isRight titleFont:(UIFont *)titleFont  createdButton:(void (^ __nullable)(CustomButton *button))createdButton
{
    CustomButton *btn = [CustomButton buttonWithRightImage:leftImage?leftImage:@"" title:title?title:@"" font:titleFont titleColor:titleColor bgColor:[UIColor clearColor] target:target action:action buttonH:40 showView:nil];//[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.contentHorizontalAlignment = isRight ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
    
    btn.contentEdgeInsets = isRight ? UIEdgeInsetsMake(0, 0, 0, 13) : UIEdgeInsetsMake(0, 13, 0, 0);
    
    CGFloat width = 60;
    
    CGFloat titleW = [NSString sizeWithText:btn.currentTitle font:titleFont maxSize:CGSizeMake(MAXFLOAT, 40)].width;
    
    if (leftImage && title) {
        width = titleW+btn.currentImage.size.width+20;
    }
    else if (leftImage && !title)
    {
        width = btn.currentImage.size.width+20;
    }
    else if (!leftImage && title)
    {
        width = titleW+20;
    }
    /*
    if (leftImage && title) {
        width = 110;
    }*/
    btn.frame = CGRectMake(0, 0, width, 40);
    
    if (createdButton) {
        createdButton(btn);
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = isRight ? -15 : -15;
    
    return isRight ? @[spaceItem, item] : @[spaceItem, item];
}


@end
