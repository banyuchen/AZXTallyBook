//
//  JDWelfareHeaderView.h
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDWelfareHeaderViewDelegate <NSObject>

- (void)welfareHeaderViewDidSelectCreditCardBtn;
- (void)welfareHeaderViewDidSelectInsuranceBtn;
- (void)welfareHeaderViewCycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface JDWelfareHeaderView : UIView

/**bannerArr*/
@property (nonatomic, strong) NSArray *bannerArr;
/**代理*/
@property (nonatomic, weak) id<JDWelfareHeaderViewDelegate> delegate;

@end
