//
//  DDPCAView.h
//  DingTalent
//
//  Created by WenhuaLuo on 17/4/20.
//  Copyright © 2017年 Nado. All rights reserved.
//带有省市区的选择器

#import <UIKit/UIKit.h>

#define kPCAHeight 240

@protocol PCAViewDelegate <NSObject>
//[provinceID, cityID, areaID, provinceName, cityName, areaName]
- (void)pcaViewDidSelectResult:(NSDictionary *)resultDict;

@end

@interface DDPCAView : UIView

- (void)show;

- (void)dismiss;

- (instancetype)initWithDelegate:(id/**PCAViewDelegate*/)delegate showSection:(NSInteger)section;

@property(nonatomic,weak) id<PCAViewDelegate> pcaDelegate;

@end
