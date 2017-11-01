//
//  JDHomeHeaderView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDIcon_M.h"

@protocol JDHomeHeaderViewDelegate <NSObject>

- (void)homeHeaderViewDidSelectIcon:(JDIcon_M *)icon;
- (void)homeHeaderViewDidSelctCycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface JDHomeHeaderView : UIView

/**bannerArr*/
@property (nonatomic, strong) NSArray *bannerArr;
/**iconArr*/
@property (nonatomic, strong) NSArray<JDIcon_M *> *iconArr;

/**<#name#>*/
@property (nonatomic, weak) id<JDHomeHeaderViewDelegate> delegate;

@end
