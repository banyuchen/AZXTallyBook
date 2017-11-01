//
//  TextImageView.h
//  NDBaseProject
//
//  Created by WenhuaLuo on 17/6/1.
//  Copyright © 2017年 WenhuaLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextImageBlock)(NSString *);

@interface TextImageView : UIView

//点击事件
@property (nonatomic, copy) TextImageBlock textImageBlock;

- (void)viewWithImageName:(NSString *)image title:(NSString *)title tag:(NSString *)keyTag titleFont:(UIFont *)font titleColor:(UIColor *)color;

- (void)viewWithNum:(NSInteger)num numColor:(UIColor *)color;

@property (nonatomic, strong) UIImageView *topImg;

@property (nonatomic, strong) UILabel *tipLbl;

@end
