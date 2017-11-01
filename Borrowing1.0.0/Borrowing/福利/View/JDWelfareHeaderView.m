
//
//  JDWelfareHeaderView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDWelfareHeaderView.h"

@interface JDWelfareHeaderView ()<SDCycleScrollViewDelegate>

/**轮播图*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/**信用卡申请通道*/
@property (nonatomic, strong) UIButton *creditCardBtn;
/**保险申请通道*/
@property (nonatomic, strong) UIButton *insuranceBtn;


@end

@implementation JDWelfareHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self cycleScrollView];
        [self creditCardBtn];
        [self insuranceBtn];
    }
    return self;
}

- (void)setBannerArr:(NSArray *)bannerArr
{
    _bannerArr = bannerArr;
    
    self.cycleScrollView.imageURLStringsGroup = bannerArr;
}
#pragma mark ---- banner点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(welfareHeaderViewCycleScrollView:didSelectItemAtIndex:)]) {
        
        [self.delegate welfareHeaderViewCycleScrollView:cycleScrollView didSelectItemAtIndex:index];
    }
}

#pragma mark - 信用卡申请通道
- (void)creditCardBtnClick
{
    if ([self.delegate respondsToSelector:@selector(welfareHeaderViewDidSelectCreditCardBtn)]) {
        
        [self.delegate welfareHeaderViewDidSelectCreditCardBtn];
    }
}

#pragma mark - 保险通道
- (void)insuranceBtnClick
{
    if ([self.delegate respondsToSelector:@selector(welfareHeaderViewDidSelectInsuranceBtn)]) {
        
        [self.delegate welfareHeaderViewDidSelectInsuranceBtn];
    }
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        
        _cycleScrollView.autoScrollTimeInterval = 4;
        
        _cycleScrollView.delegate = self;
        
        _cycleScrollView.pageDotColor = GrayContentColor;
        
        _cycleScrollView.currentPageDotColor = [UIColor redColor];
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"首页广告位"]];
        
        [self addSubview:_cycleScrollView];
        
        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(KActualH(200));
        }];
    }
    return _cycleScrollView;
}

- (UIButton *)creditCardBtn
{
    if (!_creditCardBtn) {
        
        _creditCardBtn = [UIButton buttonWithHeadImage:@"welfare_vip" target:self action:@selector(creditCardBtnClick) showView:self];
        
        [_creditCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.cycleScrollView.mas_bottom).mas_equalTo(4);
            make.left.mas_equalTo(4);
            make.width.mas_equalTo((kWindowW - 12)*0.5);
            make.height.mas_equalTo(KActualH(175));
        }];
        
        UILabel *lable = [UILabel labelWithText:@"信用卡申请" font:kFont(16) textColor:WhiteColor backGroundColor:ClearColor superView:_creditCardBtn];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-kMargin);
        }];
    }
    return _creditCardBtn;
}

- (UIButton *)insuranceBtn
{
    if (!_insuranceBtn) {
        
        _insuranceBtn = [UIButton buttonWithHeadImage:@"welfare_Insurance" target:self action:@selector(insuranceBtnClick) showView:self];
        
        [_insuranceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.creditCardBtn.mas_top);
            make.right.mas_equalTo(-4);
            make.width.mas_equalTo((kWindowW - 12)*0.5);
            make.height.mas_equalTo(KActualH(175));
            
        }];
        
        UILabel *lable = [UILabel labelWithText:@"0元领保险" font:kFont(16) textColor:WhiteColor backGroundColor:ClearColor superView:_insuranceBtn];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-kMargin);
        }];
    }
    return _insuranceBtn;
}

@end
