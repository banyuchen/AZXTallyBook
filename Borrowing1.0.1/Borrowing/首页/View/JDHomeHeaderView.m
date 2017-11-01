//
//  JDHomeHeaderView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/23.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDHomeHeaderView.h"
#import "JDHomeHeaderButtonView.h"

@interface JDHomeHeaderView ()<SDCycleScrollViewDelegate,JDHomeHeaderButtonViewDelegate>

/**轮播图*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/**icon*/
@property (nonatomic, strong) JDHomeHeaderButtonView *buttonView;

@end

@implementation JDHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        [self cycleScrollView];
//        [self buttonView];
    }
    return self;
}

- (void)setIconArr:(NSArray<JDIcon_M *> *)iconArr
{
    _iconArr = iconArr;
    
    self.buttonView.iconArr = iconArr;
}

- (void)setBannerArr:(NSArray *)bannerArr
{
    _bannerArr = bannerArr;
    
    self.cycleScrollView.imageURLStringsGroup = bannerArr;
}

#pragma mark - icon点击事件
- (void)homeHeaderButtonViewDidButton:(JDIcon_M *)icon
{
    if ([self.delegate respondsToSelector:@selector(homeHeaderViewDidSelectIcon:)]) {
        
        [self.delegate homeHeaderViewDidSelectIcon:icon];
    }
}

#pragma SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(homeHeaderViewDidSelctCycleScrollView:didSelectItemAtIndex:)]) {
        
        [self.delegate homeHeaderViewDidSelctCycleScrollView:cycleScrollView didSelectItemAtIndex:index];
    }
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        
        _cycleScrollView.autoScrollTimeInterval = 8;
        
        _cycleScrollView.delegate = self;
        
        _cycleScrollView.pageDotColor = GrayContentColor;
        
        _cycleScrollView.currentPageDotColor = [UIColor redColor];
        
        _cycleScrollView.backgroundColor = WhiteColor;
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
        
        [self addSubview:_cycleScrollView];
        
        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(KActualH(200));
        }];
    }
    return _cycleScrollView;
}

- (JDHomeHeaderButtonView *)buttonView
{
    if (!_buttonView) {
        
        _buttonView = [[JDHomeHeaderButtonView alloc] initWithFrame:CGRectMake(0, KActualH(200), kWindowW, 85*ceil(self.iconArr.count/4.0))];
        
        _buttonView.delegate = self;
        
        [self addSubview:_buttonView];
        
    }
    return _buttonView;
}

@end
