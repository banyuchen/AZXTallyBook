//
//  JDInterfaceFooterView.m
//  Borrowing
//
//  Created by Sierra on 2017/8/22.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDInterfaceFooterView.h"

@interface JDInterfaceFooterView ()

/**去借款按钮*/
@property (nonatomic, strong) UIButton *goBorrowBtn;
/**文字说明背景*/
@property (nonatomic, strong) UIView *wordBgView;
/**文字说明*/
@property (nonatomic, strong) UILabel *wordLbl;
@end

@implementation JDInterfaceFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self goBorrowBtn];
        
        [self wordLbl];
    }
    return self;
}

- (void)goBorrowBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(interfaceFooterViewDidGoBorrowBtn)]) {
        
        [self.delegate interfaceFooterViewDidGoBorrowBtn];
    }
}

- (UIButton *)goBorrowBtn
{
    if (!_goBorrowBtn) {
        
        _goBorrowBtn = [UIButton buttonWithTitle:@"去借款" font:kFont(18) titleColor:WhiteColor backGroundColor:RGBCOLOR(31, 144, 230) buttonTag:0 target:self action:@selector(goBorrowBtnClick) showView:self];
        
        _goBorrowBtn.layer.masksToBounds = YES;
        
        _goBorrowBtn.layer.cornerRadius = 5;
        
        [_goBorrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.wordBgView.mas_bottom).mas_equalTo(20);
            
            make.centerX.mas_equalTo(0);
            
            make.size.mas_equalTo(CGSizeMake(kWindowW - 4*kMargin, 45));
        }];
    }
    return _goBorrowBtn;
}

- (UIView *)wordBgView
{
    if (!_wordBgView) {
        
        _wordBgView = [UIView viewWithBackgroundColor:RGBCOLOR(49, 166, 252) superView:self];
        
        [_wordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
    }
    return _wordBgView;
}

- (UILabel *)wordLbl
{
    if (!_wordLbl) {
        
        _wordLbl = [UILabel labelWithText:@"日利率万5(1千元用1天利息只需0.5元)" font:kFont(15) textColor:WhiteColor backGroundColor:ClearColor superView:self.wordBgView];
        
        [_wordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(kMargin);
            
            make.centerY.mas_equalTo(0);
        }];
    }
    return _wordLbl;
}
@end
